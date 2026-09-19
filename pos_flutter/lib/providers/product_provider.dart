import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/customer.dart';
import 'database_provider.dart';

class ProductProvider extends ChangeNotifier {
  final DatabaseProvider _dbProvider;
  
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedBusinessType;
  bool _showOnlyVisible = true;

  ProductProvider(this._dbProvider);

  List<Product> get products => _filteredProducts;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  String? get selectedBusinessType => _selectedBusinessType;

  List<Product> get _filteredProducts {
    var filtered = _products;

    // Filter by visibility
    if (_showOnlyVisible) {
      filtered = filtered.where((p) => p.isVisible).toList();
    }

    // Filter by business type
    if (_selectedBusinessType != null && _selectedBusinessType!.isNotEmpty) {
      filtered = filtered.where((p) => p.businessType == _selectedBusinessType).toList();
    }

    // Filter by category
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      filtered = filtered.where((p) => p.categoryId == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        final nameMatch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
        final barcodeMatch = p.barcode?.contains(_searchQuery) ?? false;
        return nameMatch || barcodeMatch;
      }).toList();
    }

    return filtered;
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _dbProvider.getAllProducts();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    // Load categories from database
    // For now, using empty list
    _categories = [];
    notifyListeners();
  }

  Future<bool> addProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dbProvider.insertProduct(product);
      await loadProducts();
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dbProvider.updateProduct(product);
      await loadProducts();
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dbProvider.deleteProduct(productId);
      await loadProducts();
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String? categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void setBusinessType(String? businessType) {
    _selectedBusinessType = businessType;
    notifyListeners();
  }

  void toggleVisibilityFilter() {
    _showOnlyVisible = !_showOnlyVisible;
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Product? getProductByBarcode(String barcode) {
    try {
      return _products.firstWhere((p) => p.barcode == barcode);
    } catch (e) {
      return null;
    }
  }

  List<Product> get lowStockProducts {
    return _products.where((p) => p.isLowStock).toList();
  }

  List<Product> get outOfStockProducts {
    return _products.where((p) => p.isOutOfStock).toList();
  }

  List<Product> get nearExpiryProducts {
    return _products.where((p) => p.isNearExpiry).toList();
  }
}
