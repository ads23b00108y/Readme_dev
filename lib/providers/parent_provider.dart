import 'package:flutter/material.dart';
import '../models/child_profile.dart';
import '../services/parent_service.dart';

class ParentProvider with ChangeNotifier {
  final ParentService _service = ParentService();

  List<ChildProfile> _children = [];
  List<ChildProfile> get children => _children;

  Future<void> loadChildren(String parentId) async {
    _children = await _service.getChildrenByParent(parentId);
    notifyListeners();
  }
}
