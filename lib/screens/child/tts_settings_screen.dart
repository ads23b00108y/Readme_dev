import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';

class TtsSettingsScreen extends StatelessWidget {
  const TtsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("🎧 TTS Settings")),
      body: Column(
        children: [
          ListTile(
            title: const Text("Speech Rate"),
            subtitle: Slider(
              value: settings.ttsSpeed,
              min: 0.5,
              max: 1.5,
              divisions: 5,
              onChanged: (val) => settings.setTtsSpeed(val),
              label: "${settings.ttsSpeed.toStringAsFixed(1)}x",
            ),
          ),
          ListTile(
            title: const Text("Voice Type"),
            trailing: DropdownButton<String>(
              value: settings.voiceType,
              items: const [
                DropdownMenuItem(value: 'male', child: Text("Male")),
                DropdownMenuItem(value: 'female', child: Text("Female")),
              ],
              onChanged: (val) => settings.setVoiceType(val!),
            ),
          ),
        ],
      ),
    );
  }
}
