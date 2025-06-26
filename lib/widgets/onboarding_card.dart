import 'package:flutter/material.dart';

class OnboardingCard extends StatelessWidget {
  final String title, description, imagePath;
  final VoidCallback onNext;
  final bool isLast;

  const OnboardingCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onNext,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 250),
          const SizedBox(height: 30),
          Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text(description, textAlign: TextAlign.center),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: onNext,
            icon: Icon(isLast ? Icons.check : Icons.arrow_forward),
            label: Text(isLast ? "Start Quiz" : "Next"),
          )
        ],
      ),
    );
  }
}
