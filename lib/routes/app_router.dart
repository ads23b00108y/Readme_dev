import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/quiz/quiz_screen.dart';
import '../screens/child/profile_setup_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/onboarding': (context) => const OnboardingScreen(),
  '/quiz': (context) => const QuizScreen(),
};

// Special case for screens that need arguments (like ProfileSetupScreen)
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/profile-setup':
      final args = settings.arguments as Map<String, int>;
      return MaterialPageRoute(
        builder: (context) => ProfileSetupScreen(traits: args),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
  }
}
