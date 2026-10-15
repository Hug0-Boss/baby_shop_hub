import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme.dart'; // Import your colors from earlier
import 'order_history_screen.dart';
import 'reviews_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // This handles which tab is currently active at the bottom
  int _currentIndex = 4; // 4 is the index for "Profile"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Mockup shows a clean white background

      // --- BODY (Main Content) ---
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Page Title
              Text(
                'Profile',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 24),

              // 2. User Header (Avatar, Name, Email)
              Row(
                children: [
                  // Avatar Image
                  const CircleAvatar(
                    radius: 36,
                    // TODO: Replace this NetworkImage with your own AssetImage or user data
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47'),
                    backgroundColor: AppColors.inputFill,
                  ),
                  const SizedBox(width: 16),
                  // Name and Email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nifemi Shataolu',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'nifemi@gmail.com',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 3. Menu Items List
              // We use a reusable function here to keep the code clean
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Personal Information',
                onTap: () {
                  // TODO: Navigate to Personal Info Screen
                },
              ),
              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Delivery Addresses',
                onTap: () {
                  // TODO: Navigate to Addresses Screen
                },
              ),
              _buildMenuItem(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                onTap: () {
                  // TODO: Navigate to Payment Methods Screen
                },
              ),
              _buildMenuItem(
                icon: Icons.receipt_long_outlined, // Zizi's module!
                title: 'Order History',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.star_border, // Olive's module
                title: 'Reviews & Ratings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReviewsScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.help_outline, // Nick's module
                title: 'Help & Support',
                onTap: () {
                  // TODO: Navigate to Help Screen
                },
              ),

              const SizedBox(height: 16),

              // 4. Log Out Button
              // It looks like a menu item, but we make it red to stand out
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Log Out',
                iconColor: Colors.redAccent,
                textColor: Colors.redAccent,
                onTap: () {
                  // TODO: Implement Log Out logic (clear token, navigate to Login)
                },
              ),
            ],
          ),
        ),
      ),

      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // TODO: Add navigation logic here for the other tabs
        },
        type: BottomNavigationBarType.fixed, // Keeps all labels visible
        selectedItemColor: AppColors.primaryPink, // The pink color from your mockup
        unselectedItemColor: AppColors.lightText,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // --- REUSABLE MENU ITEM WIDGET ---
  // This function builds one row of the menu so we don't repeat code
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = AppColors.darkText,
    Color textColor = AppColors.darkText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero, // Removes default extra padding
        leading: Icon(icon, color: iconColor, size: 26),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.lightText),
        onTap: onTap,
      ),
    );
  }
}