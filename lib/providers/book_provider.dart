// File: lib/providers/book_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverEmoji;
  final List<String> traits; // For personality matching
  final String ageRating;
  final int estimatedReadingTime; // in minutes
  final List<String> content; // Pages of the book
  final DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverEmoji,
    required this.traits,
    required this.ageRating,
    required this.estimatedReadingTime,
    required this.content,
    required this.createdAt,
  });

  factory Book.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      description: data['description'] ?? '',
      coverEmoji: data['coverEmoji'] ?? '📚',
      traits: List<String>.from(data['traits'] ?? []),
      ageRating: data['ageRating'] ?? '6+',
      estimatedReadingTime: data['estimatedReadingTime'] ?? 15,
      content: List<String>.from(data['content'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'coverEmoji': coverEmoji,
      'traits': traits,
      'ageRating': ageRating,
      'estimatedReadingTime': estimatedReadingTime,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class ReadingProgress {
  final String id;
  final String userId;
  final String bookId;
  final int currentPage;
  final int totalPages;
  final double progressPercentage;
  final int readingTimeMinutes;
  final DateTime lastReadAt;
  final bool isCompleted;

  ReadingProgress({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.currentPage,
    required this.totalPages,
    required this.progressPercentage,
    required this.readingTimeMinutes,
    required this.lastReadAt,
    required this.isCompleted,
  });

  factory ReadingProgress.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReadingProgress(
      id: doc.id,
      userId: data['userId'] ?? '',
      bookId: data['bookId'] ?? '',
      currentPage: data['currentPage'] ?? 1,
      totalPages: data['totalPages'] ?? 1,
      progressPercentage: (data['progressPercentage'] ?? 0.0).toDouble(),
      readingTimeMinutes: data['readingTimeMinutes'] ?? 0,
      lastReadAt: (data['lastReadAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bookId': bookId,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'progressPercentage': progressPercentage,
      'readingTimeMinutes': readingTimeMinutes,
      'lastReadAt': Timestamp.fromDate(lastReadAt),
      'isCompleted': isCompleted,
    };
  }
}

class BookProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<Book> _allBooks = [];
  List<Book> _recommendedBooks = [];
  List<ReadingProgress> _userProgress = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Book> get allBooks => _allBooks;
  List<Book> get recommendedBooks => _recommendedBooks;
  List<ReadingProgress> get userProgress => _userProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize sample books (call this once to populate the database)
  Future<void> initializeSampleBooks() async {
    try {
      final sampleBooks = [
        {
          'title': 'The Enchanted Monkey',
          'author': 'Maya Adventure',
          'description': 'Follow Koko the monkey on an amazing adventure through the magical jungle! Discover hidden treasures, make new friends, and learn about courage and friendship.',
          'coverEmoji': '🐒✨',
          'traits': ['adventurous', 'curious', 'brave'],
          'ageRating': '6+',
          'estimatedReadingTime': 15,
          'content': [
            "Once upon a time, in a magical jungle filled with colorful flowers and singing birds, there lived a curious little monkey named Koko.\n\nKoko had golden fur that sparkled in the sunlight and big, bright eyes that were always looking for adventure.\n\nOne sunny morning, Koko was swinging from branch to branch when he noticed something shiny hidden behind a waterfall.",
            "\"What could that be?\" Koko wondered aloud, his tail curling with excitement.\n\nHe swung closer to the waterfall, feeling the cool mist on his face. Behind the rushing water, he could see a cave with something glowing inside.\n\nKoko had never seen anything like it before. His heart raced with curiosity and a little bit of fear.",
            "Taking a deep breath, Koko carefully climbed behind the waterfall. The cave was warm and filled with a soft, golden light.\n\nIn the center of the cave sat an old, wise turtle with a shell that shimmered like a rainbow.\n\n\"Hello, young monkey,\" said the turtle with a kind smile. \"I've been waiting for someone brave enough to find me.\"",
          ],
        },
        {
          'title': 'Fairytale Adventures',
          'author': 'Emma Wonder',
          'description': 'Enter a world of magic and wonder! Meet brave princesses, helpful fairies, and discover that true magic comes from kindness and courage.',
          'coverEmoji': '🧚‍♀️🌟',
          'traits': ['imaginative', 'creative', 'kind'],
          'ageRating': '6+',
          'estimatedReadingTime': 12,
          'content': [
            "In a kingdom far, far away, where rainbow bridges crossed crystal rivers, lived a young princess named Luna who had a very special gift.",
            "Princess Luna could talk to animals! Every morning, she would wake up to find squirrels, rabbits, and birds gathered around her window, all chattering excitedly about their adventures.",
            "One day, a little fox came running to her with tears in his eyes. \"Princess Luna!\" he cried. \"The Magic Forest is losing all its colors! Without them, all the animals will forget how to be happy!\"",
          ],
        },
        {
          'title': 'Space Explorers',
          'author': 'Captain Cosmos',
          'description': 'Blast off on an incredible journey through space! Meet friendly aliens, explore distant planets, and learn about the wonders of the universe.',
          'coverEmoji': '🚀🤖',
          'traits': ['curious', 'analytical', 'adventurous'],
          'ageRating': '7+',
          'estimatedReadingTime': 18,
          'content': [
            "Commander Zara adjusted her space helmet and looked out at the twinkling stars. Today was the day she would lead her first mission to Planet Zephyr!",
            "\"Are you ready, Robo?\" she asked her faithful robot companion, who beeped excitedly in response.\n\nTogether, they climbed aboard their shiny silver spaceship and prepared for the adventure of a lifetime.",
            "As their rocket zoomed through the colorful nebula clouds, Zara spotted something amazing - a planet covered in crystal mountains that sparkled like diamonds in the starlight!",
          ],
        },
      ];

      for (final bookData in sampleBooks) {
        await _firestore.collection('books').add({
          ...bookData,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      
      print('Sample books initialized successfully!');
    } catch (e) {
      print('Error initializing sample books: $e');
    }
  }

  // Load all books
  Future<void> loadAllBooks() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final querySnapshot = await _firestore
          .collection('books')
          .orderBy('createdAt', descending: false)
          .get();

      _allBooks = querySnapshot.docs
          .map((doc) => Book.fromFirestore(doc))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load books: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get recommended books based on personality traits
  Future<void> loadRecommendedBooks(List<String> userTraits) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_allBooks.isEmpty) {
        await loadAllBooks();
      }

      // Filter books that match user's personality traits
      _recommendedBooks = _allBooks.where((book) {
        return book.traits.any((trait) => userTraits.contains(trait));
      }).toList();

      // If no trait matches, show some default books
      if (_recommendedBooks.isEmpty) {
        _recommendedBooks = _allBooks.take(3).toList();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load recommendations: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get user's reading progress
  Future<void> loadUserProgress(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('reading_progress')
          .where('userId', isEqualTo: userId)
          .orderBy('lastReadAt', descending: true)
          .get();

      _userProgress = querySnapshot.docs
          .map((doc) => ReadingProgress.fromFirestore(doc))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error loading user progress: $e');
    }
  }

  // Update reading progress
  Future<void> updateReadingProgress({
    required String userId,
    required String bookId,
    required int currentPage,
    required int totalPages,
    required int additionalReadingTime,
  }) async {
    try {
      final progressPercentage = currentPage / totalPages;
      final isCompleted = currentPage >= totalPages;

      // Check if progress already exists
      final existingProgressQuery = await _firestore
          .collection('reading_progress')
          .where('userId', isEqualTo: userId)
          .where('bookId', isEqualTo: bookId)
          .get();

      if (existingProgressQuery.docs.isNotEmpty) {
        // Update existing progress
        final docId = existingProgressQuery.docs.first.id;
        final existingData = existingProgressQuery.docs.first.data();
        
        await _firestore.collection('reading_progress').doc(docId).update({
          'currentPage': currentPage,
          'progressPercentage': progressPercentage,
          'readingTimeMinutes': (existingData['readingTimeMinutes'] ?? 0) + additionalReadingTime,
          'lastReadAt': FieldValue.serverTimestamp(),
          'isCompleted': isCompleted,
        });
      } else {
        // Create new progress record
        await _firestore.collection('reading_progress').add({
          'userId': userId,
          'bookId': bookId,
          'currentPage': currentPage,
          'totalPages': totalPages,
          'progressPercentage': progressPercentage,
          'readingTimeMinutes': additionalReadingTime,
          'lastReadAt': FieldValue.serverTimestamp(),
          'isCompleted': isCompleted,
        });
      }

      // Reload user progress
      await loadUserProgress(userId);
    } catch (e) {
      print('Error updating reading progress: $e');
    }
  }

  // Get book by ID
  Book? getBookById(String bookId) {
    try {
      return _allBooks.firstWhere((book) => book.id == bookId);
    } catch (e) {
      return null;
    }
  }

  // Get progress for a specific book
  ReadingProgress? getProgressForBook(String bookId) {
    try {
      return _userProgress.firstWhere((progress) => progress.bookId == bookId);
    } catch (e) {
      return null;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}