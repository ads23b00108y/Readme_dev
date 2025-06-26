class ReadingGoal {
  final String id;
  final String parentId;
  final String childId;
  final int dailyMinutes;
  final int weeklyBooks;

  ReadingGoal({
    required this.id,
    required this.parentId,
    required this.childId,
    required this.dailyMinutes,
    required this.weeklyBooks,
  });

  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'childId': childId,
      'dailyMinutes': dailyMinutes,
      'weeklyBooks': weeklyBooks,
      'createdAt': DateTime.now(),
    };
  }

  factory ReadingGoal.fromMap(Map<String, dynamic> map, String id) {
    return ReadingGoal(
      id: id,
      parentId: map['parentId'],
      childId: map['childId'],
      dailyMinutes: map['dailyMinutes'],
      weeklyBooks: map['weeklyBooks'],
    );
  }
}
