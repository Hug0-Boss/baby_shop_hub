class AppUser {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role; // "Customer" or "Admin"

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
  });

  bool get isAdmin => role == 'Admin';

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
    );
  }
}