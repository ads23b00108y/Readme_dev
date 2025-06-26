// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../widgets/onboarding_card.dart';
// import '../quiz/quiz_screen.dart';
// import '../../providers/user_provider.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _controller = PageController();
//   int _pageIndex = 0;

//   final List<Map<String, String>> pages = [
//     {
//       "title": "Welcome to 📚 ReadMe!",
//       "desc": "Discover fun books based on your unique personality!",
//       "image": "assets/images/splash_lottie.png"
//     },
//     {
//       "title": "🎭 Take a Fun Quiz",
//       "desc": "Answer emoji-based questions to find your book personality.",
//       "image": "assets/images/onboarding2.svg"
//     },
//     {
//       "title": "🎉 Read & Earn Rewards",
//       "desc": "Earn badges and streaks as you read every day!",
//       "image": "assets/images/onboarding3.svg"
//     }
//   ];

//   void _nextPage() {
//     if (_pageIndex < pages.length - 1) {
//       _controller.nextPage(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.ease,
//       );
//     } else {
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       if (userProvider.hasChildSelected) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const QuizScreen()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("⚠️ Please select or create a child profile first."),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView.builder(
//         controller: _controller,
//         itemCount: pages.length,
//         onPageChanged: (index) => setState(() => _pageIndex = index),
//         itemBuilder: (_, i) => OnboardingCard(
//           title: pages[i]['title']!,
//           description: pages[i]['desc']!,
//           imagePath: pages[i]['image']!,
//           onNext: _nextPage,
//           isLast: i == pages.length - 1,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/onboarding_card.dart';
import '../quiz/quiz_screen.dart';
import '../../providers/user_provider.dart'; // 🔑 Required for accessing UserProvider

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "title": "Welcome to 📚 ReadMe!",
      "desc": "Discover fun books based on your unique personality!",
      "image": "assets/images/onboarding1.json"
    },
    {
      "title": "🎭 Take a Fun Quiz",
      "desc": "Answer emoji-based questions to find your book personality.",
      "image": "assets/images/onboarding2.json"
    },
    {
      "title": "🎉 Read & Earn Rewards",
      "desc": "Earn badges and streaks as you read every day!",
      "image": "assets/images/onboarding3.json"
    }
  ];

  void _nextPage() {
    if (_pageIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    } else {
      // ✅ TEMP FIX: Set a dummy childId for testing QuizScreen
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setChildId("demoChild123");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const QuizScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => _pageIndex = index),
        itemBuilder: (_, i) => OnboardingCard(
          title: pages[i]['title']!,
          description: pages[i]['desc']!,
          imagePath: pages[i]['image']!,
          onNext: _nextPage,
          isLast: i == pages.length - 1,
        ),
      ),
    );
  }
}
