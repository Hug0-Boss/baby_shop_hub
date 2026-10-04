import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'widgets/placeholder_screen.dart';
import 'screens/admin_dashboard_screen.dart';

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
      initialRoute: '/admin',
      routes: {
        '/': (context) => const SplashScreen(),
        // Swap these for Zizi's real screens once her branch merges
        '/register': (context) => const PlaceholderScreen(title: 'Register'),
        '/login': (context) => const PlaceholderScreen(title: 'Login'),
        '/admin': (context) => const AdminDashboardScreen(),
      },
    );
  }
}