import 'package:flutter/material.dart';
import 'avatar_screen.dart';
import 'tts_settings_screen.dart';
import 'package:readme/screens/quiz/quiz_screen.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("⚙️ Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("🧸 Customize Avatar"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AvatarScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text("🎧 TTS Settings"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TtsSettingsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text("🔁 Retake Quiz"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuizScreen()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.accessibility),
            title: const Text("🦮 Accessibility Options"),
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Accessibility"),
                content: const Text("Dark mode, dyslexia font, etc. coming soon."),
              ),
            ),
          )
        ],
      ),
    );
  }
}
