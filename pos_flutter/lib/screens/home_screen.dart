import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import 'pos_screen.dart';
import 'dashboard_screen.dart';
import 'products_screen.dart';
import 'customers_screen.dart';
import 'users_screen.dart';
import 'expenses_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [];
  final List<NavigationRailDestination> _destinations = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildNavigation();
  }

  void _buildNavigation() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    _screens.clear();
    _destinations.clear();

    // POS Screen (always available)
    _screens.add(const POSScreen());
    _destinations.add(const NavigationRailDestination(
      icon: Icon(Icons.point_of_sale_outlined),
      selectedIcon: Icon(Icons.point_of_sale),
      label: Text('فروش'),
    ));

    // Dashboard (if user has access)
    if (user?.canAccessDashboard() ?? false) {
      _screens.add(const DashboardScreen());
      _destinations.add(const NavigationRailDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: Text('داشبورد'),
      ));
    }

    // Products (if user has full access)
    if (user?.canAccessFull() ?? false) {
      _screens.add(const ProductsScreen());
      _destinations.add(const NavigationRailDestination(
        icon: Icon(Icons.inventory_2_outlined),
        selectedIcon: Icon(Icons.inventory_2),
        label: Text('محصولات'),
      ));
    }

    // Customers (if user has full access)
    if (user?.canAccessFull() ?? false) {
      _screens.add(const CustomersScreen());
      _destinations.add(const NavigationRailDestination(
        icon: Icon(Icons.people_outlined),
        selectedIcon: Icon(Icons.people),
        label: Text('مشتریان'),
      ));
    }

    // Users (admin only)
    if (user?.role == 'admin') {
      _screens.add(const UsersScreen());
      _destinations.add(const NavigationRailDestination(
        icon: Icon(Icons.admin_panel_settings_outlined),
        selectedIcon: Icon(Icons.admin_panel_settings),
        label: Text('کاربران'),
      ));
    }

    // Expenses (if user has full access)
    if (user?.canAccessFull() ?? false) {
      _screens.add(const ExpensesScreen());
      _destinations.add(const NavigationRailDestination(
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long),
        label: Text('هزینه‌ها'),
      ));
    }

    // Ensure selected index is valid
    if (_selectedIndex >= _screens.length) {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.of(context).size.width > 600,
            destinations: _destinations,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            leading: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF14C586), Color(0xFF067A55)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryLight.withOpacity(0.5),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.storefront,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppConstants.appName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.brightness_6),
                      onPressed: () {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                      },
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        Provider.of<AuthProvider>(context, listen: false).logout();
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _screens.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : IndexedStack(
                    index: _selectedIndex,
                    children: _screens,
                  ),
          ),
        ],
      ),
    );
  }
}
