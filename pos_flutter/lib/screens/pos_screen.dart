import 'package:flutter/material.dart';

class POSScreen extends StatelessWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نقطه فروش'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('POS Screen - Product grid and cart will be implemented here'),
      ),
    );
  }
}
