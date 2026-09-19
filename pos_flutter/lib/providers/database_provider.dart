import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../models/product.dart';
import '../models/customer.dart';
import '../models/sale.dart';
import '../utils/constants.dart';

class DatabaseProvider extends ChangeNotifier {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        pin_code TEXT,
        role TEXT NOT NULL DEFAULT 'cashier',
        permissions TEXT,
        scope_level INTEGER DEFAULT 3,
        is_active INTEGER DEFAULT 1,
        created_at TEXT NOT NULL
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        parent_id TEXT,
        business_type TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Products table
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        barcode TEXT,
        category_id TEXT,
        subcategory_id TEXT,
        business_type TEXT,
        buy_price REAL NOT NULL,
        sell_price REAL NOT NULL,
        stock_quantity INTEGER DEFAULT 0,
        buy_unit_quantity INTEGER DEFAULT 1,
        buy_unit TEXT DEFAULT 'unit',
        sale_unit TEXT DEFAULT 'unit',
        image_path TEXT,
        is_visible INTEGER DEFAULT 1,
        expiry_date TEXT,
        reorder_level INTEGER DEFAULT 5,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories(id)
      )
    ''');

    // Customers table
    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        notes TEXT,
        credit_limit REAL DEFAULT 0,
        balance REAL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Customer transactions table
    await db.execute('''
      CREATE TABLE customer_transactions (
        id TEXT PRIMARY KEY,
        customer_id TEXT NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        notes TEXT,
        reference_id TEXT,
        created_at TEXT NOT NULL,
        created_by TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES customers(id)
      )
    ''');

    // Sales table
    await db.execute('''
      CREATE TABLE sales (
        id TEXT PRIMARY KEY,
        invoice_number TEXT NOT NULL UNIQUE,
        date TEXT NOT NULL,
        customer_id TEXT,
        customer_name TEXT,
        items TEXT NOT NULL,
        subtotal REAL NOT NULL,
        discount REAL DEFAULT 0,
        discount_type TEXT,
        total REAL NOT NULL,
        payment_type TEXT NOT NULL,
        amount_received REAL NOT NULL,
        change_due REAL DEFAULT 0,
        credit_amount REAL DEFAULT 0,
        seller_id TEXT,
        seller_name TEXT,
        notes TEXT,
        is_refunded INTEGER DEFAULT 0,
        refunded_at TEXT,
        refunded_by TEXT,
        business_type TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Expenses/Income table
    await db.execute('''
      CREATE TABLE expenses (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        description TEXT NOT NULL,
        category TEXT,
        date TEXT NOT NULL,
        created_by TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Shifts table
    await db.execute('''
      CREATE TABLE shifts (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        opened_at TEXT NOT NULL,
        closed_at TEXT,
        opening_balance REAL DEFAULT 0,
        closing_balance REAL,
        cash_received REAL DEFAULT 0,
        credit_sales REAL DEFAULT 0,
        refunds_total REAL DEFAULT 0,
        deposits_total REAL DEFAULT 0,
        withdrawals_total REAL DEFAULT 0,
        expected_total REAL,
        actual_total REAL,
        notes TEXT,
        status TEXT DEFAULT 'open'
      )
    ''');

    // Held orders table
    await db.execute('''
      CREATE TABLE held_orders (
        id TEXT PRIMARY KEY,
        items TEXT NOT NULL,
        customer_id TEXT,
        customer_name TEXT,
        created_at TEXT NOT NULL,
        notes TEXT,
        created_by TEXT
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_products_barcode ON products(barcode)');
    await db.execute('CREATE INDEX idx_products_category ON products(category_id)');
    await db.execute('CREATE INDEX idx_sales_date ON sales(date)');
    await db.execute('CREATE INDEX idx_sales_customer ON sales(customer_id)');
    await db.execute('CREATE INDEX idx_expenses_date ON expenses(date)');

    // Insert default admin user
    final now = DateTime.now().toIso8601String();
    await db.insert('users', {
      'id': 'admin_001',
      'name': 'Administrator',
      'username': 'admin',
      'pin_code': null,
      'role': 'admin',
      'permissions': '[]',
      'scope_level': 3,
      'is_active': 1,
      'created_at': now,
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    if (oldVersion < newVersion) {
      // Add migration logic as needed
    }
  }

  Future<void> initDatabase() async {
    await database;
    notifyListeners();
  }

  // User operations
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query('users', orderBy: 'created_at DESC');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<User?> getUserById(String id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(String id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Product operations
  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final maps = await db.query('products', orderBy: 'name ASC');
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product?> getProductById(String id) async {
    final db = await database;
    final maps = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    final db = await database;
    final maps = await db.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(String id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateStock(String productId, int quantityChange) async {
    final db = await database;
    return await db.rawUpdate(
      'UPDATE products SET stock_quantity = stock_quantity + ?, updated_at = ? WHERE id = ?',
      [quantityChange, DateTime.now().toIso8601String(), productId],
    );
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
