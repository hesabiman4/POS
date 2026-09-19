import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;
  double? customPrice;
  double? discount;
  String? notes;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.customPrice,
    this.discount,
    this.notes,
  });

  double get unitPrice => customPrice ?? product.sellPrice;
  
  double get subtotal => unitPrice * quantity;
  
  double get totalDiscount => discount ?? 0;
  
  double get total => subtotal - totalDiscount;
  
  double get profit => (unitPrice - product.costPerItem) * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': product.id,
      'product_name': product.name,
      'quantity': quantity,
      'unit_price': unitPrice,
      'discount': discount,
      'notes': notes,
    };
  }

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    double? customPrice,
    double? discount,
    String? notes,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      customPrice: customPrice ?? this.customPrice,
      discount: discount ?? this.discount,
      notes: notes ?? this.notes,
    );
  }
}

class HeldOrder {
  final String id;
  final List<CartItem> items;
  final String? customerId;
  final String? customerName;
  final DateTime createdAt;
  final String? notes;

  HeldOrder({
    required this.id,
    required this.items,
    this.customerId,
    this.customerName,
    required this.createdAt,
    this.notes,
  });

  double get total => items.fold(0, (sum, item) => sum + item.total);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((i) => i.toMap()).toList(),
      'customer_id': customerId,
      'customer_name': customerName,
      'created_at': createdAt.toIso8601String(),
      'notes': notes,
    };
  }

  factory HeldOrder.fromMap(Map<String, dynamic> map) {
    return HeldOrder(
      id: map['id'] ?? '',
      items: (map['items'] as List?)
              ?.map((i) => CartItem(
                    id: i['id'] ?? '',
                    product: Product(
                      id: i['product_id'] ?? '',
                      name: i['product_name'] ?? '',
                      buyPrice: 0,
                      sellPrice: (i['unit_price'] ?? 0).toDouble(),
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                    quantity: i['quantity'] ?? 1,
                    customPrice: i['unit_price']?.toDouble(),
                    discount: i['discount']?.toDouble(),
                    notes: i['notes'],
                  ))
              .toList() ??
          [],
      customerId: map['customer_id'],
      customerName: map['customer_name'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
      notes: map['notes'],
    );
  }
}
