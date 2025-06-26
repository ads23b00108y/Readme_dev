import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readme/screens/book/book_details_screen.dart';
import '../../providers/book_provider.dart';
import '../../widgets/book_card.dart';

class DashboardScreen extends StatefulWidget {
  final String readingLevel;
  const DashboardScreen({super.key, required this.readingLevel});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookProvider>(context, listen: false).loadBooks(widget.readingLevel);
  }

  @override
  Widget build(BuildContext context) {
    final books = Provider.of<BookProvider>(context).books;

    return Scaffold(
      appBar: AppBar(
  title: Text('📖 Your Books'),
  actions: [
    IconButton(
      icon: Icon(Icons.settings),
      onPressed: () => Navigator.pushNamed(context, '/settings'), // ✅ Link to settings
    ),
  ],
),

      body: books.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: books.length,
              itemBuilder: (ctx, i) => BookCard(
                book: books[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookDetailsScreen(book: books[i]),
                  ),
                ),
              ),
            ),
    );
  }
}

