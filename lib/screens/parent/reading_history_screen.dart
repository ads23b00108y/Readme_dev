// File: lib/screens/parent/reading_history_screen.dart
import 'package:flutter/material.dart';

class ReadingHistoryScreen extends StatelessWidget {
  const ReadingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the selected child userId from the parent dashboard context (if available)
    // For now, use the current Firebase user as the child (same as dashboard logic)
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF8E44AD)),
        ),
        title: const Text(
          'Reading History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchReadingHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final readingHistory = snapshot.data ?? [];
          if (readingHistory.isEmpty) {
            return const Center(child: Text('No reading history yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: readingHistory.length,
            itemBuilder: (context, index) {
              final book = readingHistory[index];
              final status = (book['progressPercentage'] ?? 0.0) >= 1.0 ? 'Completed' : 'Ongoing';
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8E44AD).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Icon(
                                status == 'Completed'
                                    ? Icons.check_circle
                                    : Icons.menu_book,
                                size: 24,
                                color: status == 'Completed'
                                    ? Colors.green
                                    : const Color(0xFF8E44AD),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book['bookTitle'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTimestamp(book['lastReadAt']),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: status == 'Completed'
                                  ? Colors.green.withOpacity(0.1)
                                  : const Color(0xFF8E44AD).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: status == 'Completed'
                                    ? Colors.green
                                    : const Color(0xFF8E44AD),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Progress bar
                      Row(
                        children: [
                          Text(
                            'Progress: \\${((book['progressPercentage'] ?? 0.0) * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          // Optionally, you can add minutesRead if available
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (book['progressPercentage'] ?? 0.0).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          status == 'Completed' ? Colors.green : const Color(0xFF8E44AD),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fetch real reading history from Firestore for the current user
  Future<List<Map<String, dynamic>>> _fetchReadingHistory() async {
    // Use FirebaseAuth to get the current user (child)
    final user = await Future.value(FirebaseAuth.instance.currentUser);
    if (user == null) return [];
    final query = await FirebaseFirestore.instance
        .collection('reading_sessions')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .get();
    // Only include books with progress > 0 (ongoing or completed)
    final sessions = query.docs
        .map((doc) => doc.data())
        .where((session) => (session['progressPercentage'] ?? 0.0) > 0.0)
        .toList();
    return sessions;
  }

  // Format Firestore Timestamp or DateTime to a readable string
  String _formatTimestamp(dynamic ts) {
    if (ts == null) return '';
    DateTime dt;
    if (ts is Timestamp) {
      dt = ts.toDate();
    } else if (ts is DateTime) {
      dt = ts;
    } else {
      return ts.toString();
    }
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays > 0) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} min ago';
    } else {
      return 'Just now';
    }
  }
}