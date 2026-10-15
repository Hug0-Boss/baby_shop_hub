import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/product.dart';
import '../utils/api_config.dart';
import 'api_client.dart';

// Re-exported so screens can keep importing just this file to catch ApiException
export 'api_client.dart' show ApiException;

class ProductService {
  // Reading products is public — no token needed
  Future<List<Product>> fetchProducts() async {
    final res = await ApiClient.send(
            () => http.get(Uri.parse('${ApiConfig.baseUrl}/api/products')));
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((j) => Product.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<Category>> fetchCategories() async {
    final res = await ApiClient.send(
            () => http.get(Uri.parse('${ApiConfig.baseUrl}/api/categories')));
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((j) => Category.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Creates a product when [id] is null, otherwise updates that product.
  /// Admin only — sends the logged-in admin's token.
  Future<Product> save({
    int? id,
    required int categoryId,
    required String name,
    String? description,
    required double price,
    required int stockQuantity,
    String? imageUrl,
  }) async {
    final body = jsonEncode({
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'stockQuantity': stockQuantity,
      'imageUrl': imageUrl,
    });

    final res = await ApiClient.send(() => id == null
        ? http.post(Uri.parse('${ApiConfig.baseUrl}/api/products'),
        headers: ApiClient.headers(withAuth: true), body: body)
        : http.put(Uri.parse('${ApiConfig.baseUrl}/api/products/$id'),
        headers: ApiClient.headers(withAuth: true), body: body));

    return Product.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// Admin only.
  Future<void> delete(int id) async {
    await ApiClient.send(() => http.delete(
        Uri.parse('${ApiConfig.baseUrl}/api/products/$id'),
        headers: ApiClient.headers(withAuth: true)));
  }
}