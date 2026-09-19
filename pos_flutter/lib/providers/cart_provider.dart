import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final Uuid _uuid = const Uuid();
  
  List<CartItem> _items = [];
  String? _selectedCustomerId;
  String? _selectedCustomerName;
  double? _cartDiscount;
  String? _discountType; // 'percent' or 'amount'
  String? _walkinCustomerName;
  List<HeldOrder> _heldOrders = [];

  List<CartItem> get items => _items;
  String? get selectedCustomerId => _selectedCustomerId;
  String? get selectedCustomerName => _selectedCustomerName;
  double? get cartDiscount => _cartDiscount;
  String? get discountType => _discountType;
  String? get walkinCustomerName => _walkinCustomerName;
  List<HeldOrder> get heldOrders => _heldOrders;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => _items.fold(0, (sum, item) => sum + item.subtotal);
  
  double get totalDiscount => _cartDiscount ?? 0;
  
  double get total => subtotal - totalDiscount;
  
  bool get isEmpty => _items.isEmpty;

  // Add product to cart
  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        id: _uuid.v4(),
        product: product,
        quantity: quantity,
      ));
    }
    
    notifyListeners();
  }

  // Remove item from cart
  void removeFromCart(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(itemId);
      return;
    }
    
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  // Increment quantity
  void incrementQuantity(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  // Decrement quantity
  void decrementQuantity(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        notifyListeners();
      } else {
        removeFromCart(itemId);
      }
    }
  }

  // Clear cart
  void clearCart() {
    _items = [];
    _selectedCustomerId = null;
    _selectedCustomerName = null;
    _cartDiscount = null;
    _discountType = null;
    _walkinCustomerName = null;
    notifyListeners();
  }

  // Set customer
  void setCustomer(String? customerId, String? customerName) {
    _selectedCustomerId = customerId;
    _selectedCustomerName = customerName;
    notifyListeners();
  }

  // Set walk-in customer name
  void setWalkinCustomerName(String? name) {
    _walkinCustomerName = name;
    notifyListeners();
  }

  // Apply discount
  void applyDiscount(double value, String type) {
    _cartDiscount = value;
    _discountType = type;
    notifyListeners();
  }

  // Remove discount
  void removeDiscount() {
    _cartDiscount = null;
    _discountType = null;
    notifyListeners();
  }

  // Hold order
  void holdOrder() {
    if (_items.isEmpty) return;
    
    final order = HeldOrder(
      id: _uuid.v4(),
      items: List.from(_items),
      customerId: _selectedCustomerId,
      customerName: _selectedCustomerName ?? _walkinCustomerName,
      createdAt: DateTime.now(),
    );
    
    _heldOrders.add(order);
    clearCart();
    notifyListeners();
  }

  // Recall held order
  void recallOrder(String orderId) {
    final index = _heldOrders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      final order = _heldOrders[index];
      _items = List.from(order.items);
      _selectedCustomerId = order.customerId;
      _selectedCustomerName = order.customerName;
      _heldOrders.removeAt(index);
      notifyListeners();
    }
  }

  // Delete held order
  void deleteHeldOrder(String orderId) {
    _heldOrders.removeWhere((order) => order.id == orderId);
    notifyListeners();
  }

  // Get item by ID
  CartItem? getItemById(String itemId) {
    try {
      return _items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }
}
