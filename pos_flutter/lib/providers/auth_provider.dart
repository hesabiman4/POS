import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import '../utils/constants.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  // Initialize auth state from secure storage
  Future<void> initAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = await _secureStorage.read(key: AppConstants.keyCurrentUser);
      if (userId != null) {
        // Load user from database would happen here
        // For now, we'll just set loading to false
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Login with username and PIN
  Future<bool> loginWithPin(String username, String pin) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // This would query the database for user verification
      // For demo purposes, we'll create a mock user
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: username,
        username: username,
        pinCode: pin,
        role: 'cashier',
        scopeLevel: 2,
        createdAt: DateTime.now(),
      );

      _currentUser = user;
      await _secureStorage.write(
        key: AppConstants.keyCurrentUser,
        value: user.id,
      );

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

  // Login without PIN (for users without PIN set)
  Future<bool> loginWithoutPin(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // In real app, fetch user from database
      final user = User(
        id: userId,
        name: 'User',
        username: userId,
        role: 'cashier',
        createdAt: DateTime.now(),
      );

      _currentUser = user;
      await _secureStorage.write(
        key: AppConstants.keyCurrentUser,
        value: userId,
      );

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

  // Switch user
  Future<void> switchUser(User user) async {
    _currentUser = user;
    await _secureStorage.write(
      key: AppConstants.keyCurrentUser,
      value: user.id,
    );
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    await _secureStorage.delete(key: AppConstants.keyCurrentUser);
    notifyListeners();
  }

  // Check if user has permission
  bool hasPermission(String permission) {
    if (_currentUser == null) return false;
    return _currentUser!.hasPermission(permission);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
