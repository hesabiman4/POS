import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/sale.dart';
import '../models/cart_item.dart';
import 'database_provider.dart';
import 'cart_provider.dart';
import 'customer_provider.dart';

class SaleProvider extends ChangeNotifier {
  final Uuid _uuid = const Uuid();
  final DatabaseProvider _dbProvider;
  
  List<Sale> _sales = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _startDate;
  DateTime? _endDate;

  SaleProvider(this._dbProvider);

  List<Sale> get sales => _filteredSales;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Sale> get _filteredSales {
    var filtered = _sales;
    
    if (_startDate != null) {
      filtered = filtered.where((s) => s.date.isAfter(_startDate!)).toList();
    }
    
    if (_endDate != null) {
      filtered = filtered.where((s) => s.date.isBefore(_endDate!.add(const Duration(days: 1)))).toList();
    }
    
    return filtered;
  }

  double get totalSales => _filteredSales.fold(0, (sum, sale) => sum + sale.total);
  
  double get totalProfit => _filteredSales.fold(0, (sum, sale) => sum + sale.profit);
  
  int get totalTransactions => _filteredSales.length;

  Future<void> loadSales() async {
    _isLoading = true;
    notifyListeners();

    try {
      // In real app, fetch from database
      _sales = [];
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> completeSale({
    required List<CartItem> items,
    required String paymentType,
    required double amountReceived,
    String? customerId,
    String? customerName,
    double? discount,
    String? discountType,
    String? notes,
    String? sellerId,
    String? sellerName,
    String? businessType,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final subtotal = items.fold(0, (sum, item) => sum + item.subtotal);
      final totalDiscount = discount ?? 0;
      final total = subtotal - totalDiscount;
      
      double changeDue = 0;
      double creditAmount = 0;

      if (paymentType == 'credit') {
        creditAmount = total;
      } else {
        changeDue = amountReceived - total;
        if (changeDue < 0) {
          creditAmount = -changeDue;
          changeDue = 0;
        }
      }

      final sale = Sale(
        id: _uuid.v4(),
        invoiceNumber: 'INV-${DateTime.now().millisecondsSinceEpoch}',
        date: DateTime.now(),
        customerId: customerId,
        customerName: customerName,
        items: items.map((item) => SaleItem(
          id: _uuid.v4(),
          productId: item.product.id,
          productName: item.product.name,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          costPrice: item.product.costPerItem,
          discount: item.discount ?? 0,
          total: item.total,
        )).toList(),
        subtotal: subtotal,
        discount: totalDiscount,
        discountType: discountType,
        total: total,
        paymentType: paymentType,
        amountReceived: amountReceived,
        changeDue: changeDue,
        creditAmount: creditAmount,
        sellerId: sellerId,
        sellerName: sellerName,
        notes: notes,
        businessType: businessType,
        createdAt: DateTime.now(),
      );

      // Save to database (in real app)
      _sales.insert(0, sale);
      
      // Update stock (in real app, call database)
      for (final item in items) {
        await _dbProvider.updateStock(item.product.id, -item.quantity);
      }

      // Update customer balance if credit
      if (creditAmount > 0 && customerId != null) {
        // Update customer balance in database
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

  Future<bool> processRefund(String saleId, List<SaleItem> itemsToRefund) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Process refund logic
      final index = _sales.indexWhere((s) => s.id == saleId);
      if (index >= 0) {
        _sales[index] = _sales[index].copyWith(
          isRefunded: true,
          refundedAt: DateTime.now(),
        );
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

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  void clearDateRange() {
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  Sale? getSaleById(String id) {
    try {
      return _sales.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Sale> getTodaySales() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _sales.where((s) => 
      s.date.isAfter(today.subtract(const Duration(days: 1))) && 
      s.date.isBefore(today.add(const Duration(days: 1)))
    ).toList();
  }

  double get todayTotal => getTodaySales().fold(0, (sum, sale) => sum + sale.total);
}

extension on Sale {
  Sale copyWith({
    bool? isRefunded,
    DateTime? refundedAt,
  }) {
    return Sale(
      id: this.id,
      invoiceNumber: this.invoiceNumber,
      date: this.date,
      customerId: this.customerId,
      customerName: this.customerName,
      items: this.items,
      subtotal: this.subtotal,
      discount: this.discount,
      discountType: this.discountType,
      total: this.total,
      paymentType: this.paymentType,
      amountReceived: this.amountReceived,
      changeDue: this.changeDue,
      creditAmount: this.creditAmount,
      sellerId: this.sellerId,
      sellerName: this.sellerName,
      notes: this.notes,
      isRefunded: isRefunded ?? this.isRefunded,
      refundedAt: refundedAt ?? this.refundedAt,
      refundedBy: this.refundedBy,
      businessType: this.businessType,
      createdAt: this.createdAt,
    );
  }
}
