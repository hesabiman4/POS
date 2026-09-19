import 'package:flutter/material.dart';

import '../models/customer.dart';
import 'database_provider.dart';

class CustomerProvider extends ChangeNotifier {
  final DatabaseProvider dbProvider;
  
  List<Customer> _customers = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  CustomerProvider(this.dbProvider);

  List<Customer> get customers => _filteredCustomers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  List<Customer> get _filteredCustomers {
    if (_searchQuery.isEmpty) return _customers;
    
    return _customers.where((c) {
      final nameMatch = c.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final phoneMatch = c.phone?.contains(_searchQuery) ?? false;
      return nameMatch || phoneMatch;
    }).toList();
  }

  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      // In real app, fetch from database
      // For now, empty list
      _customers = [];
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addCustomer(Customer customer) async {
    _isLoading = true;
    notifyListeners();

    try {
      // In real app, insert to database
      _customers.add(customer);
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

  Future<bool> updateCustomer(Customer customer) async {
    _isLoading = true;
    notifyListeners();

    try {
      final index = _customers.indexWhere((c) => c.id == customer.id);
      if (index >= 0) {
        _customers[index] = customer;
      }
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

  Future<bool> deleteCustomer(String customerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _customers.removeWhere((c) => c.id == customerId);
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

  Customer? getCustomerById(String id) {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  void updateCustomerBalance(String customerId, double amountChange) {
    final index = _customers.indexWhere((c) => c.id == customerId);
    if (index >= 0) {
      final customer = _customers[index];
      _customers[index] = customer.copyWith(
        balance: customer.balance + amountChange,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }
}
