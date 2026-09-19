import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: product.imagePath != null && product.imagePath!.isNotEmpty
                  ? Image.file(
                      File(product.imagePath!),
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.inventory_2,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.sellPrice.toStringAsFixed(0)} افغانی',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (product.stockQuantity > 0)
                  Text(
                    'موجود: ${product.stockQuantity}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  )
                else
                  const Text(
                    'ناموجود',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
