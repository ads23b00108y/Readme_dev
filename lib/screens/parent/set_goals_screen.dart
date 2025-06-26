import 'package:flutter/material.dart';
import '../../models/goal.dart';
import '../../services/goal_service.dart';

class SetGoalsScreen extends StatefulWidget {
  const SetGoalsScreen({super.key});

  @override
  State<SetGoalsScreen> createState() => _SetGoalsScreenState();
}

class _SetGoalsScreenState extends State<SetGoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dailyController = TextEditingController();
  final TextEditingController _weeklyController = TextEditingController();
  final GoalService _goalService = GoalService();

  // Replace with actual values during auth wiring
  final String _parentId = 'mockParentId';
  final String _childId = 'mockChildId';

  void _submitGoal() async {
    if (_formKey.currentState!.validate()) {
      final goal = ReadingGoal(
        id: '',
        parentId: _parentId,
        childId: _childId,
        dailyMinutes: int.parse(_dailyController.text),
        weeklyBooks: int.parse(_weeklyController.text),
      );

      await _goalService.setGoal(goal);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Goal Set!")),
      );
      _dailyController.clear();
      _weeklyController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🎯 Set Reading Goals")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dailyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Daily Minutes"),
                validator: (value) =>
                    value!.isEmpty ? "Required field" : null,
              ),
              TextFormField(
                controller: _weeklyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Books per Week"),
                validator: (value) =>
                    value!.isEmpty ? "Required field" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitGoal,
                child: const Text("✅ Save Goal"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
