// File: lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    
    if (!mounted) return;
    
    // Navigate to onboarding screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8E44AD),
              Color(0xFFA062BA),
              Color(0xFFB280C7),
            ],
          ),
        ),
        child: const Center(
          child: Text(
            'ReadMe',
            style: TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}







// // File: lib/screens/splash_screen.dart
// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../screens/onboarding/onboarding_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initAnimations();
//     _navigateAfterDelay();
//   }

//   void _initAnimations() {
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(_animationController);

//     _animationController.forward();
//   }

//   void _navigateAfterDelay() async {
//     await Future.delayed(const Duration(milliseconds: 3000));
    
//     if (!mounted) return;
    
//     // Navigate to onboarding screen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const OnboardingScreen(),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: AppTheme.splashGradient,
//         ),
//         child: SafeArea(
//           child: Center(
//             child: AnimatedBuilder(
//               animation: _animationController,
//               builder: (context, child) {
//                 return FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // ReadMe Logo
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Read',
//                               style: AppTheme.logoLarge,
//                             ),
//                             TextSpan(
//                               text: 'Me',
//                               style: AppTheme.logoLarge.copyWith(
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }