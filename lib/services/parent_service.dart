import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/child_profile.dart';

class ParentService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<ChildProfile>> getChildrenByParent(String parentId) async {
    final query = await _firestore
        .collection('childProfiles')
        .where('parentId', isEqualTo: parentId)
        .get();

    return query.docs
        .map((doc) => ChildProfile.fromMap(doc.data(), doc.id))
        .toList();
  }
}
