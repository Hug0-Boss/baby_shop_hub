import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_user.dart';
import '../utils/api_config.dart';
import 'api_client.dart';

/// Tracks who is logged in. One shared instance for the whole app:
///   AuthService.instance.login(...), .register(...), .logout(), .user, .isAdmin
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  AppUser? _user;
  String? _token;

  AppUser? get user => _user;
  String? get token => _token;
  bool get isLoggedIn => _token != null && _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;

  Future<AppUser> login(String email, String password) async {
    final res = await ApiClient.send(() => http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
      headers: ApiClient.headers(),
      body: jsonEncode({'email': email, 'password': password}),
    ));
    return _saveSession(res);
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final res = await ApiClient.send(() => http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/register'),
      headers: ApiClient.headers(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    ));
    return _saveSession(res);
  }

  void logout() {
    _user = null;
    _token = null;
    ApiClient.token = null;
  }

  AppUser _saveSession(http.Response res) {
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    _token = data['token'] as String;
    _user = AppUser.fromJson(data['user'] as Map<String, dynamic>);
    ApiClient.token = _token;
    return _user!;
  }
}