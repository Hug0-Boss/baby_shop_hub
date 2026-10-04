import 'package:flutter/material.dart';
import '../models/product.dart';

class AdminProductsPanel extends StatefulWidget {
  const AdminProductsPanel({super.key});

  @override
  State<AdminProductsPanel> createState() => _AdminProductsPanelState();
}

class _AdminProductsPanelState extends State<AdminProductsPanel> {
  // Starter data — replace with a real fetch once the database is wired up
  final List<Product> _products = [
    Product(id: '1', name: 'Pampers Diapers', price: 12500, stock: 48),
    Product(id: '2', name: 'Baby Carrier', price: 18000, stock: 31),
    Product(id: '3', name: 'Feeding Bottle', price: 3500, stock: 27),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Products',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () => _openProductForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2559),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: _products.isEmpty
              ? const Center(child: Text('No products yet — add one to get started.'))
              : ListView.separated(
            itemCount: _products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _productTile(_products[index]),
          ),
        ),
      ],
    );
  }

  Widget _productTile(Product product) {
    final bool lowStock = product.stock < 10;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text('₦${product.price.toStringAsFixed(0)}'),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${product.stock} in stock',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: lowStock ? Colors.red : Colors.grey.shade600,
                fontWeight: lowStock ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => _openProductForm(existing: product),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            onPressed: () => _confirmDelete(product),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text('Remove "${product.name}" from the catalog?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _products.removeWhere((p) => p.id == product.id));
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openProductForm({Product? existing}) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final priceController = TextEditingController(
      text: existing != null ? existing.price.toStringAsFixed(0) : '',
    );
    final stockController = TextEditingController(
      text: existing != null ? existing.stock.toString() : '',
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Add Product' : 'Edit Product'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product name'),
                validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price (₦)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                (double.tryParse(value ?? '') == null) ? 'Enter a valid number' : null,
              ),
              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock quantity'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                (int.tryParse(value ?? '') == null) ? 'Enter a valid number' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(() {
                if (existing == null) {
                  _products.add(Product(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    price: double.parse(priceController.text),
                    stock: int.parse(stockController.text),
                  ));
                } else {
                  existing.name = nameController.text.trim();
                  existing.price = double.parse(priceController.text);
                  existing.stock = int.parse(stockController.text);
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}