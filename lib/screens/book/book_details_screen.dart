import 'package:flutter/material.dart';
import 'package:readme/models/book_model.dart';
import 'package:readme/screens/child/reading_screen.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // Book cover
            // Center(
            //   child: Image.network(
            //     book.coverUrl,
            //     height: 200,
            //     width: 150,
            //     fit: BoxFit.cover,
            //     errorBuilder: (context, error, stackTrace) {
            //       return const Icon(Icons.image_not_supported, size: 100);
            //     },
            //   ),
            // ),
            // const SizedBox(height: 20),

            // Title & author
            Text(
              book.title,
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'by ${book.author}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),

            const SizedBox(height: 20),

            // Optional Info
            Text(
              'Reading Level: ${book.readingLevel}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Tags: ${book.tags.join(', ')}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const Spacer(),

            // Start Reading button
            ElevatedButton.icon(
              icon: const Icon(Icons.menu_book),
              label: const Text("📖 Start Reading"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadingScreen(
                        bookTitle: book.title,
                        bookId: book.id,
                        childId: 'demo-child-id', // Replace with real one later
                        fullText: 'This is the full text of the book...', // Replace with real text later
                      ),
                    ),
                  );
                },

            ),
          ],
        ),
      ),
    );
  }
}
