import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class BookService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Book>> fetchBooksByLevel(String readingLevel) async {
    final snapshot = await _db
        .collection('books')
        .where('readingLevel', isEqualTo: readingLevel)
        .get();

    return snapshot.docs.map((doc) => Book.fromMap(doc.data(), doc.id)).toList();
  }
}
