import 'package:flutter/material.dart';

class ContentFilterScreen extends StatefulWidget {
  const ContentFilterScreen({super.key});

  @override
  State<ContentFilterScreen> createState() => _ContentFilterScreenState();
}

class _ContentFilterScreenState extends State<ContentFilterScreen> {
  bool _showFantasy = true;
  bool _showScience = true;
  bool _showLowLevel = true;

  void _saveFilters() {
    // TODO: Save filters to Firestore under child or parent ID
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Filters Saved")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🔒 Content Filters")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("📚 Fantasy"),
            value: _showFantasy,
            onChanged: (val) => setState(() => _showFantasy = val),
          ),
          SwitchListTile(
            title: const Text("🔬 Science"),
            value: _showScience,
            onChanged: (val) => setState(() => _showScience = val),
          ),
          SwitchListTile(
            title: const Text("🧒 Beginner Level"),
            value: _showLowLevel,
            onChanged: (val) => setState(() => _showLowLevel = val),
          ),
          ElevatedButton(
            onPressed: _saveFilters,
            child: const Text("💾 Save Preferences"),
          )
        ],
      ),
    );
  }
}
