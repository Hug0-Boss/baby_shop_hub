import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class AdminProductsPanel extends StatefulWidget {
  const AdminProductsPanel({super.key});

  @override
  State<AdminProductsPanel> createState() => _AdminProductsPanelState();
}

class _AdminProductsPanelState extends State<AdminProductsPanel> {
  final _service = ProductService();

  List<Product> _products = [];
  List<Category> _categories = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final products = await _service.fetchProducts();
      final categories = await _service.fetchCategories();
      if (!mounted) return;
      setState(() {
        _products = products;
        _categories = categories;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

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
              onPressed:
              (_loading || _error != null) ? null : () => _openProductForm(),
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
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_products.isEmpty) {
      return const Center(
          child: Text('No products yet — add one to get started.'));
    }
    return ListView.separated(
      itemCount: _products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _productTile(_products[index]),
    );
  }

  Widget _productTile(Product product) {
    final bool lowStock = product.stockQuantity < 10;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.categoryName,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₦${product.price.toStringAsFixed(0)}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${product.stockQuantity} left',
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
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text('Remove "${product.name}" from the catalog?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await _service.delete(product.id);
                if (!mounted) return;
                setState(() => _products.removeWhere((p) => p.id == product.id));
              } on ApiException catch (e) {
                // e.g. "This product has been ordered before..."
                _showMessage(e.message);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _openProductForm({Product? existing}) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final priceController = TextEditingController(
      text: existing != null ? existing.price.toStringAsFixed(0) : '',
    );
    final stockController = TextEditingController(
      text: existing != null ? existing.stockQuantity.toString() : '',
    );
    final formKey = GlobalKey<FormState>();

    int? categoryId = existing?.categoryId ??
        (_categories.isNotEmpty ? _categories.first.id : null);
    bool saving = false;
    String? formError;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add Product' : 'Edit Product'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Product name'),
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'Required'
                        : null,
                  ),
                  DropdownButtonFormField<int>(
                    initialValue: categoryId,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: _categories
                        .map((c) =>
                        DropdownMenuItem(value: c.id, child: Text(c.name)))
                        .toList(),
                    onChanged: (value) => categoryId = value,
                    validator: (value) =>
                    value == null ? 'Pick a category' : null,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price (₦)'),
                    keyboardType: TextInputType.number,
                    validator: (value) => (double.tryParse(value ?? '') == null)
                        ? 'Enter a valid number'
                        : null,
                  ),
                  TextFormField(
                    controller: stockController,
                    decoration:
                    const InputDecoration(labelText: 'Stock quantity'),
                    keyboardType: TextInputType.number,
                    validator: (value) => (int.tryParse(value ?? '') == null)
                        ? 'Enter a valid number'
                        : null,
                  ),
                  if (formError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        formError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: saving
                  ? null
                  : () async {
                if (!formKey.currentState!.validate()) return;
                setDialogState(() {
                  saving = true;
                  formError = null;
                });
                try {
                  final saved = await _service.save(
                    id: existing?.id,
                    categoryId: categoryId!,
                    name: nameController.text.trim(),
                    description: existing?.description,
                    price: double.parse(priceController.text),
                    stockQuantity: int.parse(stockController.text),
                    imageUrl: existing?.imageUrl,
                  );
                  if (!mounted) return;
                  setState(() {
                    if (existing == null) {
                      _products.add(saved);
                    } else {
                      final i =
                      _products.indexWhere((p) => p.id == saved.id);
                      if (i != -1) _products[i] = saved;
                    }
                    _products.sort((a, b) => a.name
                        .toLowerCase()
                        .compareTo(b.name.toLowerCase()));
                  });
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                } on ApiException catch (e) {
                  setDialogState(() {
                    saving = false;
                    formError = e.message;
                  });
                }
              },
              child: Text(saving ? 'Saving...' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}