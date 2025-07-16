// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const ReadMeApp());
}

class ReadMeApp extends StatelessWidget {
  const ReadMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadMe - Personalized Reading for Kids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: const Color(0xFF8E44AD),
      ),
      home: const SplashScreen(),
    );
  }
}







// // File: lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// // import 'package:firebase_core/firebase_core.dart';

// // import 'firebase_options.dart';
// import 'theme/app_theme.dart';
// import 'screens/splash_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Pre-load Google Fonts to avoid loading issues
//   try {
//     await _preloadFonts();
//   } catch (e) {
//     print('Failed to preload fonts: $e');
//     // Continue anyway - fallback fonts will be used
//   }
  
//   // Temporarily disable Firebase for web testing
//   // await Firebase.initializeApp(
//   //   options: DefaultFirebaseOptions.currentPlatform,
//   // );
  
//   // Set preferred orientations
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
  
//   runApp(const ReadMeApp());
// }

// // Pre-load Google Fonts
// Future<void> _preloadFonts() async {
//   await Future.wait([
//     GoogleFonts.pendingFonts([
//       GoogleFonts.poppins(),
//       GoogleFonts.nunito(),
//       GoogleFonts.merriweatherSans(),
//     ]),
//   ]);
// }

// class ReadMeApp extends StatelessWidget {
//   const ReadMeApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ReadMe - Personalized Reading for Kids',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       home: const SplashScreen(),
//     );
//   }
// }