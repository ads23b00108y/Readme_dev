import 'package:flutter/material.dart';

class ProfileSetupScreen extends StatefulWidget {
  final Map<String, int> traits;
  const ProfileSetupScreen({super.key, required this.traits});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int age = 6;
  String readingLevel = 'Beginner';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print({
        'name': name,
        'age': age,
        'level': readingLevel,
        'traits': widget.traits
      });

      // Save to Firestore in future step

      // ✅ Navigate to home using Material Navigator
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("👤 Create Profile")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (val) => name = val!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: age,
                items: List.generate(7, (i) => 6 + i)
                    .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                    .toList(),
                onChanged: (val) => age = val!,
                decoration: const InputDecoration(labelText: "Age"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: readingLevel,
                items: ['Beginner', 'Intermediate', 'Advanced']
                    .map((lvl) => DropdownMenuItem(value: lvl, child: Text(lvl)))
                    .toList(),
                onChanged: (val) => readingLevel = val!,
                decoration: const InputDecoration(labelText: "Reading Level"),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Continue to Home"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
