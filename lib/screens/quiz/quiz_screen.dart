import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readme/providers/user_provider.dart';
import '../child/profile_setup_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  final Map<String, int> traitScores = {};

  final List<Map<String, dynamic>> questions = [
    {
      'question': "Which emoji best describes your day? 😄🌟🚀🎨",
      'options': [
        {'emoji': '😄', 'trait': 'happy'},
        {'emoji': '🌟', 'trait': 'curious'},
        {'emoji': '🚀', 'trait': 'explorer'},
        {'emoji': '🎨', 'trait': 'creative'},
      ]
    },
    {
      'question': "Pick a favorite time! 📚🎧🎮🌈",
      'options': [
        {'emoji': '📚', 'trait': 'bookworm'},
        {'emoji': '🎧', 'trait': 'listener'},
        {'emoji': '🎮', 'trait': 'gamer'},
        {'emoji': '🌈', 'trait': 'dreamer'},
      ]
    },
  ];

  void _selectOption(String trait) {
    traitScores.update(trait, (val) => val + 1, ifAbsent: () => 1);
    if (currentQuestion < questions.length - 1) {
      setState(() => currentQuestion++);
    } else {
      _submitQuizResult();
    }
  }

  void _submitQuizResult() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final childId = userProvider.childId;

    // Safety check
    if (!userProvider.hasChildSelected) {
      debugPrint("❌ No childId found in UserProvider.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ No child selected. Please log in again.")),
      );
      return;
    }

    // Calculate highest trait
    String personalityTrait = traitScores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    try {
      await FirebaseFirestore.instance
          .collection('childProfiles')
          .doc(childId)
          .update({'personalityTraits': personalityTrait});

      userProvider.setPersonality(personalityTrait);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🧠 Personality updated!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileSetupScreen(traits: traitScores),
        ),
      );
    } catch (e) {
      debugPrint("❌ Firestore update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to update: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestion];
    return Scaffold(
      appBar: AppBar(title: const Text("🧠 Personality Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(q['question'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 40),
            ...q['options'].map<Widget>((opt) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: () => _selectOption(opt['trait']),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                ),
                child: Text(opt['emoji'], style: const TextStyle(fontSize: 28)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
