import 'package:flutter/material.dart';

class ParentTipsScreen extends StatelessWidget {
  const ParentTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      "📌 Set realistic reading goals based on age.",
      "🎧 Use 'Listen' mode for children who struggle with reading.",
      "💬 Encourage daily reading streaks with rewards.",
      "🔒 Use filters to control content by genre and difficulty.",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("💡 Parenting Tips")),
      body: ListView.builder(
        itemCount: tips.length,
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.lightbulb),
          title: Text(tips[index]),
        ),
      ),
    );
  }
}
