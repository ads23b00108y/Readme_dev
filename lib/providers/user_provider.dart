import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  // 🔑 Parent & Child Identification
  String _parentId = '';
  String _childId = '';

  // 👶 Child Profile Info
  String _childName = '';
  String _personality = '';
  String _avatar = '';
  int _readingLevel = 1;

  // 📣 Getters (Safe + Debug-Friendly)
  String get parentId => _parentId;
  String get childId => _childId;
  String get childName => _childName;
  String get personality => _personality;
  String get avatar => _avatar;
  int get readingLevel => _readingLevel;

  bool get isLoggedIn => _parentId.isNotEmpty;
  bool get hasChildSelected => _childId.isNotEmpty;

  // 🛠️ Setters with Null-Check + Debug Print
  void setParentId(String id) {
    if (id.isNotEmpty) {
      _parentId = id;
      debugPrint('✅ parentId set to $_parentId');
      notifyListeners();
    } else {
      debugPrint('⚠️ Attempted to set empty parentId');
    }
  }

  void setChildId(String id) {
    if (id.isNotEmpty) {
      _childId = id;
      debugPrint('✅ childId set to $_childId');
      notifyListeners();
    } else {
      debugPrint('⚠️ Attempted to set empty childId');
    }
  }

  void setChildName(String name) {
    _childName = name.trim();
    debugPrint('🧒 childName set to $_childName');
    notifyListeners();
  }

  void setPersonality(String trait) {
    _personality = trait;
    debugPrint('🧠 Personality set to $_personality');
    notifyListeners();
  }

  void setAvatar(String url) {
    _avatar = url;
    debugPrint('🖼️ Avatar set to $_avatar');
    notifyListeners();
  }

  void setReadingLevel(int level) {
    _readingLevel = level > 0 ? level : 1;
    debugPrint('📚 Reading level set to $_readingLevel');
    notifyListeners();
  }

  // 🔁 Reset on logout or child switch
  void reset() {
    _parentId = '';
    _childId = '';
    _childName = '';
    _personality = '';
    _avatar = '';
    _readingLevel = 1;
    debugPrint('🔄 UserProvider reset.');
    notifyListeners();
  }
}
