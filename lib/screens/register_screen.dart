import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/nursery_bg.jpeg'),
            fit: BoxFit.cover, // This ensures the image fills the whole screen without stretching weirdly
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(32.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Image.asset(
                  'assets/images/logo.jpeg',
                  height: 64,
                ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                        children: const [
                          TextSpan(text: 'Baby', style: TextStyle(color: AppColors.primaryBlue)),
                          TextSpan(text: 'ShopHub', style: TextStyle(color: AppColors.primaryPink)),
                        ],
                      ),
                    ),
                    Text(
                      'Little things. Big smiles.',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.lightText),
                    ),
                    const SizedBox(height: 32),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Create Account',
                        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.darkText),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Join BabyShopHub for exclusive deals, faster checkout and more!',
                        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.lightText),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildLabel('Full Name'),
                    _buildTextField(hint: 'Enter your full name', icon: Icons.person_outline),
                    const SizedBox(height: 16),

                    _buildLabel('Email Address'),
                    _buildTextField(hint: 'you@example.com', icon: Icons.email_outlined),
                    const SizedBox(height: 16),

                    _buildLabel('Phone Number'),
                    _buildTextField(hint: '+234 801 234 5678', icon: Icons.phone_outlined),
                    const SizedBox(height: 16),

                    _buildLabel('Password'),
                    _buildTextField(hint: 'Create a password', icon: Icons.lock_outline, isPassword: true, obscureState: _obscurePassword, toggleObscure: () => setState(() => _obscurePassword = !_obscurePassword)),
                    const SizedBox(height: 16),

                    _buildLabel('Confirm Password'),
                    _buildTextField(hint: 'Confirm your password', icon: Icons.lock_outline, isPassword: true, obscureState: _obscureConfirmPassword, toggleObscure: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
                    const SizedBox(height: 32),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement Registration Logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPink,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Sign Up', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Log In Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ", style: GoogleFonts.poppins(fontSize: 14, color: AppColors.lightText)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text('Log In', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.primaryPink, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(text, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkText)),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureState = false,
    VoidCallback? toggleObscure,
  }) {
    return TextField(
      obscureText: isPassword ? obscureState : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: AppColors.lightText, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.lightText, size: 20),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(obscureState ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.lightText, size: 20),
          onPressed: toggleObscure,
        )
            : null,
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.inputBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.inputBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryBlue)),
      ),
    );
  }
}