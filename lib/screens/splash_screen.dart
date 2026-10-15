import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _bounceController;

  // Staggered entrance animations
  late Animation<double> _centerImageFade;
  late Animation<Offset> _centerImageSlide;

  late Animation<double> _topLogoFade;
  late Animation<Offset> _topLogoSlide;

  late Animation<double> _bottomCtasFade;
  late Animation<Offset> _bottomCtasSlide;

  // Bouncing animation
  late Animation<double> _bounceAnimation;
  int _bounceCount = 0;
  final int _maxBounces = 3; // Number of bounces before stopping

  @override
  void initState() {
    super.initState();

    // 1. Entrance Animation Controller
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Center Hero Image Entrance (0.0 to 0.5)
    _centerImageFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );
    _centerImageSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
    ));

    // Top Logo Entrance (0.3 to 0.8)
    _topLogoFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
    );
    _topLogoSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
    ));

    // Bottom CTAs Entrance (0.5 to 1.0)
    _bottomCtasFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );
    _bottomCtasSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
    ));

    // Start entrance animation
    _entranceController.forward();

    // 2. Bounced Controller (Runs a limited number of times)
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350), // Speed of a single bounce tick
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );

    // Listen to when each bounce cycle completes to count them up
    _bounceController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bounceController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _bounceCount++;
        if (_bounceCount < _maxBounces) {
          _bounceController.forward();
        }
      }
    });

    // Trigger the bounce sequence slightly after the entrance starts
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _bounceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Top Logo (Appears 2nd)
              FadeTransition(
                opacity: _topLogoFade,
                child: SlideTransition(
                  position: _topLogoSlide,
                  child: Image.asset(
                    'assets/images/babyshophub_logo.jpg',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const Spacer(),

              // Center Hero Image with Entrance + Limited Bounces
              FadeTransition(
                opacity: _centerImageFade,
                child: SlideTransition(
                  position: _centerImageSlide,
                  child: AnimatedBuilder(
                    animation: _bounceAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _bounceAnimation.value),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/splash_baby.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.child_friendly,
                            size: 120,
                            color: Colors.pink.shade200,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Bottom CTAs & Links (Appears 3rd)
              FadeTransition(
                opacity: _bottomCtasFade,
                child: SlideTransition(
                  position: _bottomCtasSlide,
                  child: Column(
                    children: [
                      // Get Started Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B2559),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Already have an account?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/login'),
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}