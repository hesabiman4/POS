import 'dart:convert';

class User {
  final String id;
  final String name;
  final String username;
  final String? pinCode;
  final String role;
  final List<String> permissions;
  final int scopeLevel; // 1: POS only, 2: POS + Dashboard, 3: Full access
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.username,
    this.pinCode,
    required this.role,
    this.permissions = const [],
    this.scopeLevel = 3,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'pin_code': pinCode,
      'role': role,
      'permissions': jsonEncode(permissions),
      'scope_level': scopeLevel,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      pinCode: map['pin_code'],
      role: map['role'] ?? 'cashier',
      permissions: map['permissions'] != null 
          ? List<String>.from(jsonDecode(map['permissions'])) 
          : [],
      scopeLevel: map['scope_level'] ?? 3,
      isActive: map['is_active'] == 1,
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? username,
    String? pinCode,
    String? role,
    List<String>? permissions,
    int? scopeLevel,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      pinCode: pinCode ?? this.pinCode,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      scopeLevel: scopeLevel ?? this.scopeLevel,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool hasPermission(String permission) {
    if (role == 'admin') return true;
    return permissions.contains(permission);
  }

  bool canAccessDashboard() {
    return scopeLevel >= 2 || role == 'admin' || role == 'manager';
  }

  bool canAccessFull() {
    return scopeLevel >= 3 || role == 'admin';
  }
}
