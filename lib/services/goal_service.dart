import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal.dart';

class GoalService {
  //final _firestore = FirebaseFirestore.instance;
  final _goalRef = FirebaseFirestore.instance.collection('readingGoals');

  Future<void> setGoal(ReadingGoal goal) async {
    await _goalRef.add(goal.toMap());
  }

  Future<List<ReadingGoal>> getGoalsForParent(String parentId) async {
    final result = await _goalRef.where('parentId', isEqualTo: parentId).get();
    return result.docs
        .map((doc) => ReadingGoal.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<ReadingGoal>> getGoalsForChild(String childId) async {
    final result = await _goalRef.where('childId', isEqualTo: childId).get();
    return result.docs
        .map((doc) => ReadingGoal.fromMap(doc.data(), doc.id))
        .toList();
  }
}
