import 'dart:convert';

class Sale {
  final String id;
  final String invoiceNumber;
  final DateTime date;
  final String? customerId;
  final String? customerName;
  final List<SaleItem> items;
  final double subtotal;
  final double discount;
  final String? discountType; // 'percent' or 'amount'
  final double total;
  final String paymentType; // 'cash', 'half', 'custom', 'credit'
  final double amountReceived;
  final double changeDue;
  final double creditAmount;
  final String? sellerId;
  final String? sellerName;
  final String? notes;
  final bool isRefunded;
  final DateTime? refundedAt;
  final String? refundedBy;
  final String? businessType;
  final DateTime createdAt;

  Sale({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    this.customerId,
    this.customerName,
    required this.items,
    required this.subtotal,
    this.discount = 0,
    this.discountType,
    required this.total,
    required this.paymentType,
    required this.amountReceived,
    required this.changeDue,
    this.creditAmount = 0,
    this.sellerId,
    this.sellerName,
    this.notes,
    this.isRefunded = false,
    this.refundedAt,
    this.refundedBy,
    this.businessType,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'date': date.toIso8601String(),
      'customer_id': customerId,
      'customer_name': customerName,
      'items': jsonEncode(items.map((i) => i.toMap()).toList()),
      'subtotal': subtotal,
      'discount': discount,
      'discount_type': discountType,
      'total': total,
      'payment_type': paymentType,
      'amount_received': amountReceived,
      'change_due': changeDue,
      'credit_amount': creditAmount,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'notes': notes,
      'is_refunded': isRefunded ? 1 : 0,
      'refunded_at': refundedAt?.toIso8601String(),
      'refunded_by': refundedBy,
      'business_type': businessType,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'] ?? '',
      invoiceNumber: map['invoice_number'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      customerId: map['customer_id'],
      customerName: map['customer_name'],
      items: map['items'] != null
          ? (jsonDecode(map['items']) as List)
              .map((i) => SaleItem.fromMap(i))
              .toList()
          : [],
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      discountType: map['discount_type'],
      total: (map['total'] ?? 0).toDouble(),
      paymentType: map['payment_type'] ?? 'cash',
      amountReceived: (map['amount_received'] ?? 0).toDouble(),
      changeDue: (map['change_due'] ?? 0).toDouble(),
      creditAmount: (map['credit_amount'] ?? 0).toDouble(),
      sellerId: map['seller_id'],
      sellerName: map['seller_name'],
      notes: map['notes'],
      isRefunded: map['is_refunded'] == 1,
      refundedAt: map['refunded_at'] != null 
          ? DateTime.parse(map['refunded_at']) 
          : null,
      refundedBy: map['refunded_by'],
      businessType: map['business_type'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
    );
  }

  double get profit => items.fold(0, (sum, item) => sum + item.profit);
}

class SaleItem {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double costPrice;
  final double discount;
  final double total;

  SaleItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.costPrice,
    this.discount = 0,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'cost_price': costPrice,
      'discount': discount,
      'total': total,
    };
  }

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      productName: map['product_name'] ?? '',
      quantity: map['quantity'] ?? 1,
      unitPrice: (map['unit_price'] ?? 0).toDouble(),
      costPrice: (map['cost_price'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
    );
  }

  double get profit => (unitPrice - costPrice) * quantity;
}

class Expense {
  final String id;
  final String type; // 'expense' or 'income'
  final double amount;
  final String description;
  final String? category;
  final DateTime date;
  final String? createdBy;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    this.category,
    required this.date,
    this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] ?? '',
      type: map['type'] ?? 'expense',
      amount: (map['amount'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      category: map['category'],
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      createdBy: map['created_by'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
    );
  }
}
