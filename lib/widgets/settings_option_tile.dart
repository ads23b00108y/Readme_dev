import 'package:flutter/material.dart';

class SettingsOptionTile extends StatelessWidget {
  final String title;
  final Widget trailing;

  const SettingsOptionTile({required this.title, required this.trailing, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: trailing,
    );
  }
}
