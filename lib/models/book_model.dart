class Book {
  final String id;
  final String title;
  final String author;
 // final String isbn;
  //final String coverUrl;
  //final String audioUrl;
  final String readingLevel;
  final List<String> tags;

  Book({
    required this.id,
    required this.title,
    required this.author,
   // required this.isbn,
    //required this.coverUrl,
    //required this.audioUrl,
    required this.readingLevel,
    required this.tags,
  });

  factory Book.fromMap(Map<String, dynamic> map, String id) {
    return Book(
      id: id,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      //isbn: map['isbn'] ?? '',
     // coverUrl: map['coverUrl'] ?? '',
     //audioUrl: map['audioUrl'] ?? '',
      readingLevel: map['readingLevel'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
    );
  }
}
