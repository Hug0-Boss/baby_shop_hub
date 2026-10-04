import 'package:flutter/material.dart';

/// Stand-in for screens that haven't been merged in yet.
/// Swap the matching route in main.dart for the real screen as it lands.
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title screen — coming soon',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}