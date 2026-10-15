import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'widgets/placeholder_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/admin_login_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const BabyShopHubApp());
}

class BabyShopHubApp extends StatelessWidget {
  const BabyShopHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyShopHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/admin-login': (context) => const AdminLoginScreen(),
        // Only a signed-in admin sees the dashboard; anyone else gets the login screen
        '/admin': (context) => AuthService.instance.isAdmin
            ? const AdminDashboardScreen()
            : const AdminLoginScreen(),
        // Swap these for Zizi's real screens once her branch merges
        '/register': (context) => const PlaceholderScreen(title: 'Register'),
        '/login': (context) => const PlaceholderScreen(title: 'Login'),
        // '/admin': (context) => const AdminDashboardScreen(),
      },
    );
  }
}