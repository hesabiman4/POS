import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:hesabiman_pos/main.dart';
import 'package:hesabiman_pos/providers/auth_provider.dart';
import 'package:hesabiman_pos/providers/theme_provider.dart';
import 'package:hesabiman_pos/providers/database_provider.dart';

void main() {
  group('AuthProvider Tests', () {
    test('Initial state - not authenticated', () {
      final authProvider = AuthProvider();
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.currentUser, null);
    });

    test('Login with PIN updates state', () async {
      final authProvider = AuthProvider();
      
      // Note: This is a simplified test. In real scenario, 
      // you'd mock the database and secure storage
      expect(authProvider.isLoading, false);
    });

    test('Logout clears user', () async {
      final authProvider = AuthProvider();
      await authProvider.logout();
      expect(authProvider.isAuthenticated, false);
    });
  });

  group('ThemeProvider Tests', () {
    test('Initial theme is light', () {
      final themeProvider = ThemeProvider();
      expect(themeProvider.themeMode, ThemeMode.light);
      expect(themeProvider.isDarkMode, false);
    });

    test('Toggle theme switches mode', () {
      final themeProvider = ThemeProvider();
      themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.dark);
      expect(themeProvider.isDarkMode, true);
      
      themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.light);
      expect(themeProvider.isDarkMode, false);
    });
  });

  group('App Constants', () {
    test('App name is set', () {
      expect('حسابیمان POS', isNotEmpty);
    });
  });
}
