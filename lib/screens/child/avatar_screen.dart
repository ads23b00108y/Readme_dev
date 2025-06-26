import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  final List<String> avatars = const [
    '🧸', '🐶', '🐱', '🐵', '🦊', '🐰', '🦁', '🐼'
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("🧸 Choose Avatar")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10,
        ),
        itemCount: avatars.length,
        itemBuilder: (context, index) {
          final avatar = avatars[index];
          return GestureDetector(
            onTap: () {
              userProvider.setAvatar(avatar);
              Navigator.pop(context);
            },
            child: Center(
              child: Text(
                avatar,
                style: const TextStyle(fontSize: 36),
              ),
            ),
          );
        },
      ),
    );
  }
}
