class ChildProfile {
  final String id;
  final String name;
  final int age;
  final String readingLevel;
  final List<String> interests;
  final List<String> personalityTraits;
  final String avatar;
  final String parentId;


  ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.readingLevel,
    required this.interests,
    required this.personalityTraits,
    required this.avatar,
    required this.parentId,
  });

  factory ChildProfile.fromMap(Map<String, dynamic> data, String id) {
    return ChildProfile(
      id: id,
      name: data['name'],
      age: data['age'],
      readingLevel: data['readingLevel'],
      interests: List<String>.from(data['interests'] ?? []),
      personalityTraits: List<String>.from(data['personalityTraits'] ?? []),
      avatar: data['avatar'],
      parentId: data['parentId'] ?? '',
    );
  }
}
