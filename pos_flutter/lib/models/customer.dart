class Customer {
  final String id;
  final String name;
  final String? phone;
  final String? address;
  final String? notes;
  final double creditLimit;
  final double balance; // Positive = owes us, Negative = we owe them
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    this.notes,
    this.creditLimit = 0,
    this.balance = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'notes': notes,
      'credit_limit': creditLimit,
      'balance': balance,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'],
      address: map['address'],
      notes: map['notes'],
      creditLimit: (map['credit_limit'] ?? 0).toDouble(),
      balance: (map['balance'] ?? 0).toDouble(),
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at']) 
          : DateTime.now(),
    );
  }

  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? notes,
    double? creditLimit,
    double? balance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      creditLimit: creditLimit ?? this.creditLimit,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasCreditLimit => creditLimit > 0;
  
  double get availableCredit => hasCreditLimit ? creditLimit - balance : double.infinity;
  
  bool get canExtendCredit => !hasCreditLimit || balance < creditLimit;
}

class CustomerTransaction {
  final String id;
  final String customerId;
  final String type; // 'deposit' or 'withdrawal'
  final double amount;
  final String? notes;
  final String? referenceId; // Reference to sale or other transaction
  final DateTime createdAt;
  final String createdBy;

  CustomerTransaction({
    required this.id,
    required this.customerId,
    required this.type,
    required this.amount,
    this.notes,
    this.referenceId,
    required this.createdAt,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'type': type,
      'amount': amount,
      'notes': notes,
      'reference_id': referenceId,
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
    };
  }

  factory CustomerTransaction.fromMap(Map<String, dynamic> map) {
    return CustomerTransaction(
      id: map['id'] ?? '',
      customerId: map['customer_id'] ?? '',
      type: map['type'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      notes: map['notes'],
      referenceId: map['reference_id'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
      createdBy: map['created_by'] ?? '',
    );
  }
}
