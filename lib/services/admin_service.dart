import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/admin_models.dart';
import '../utils/api_config.dart';
import 'api_client.dart';

// Re-exported so screens can keep importing just this file to catch ApiException
export 'api_client.dart' show ApiException;

/// Admin-only calls — every request sends the logged-in admin's token.
class AdminService {
  Future<List<AdminOrderSummary>> fetchOrders({String? status}) async {
    final query = status == null ? '' : '?status=$status';
    final res = await ApiClient.send(() => http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/admin/orders$query'),
      headers: ApiClient.headers(withAuth: true),
    ));
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((j) => AdminOrderSummary.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<AdminOrderDetail> fetchOrder(int id) async {
    final res = await ApiClient.send(() => http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/admin/orders/$id'),
      headers: ApiClient.headers(withAuth: true),
    ));
    return AdminOrderDetail.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> updateOrderStatus(int id, String status) async {
    await ApiClient.send(() => http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/admin/orders/$id/status'),
      headers: ApiClient.headers(withAuth: true),
      body: jsonEncode({'status': status}),
    ));
  }

  Future<List<AdminUser>> fetchUsers() async {
    final res = await ApiClient.send(() => http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/admin/users'),
      headers: ApiClient.headers(withAuth: true),
    ));
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((j) => AdminUser.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteUser(int id) async {
    await ApiClient.send(() => http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/admin/users/$id'),
      headers: ApiClient.headers(withAuth: true),
    ));
  }
}