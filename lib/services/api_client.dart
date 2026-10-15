import 'dart:convert';
import 'package:http/http.dart' as http;

/// A readable error you can show straight to the user.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Shared plumbing for every call to the API.
class ApiClient {
  /// Set by AuthService on login and cleared on logout.
  static String? token;

  /// Pass withAuth: true for requests that need the logged-in user's token.
  static Map<String, String> headers({bool withAuth = false}) => {
    'Content-Type': 'application/json',
    if (withAuth && token != null) 'Authorization': 'Bearer $token',
  };

  /// Runs a request and turns any failure into a readable ApiException.
  static Future<http.Response> send(
      Future<http.Response> Function() request) async {
    http.Response res;
    try {
      res = await request().timeout(const Duration(seconds: 10));
    } catch (_) {
      throw ApiException("Can't reach the server. Is the API running?");
    }

    if (res.statusCode >= 200 && res.statusCode < 300) return res;

    // The API sends { "error": "..." } for problems like validation or conflicts
    String? message;
    try {
      final data = jsonDecode(res.body);
      if (data is Map && data['error'] is String) {
        message = data['error'] as String;
      }
    } catch (_) {}

    if (message == null) {
      if (res.statusCode == 401) {
        message = 'Please sign in again.';
      } else if (res.statusCode == 403) {
        message = "You don't have permission to do that.";
      } else {
        message = 'Something went wrong (${res.statusCode}).';
      }
    }
    throw ApiException(message, statusCode: res.statusCode);
  }
}