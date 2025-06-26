import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.purple[500],
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            //Image.network(book.coverUrl, height: 120, fit: BoxFit.cover),
            Text(book.title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(' ${book.readingLevel}'),
          ],
        ),
      ),
    );
  }
}
