import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/settings_option_tile.dart';

class ChildSettingsScreen extends StatelessWidget {
  const ChildSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('🎭 Avatar Customization (Coming soon)', style: TextStyle(fontSize: 16)),

          const SizedBox(height: 24),
          SettingsOptionTile(
            title: '🗣️ TTS Speed',
            trailing: DropdownButton<double>(
              value: settings.ttsSpeed,
              items: [0.75, 1.0, 1.25, 1.5].map((speed) {
                return DropdownMenuItem(
                  value: speed,
                  child: Text('${speed}x'),
                );
              }).toList(),
              onChanged: (speed) {
                if (speed != null) settings.setTtsSpeed(speed); // 👈 THIS IS THE LINE
              },
            ),
          ),


          SettingsOptionTile(
            title: '🧠 Dyslexia-Friendly Font',
            trailing: Switch(
              value: settings.dyslexiaFont,
              onChanged: (val) => settings.toggleDyslexiaFont(val),
            ),
          ),

          SettingsOptionTile(
            title: '🔠 Font Size',
            trailing: Slider(
              min: 12,
              max: 24,
              value: settings.fontSize,
              onChanged: settings.updateFontSize,
            ),
          ),

          const Divider(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              // Retake quiz flow
              Navigator.pushNamed(context, '/quiz');
            },
            icon: const Icon(Icons.refresh),
            label: const Text('🔁 Retake Personality Quiz'),
          ),
        ],
      ),
    );
  }
}
