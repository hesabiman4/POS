import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'حسابیمان POS';
  static const String appTagline = 'سیستم فروش هوشمند';
  
  // Database
  static const String dbName = 'hesabiman.db';
  static const int dbVersion = 1;
  
  // Secure Storage Keys
  static const String keyCurrentUser = 'current_user';
  static const String keyUserPin = 'user_pin';
  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme_mode';
  
  // Shared Preferences Keys
  static const String prefWalkinCustomer = 'walkin_customer';
  static const String prefReceiptMode = 'receipt_mode';
  static const String prefThermalPrinter = 'thermal_printer';
  
  // Business Types
  static const List<String> businessTypes = [
    'عمومی',
    'بقالی',
    'لباس فروشی',
    'کافه',
    'رستوران',
    'داروخانه',
    'الکترونیکی',
    'سخت افزار',
  ];
  
  // Payment Types
  static const String paymentCash = 'cash';
  static const String paymentHalf = 'half';
  static const String paymentCustom = 'custom';
  static const String paymentCredit = 'credit';
  
  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleManager = 'manager';
  static const String roleCashier = 'cashier';
  
  // Permissions
  static const String permDiscount = 'discount';
  static const String permRefund = 'refund';
  static const String permPriceEdit = 'price_edit';
  static const String permReports = 'reports';
  
  // Receipt Modes
  static const String receiptNormal = 'normal';
  static const String receiptThermal = 'thermal';
}

class AppColors {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF0EA371);
  static const Color primary2Light = Color(0xFF067A55);
  static const Color accentLight = Color(0xFFF59E0B);
  static const Color dangerLight = Color(0xFFE02424);
  static const Color infoLight = Color(0xFF2563EB);
  static const Color purpleLight = Color(0xFF7C3AED);
  
  // Dark Theme Colors
  static const Color bgDark = Color(0xFF0B1120);
  static const Color surfaceDark = Color(0xFF141D31);
  
  // Common
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

class AppThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: const Color(0xFFEEF1F7),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF6F8FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.primaryLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: const Color(0xFF0B1120),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F1B33),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF141D31),
        elevation: 4,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF182238),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF24304C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF24304C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.primaryLight,
      ),
    );
  }
}
