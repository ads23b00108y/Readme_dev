import 'package:flutter/material.dart';

class RewardsViewScreen extends StatelessWidget {
  const RewardsViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockBadges = [
      {"title": "📖 1st Book!", "desc": "Completed first read"},
      {"title": "🔥 5 Day Streak", "desc": "Read 5 days in a row"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("🏅 Earned Badges")),
      body: ListView.builder(
        itemCount: mockBadges.length,
        itemBuilder: (context, index) {
          final badge = mockBadges[index];
          return ListTile(
            leading: const Icon(Icons.emoji_events, color: Colors.amber),
            title: Text(badge['title']!),
            subtitle: Text(badge['desc']!),
          );
        },
      ),
    );
  }
}
