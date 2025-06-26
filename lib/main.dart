import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'providers/reading_provider.dart';
import 'providers/settings_provider.dart';
import 'services/gamification_service.dart';
import 'providers/user_provider.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';       // add this import
import 'screens/child/dashboard_screen.dart';
import 'screens/settings/child_settings_screen.dart';
import 'screens/quiz/quiz_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/parent/parent_dashboard_screen.dart';
import 'screens/parent/children_list_screen.dart';
import 'screens/parent/child_detail_screen.dart';
import 'screens/parent/set_goals_screen.dart';
import 'screens/parent/content_filter_screen.dart';
import 'screens/parent/rewards_view_screen.dart';
import 'screens/parent/parent_tips_screen.dart';
//import 'screens/profile_setup/profile_setup_screen.dart';  // Assuming you have this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => ReadingProvider()),
        ChangeNotifierProvider(create: (_) => GamificationService()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const ReadMeApp(),
    ),
  );
}

class ReadMeApp extends StatelessWidget {
  const ReadMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ReadMe 📚',
          theme: ThemeData(
            primaryColor: const Color(0xFF8E44AD),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF8E44AD),
              secondary: const Color(0xFFF7DC6F),
            ),
            fontFamily: 'Roboto',
            textTheme: ThemeData.light().textTheme.copyWith(
              bodyMedium: TextStyle(fontSize: settings.fontSize),
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/dashboard': (context) => const DashboardScreen(readingLevel: 'Beginner'),
            '/settings': (context) => const ChildSettingsScreen(),
            '/quiz': (context) => const QuizScreen(),
            //'/profile-setup': (context) => const ProfileSetupScreen(),  // add your profile setup screen route
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/parent_dashboard': (context) => const ParentDashboardScreen(),
            '/children': (context) => const ChildrenListScreen(),
            '/child_detail': (context) => const ChildDetailScreen(),
            '/set_goals': (context) => const SetGoalsScreen(),
            '/filter_content': (context) => const ContentFilterScreen(),
            '/rewards_view': (context) => const RewardsViewScreen(),
            '/parent_tips': (context) => const ParentTipsScreen(),
          },
        );
      },
    );
  }
}
