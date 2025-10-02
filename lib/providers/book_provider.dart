// File: lib/providers/book_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api_service.dart';
import '../services/analytics_service.dart';
import '../services/achievement_service.dart';
import '../services/content_filter_service.dart';
import '../services/gutenberg_service.dart';
import '../models/chapter.dart';
import '../models/chapter.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String? coverImageUrl; // Real cover image URL from Open Library
  final String? coverEmoji;    // Emoji fallback for books without covers
  final List<String> traits; // For personality matching
  final String ageRating;
  final int estimatedReadingTime; // in minutes
  final String? pdfUrl; // PDF file URL (local or remote)
  final DateTime createdAt;
  final String? source; // Source of the book (Open Library, Project Gutenberg, etc.)
  final bool hasRealContent; // Whether book contains real excerpts
  final String contentType; // NEW: 'story' | 'novel' | 'collection'
  final int wordCount; // NEW: Total word count
  final String readingLevel; // NEW: 'Easy' | 'Medium' | 'Advanced'
  final int estimatedReadingHours; // NEW: For full books (in addition to minutes)
  final Map<String, dynamic>? gutenbergMetadata; // NEW: Project Gutenberg metadata

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    this.coverImageUrl,        // Real cover from Open Library
    this.coverEmoji,           // Emoji fallback
    required this.traits,
    required this.ageRating,
    required this.estimatedReadingTime,
  this.pdfUrl,               // PDF file URL
    required this.createdAt,
    this.source,               // Book source
    this.hasRealContent = false, // Content authenticity flag
    this.contentType = 'story', // NEW: Default to story
    this.wordCount = 0,        // NEW: Word count
    this.readingLevel = 'Easy', // NEW: Reading level
    this.estimatedReadingHours = 0, // NEW: Reading hours
    this.gutenbergMetadata,    // NEW: Gutenberg metadata
  });

  // Enhanced helper methods for cover display
  String get displayCover => coverEmoji ?? '📚';
  bool get hasRealCover => coverImageUrl != null && 
                          coverImageUrl!.isNotEmpty && 
                          coverImageUrl!.startsWith('http');
  
  // Get the best available cover (prioritize real images)
  String? get bestCoverUrl => hasRealCover ? coverImageUrl : null;
  String get fallbackEmoji => coverEmoji ?? '📚';

  // PDF support
  bool get hasPdf => pdfUrl != null && pdfUrl!.isNotEmpty;

  // NEW: Get chapter by number
  Chapter? getChapter(int chapterNumber) {
    if (hasChapters && chapterNumber > 0 && chapterNumber <= chapters!.length) {
      return chapters![chapterNumber - 1];
    }
    return null;
  }

  // NEW: Get page info (which chapter and page within chapter)
  Map<String, int> getPageInfo(int globalPageIndex) {
    if (!hasChapters) {
      return {'chapter': 1, 'pageInChapter': globalPageIndex + 1, 'totalInChapter': content.length};
    }

    int currentIndex = 0;
    for (int i = 0; i < chapters!.length; i++) {
      final chapter = chapters![i];
      if (globalPageIndex < currentIndex + chapter.totalPages) {
        return {
          'chapter': i + 1,
          'pageInChapter': globalPageIndex - currentIndex + 1,
          'totalInChapter': chapter.totalPages,
        };
      }
      currentIndex += chapter.totalPages;
    }

    // If we get here, return the last chapter
    final lastChapter = chapters!.last;
    return {
      'chapter': chapters!.length,
      'pageInChapter': lastChapter.totalPages,
      'totalInChapter': lastChapter.totalPages,
    };
  }

  // NEW: Check if this is a full-length book
  bool get isFullBook => contentType == 'novel' || wordCount > 5000 || totalChapters > 3;

  // NEW: Get appropriate reading time display
  String get readingTimeDisplay {
    if (isFullBook && estimatedReadingHours > 0) {
      final hours = estimatedReadingHours;
      final minutes = estimatedReadingTime % 60;
      if (hours >= 1) {
        return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
      }
    }
    return '${estimatedReadingTime}m';
  }

  factory Book.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Handle PDF URL
    String? pdfUrl = data['pdfUrl'];
    
    // Ensure we have valid cover URL format
    String? validCoverUrl = data['coverImageUrl'];
    if (validCoverUrl != null && !validCoverUrl.startsWith('http')) {
      validCoverUrl = null; // Invalid URL format
    }
    
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      description: data['description'] ?? '',
      coverImageUrl: validCoverUrl, // Validated cover URL
      coverEmoji: data['coverEmoji'], // Fallback emoji
      traits: List<String>.from(data['traits'] ?? []),
      ageRating: data['ageRating'] ?? '6+',
      estimatedReadingTime: data['estimatedReadingTime'] ?? 15,
  pdfUrl: pdfUrl,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      source: data['source'], // Book source tracking
      hasRealContent: data['hasRealContent'] ?? false, // Content authenticity
      contentType: data['contentType'] ?? 'story', // NEW: Content type
      wordCount: data['wordCount'] ?? 0, // NEW: Word count
      readingLevel: data['readingLevel'] ?? 'Easy', // NEW: Reading level
      estimatedReadingHours: data['estimatedReadingHours'] ?? 0, // NEW: Reading hours
      gutenbergMetadata: data['gutenbergMetadata'] as Map<String, dynamic>?, // NEW: Gutenberg metadata
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'coverImageUrl': coverImageUrl, // Real cover image URL
      'coverEmoji': coverEmoji, // Emoji fallback
      'traits': traits,
      'ageRating': ageRating,
      'estimatedReadingTime': estimatedReadingTime,
      'content': content, // Legacy content
      'chapters': chapters?.map((chapter) => chapter.toMap()).toList(), // NEW: Chapter structure
      'createdAt': Timestamp.fromDate(createdAt),
      'source': source, // Book source
      'hasRealContent': hasRealContent, // Content authenticity
      'contentType': contentType, // NEW: Content type
      'wordCount': wordCount, // NEW: Word count
      'readingLevel': readingLevel, // NEW: Reading level
      'estimatedReadingHours': estimatedReadingHours, // NEW: Reading hours
      'gutenbergMetadata': gutenbergMetadata, // NEW: Gutenberg metadata
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
  final int? currentChapter;
  final int? currentPageInChapter;

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
    this.currentChapter,
    this.currentPageInChapter,
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
      currentChapter: data['currentChapter'],
      currentPageInChapter: data['currentPageInChapter'],
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
      'currentChapter': currentChapter,
      'currentPageInChapter': currentPageInChapter,
    };
  }
}

class BookProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ApiService _apiService = ApiService();
  final AnalyticsService _analyticsService = AnalyticsService();
  final AchievementService _achievementService = AchievementService();
  final ContentFilterService _contentFilterService = ContentFilterService();
  
  List<Book> _allBooks = [];
  List<Book> _recommendedBooks = [];
  List<ReadingProgress> _userProgress = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _sessionStart;

  // Getters
  List<Book> get allBooks => _allBooks;
  List<Book> get recommendedBooks => _recommendedBooks;
  List<ReadingProgress> get userProgress => _userProgress;
  List<Book> get filteredBooks => _filteredBooks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize sample books (call this once to populate the database)
  Future<void> initializeSampleBooks() async {
    try {
      // Check if books already exist to avoid duplicates
      final existingBooks = await _firestore.collection('books').limit(1).get();
      if (existingBooks.docs.isNotEmpty) {
        print('Sample books already exist, skipping initialization');
        return;
      }

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
        {
          'title': 'The Brave Little Dragon',
          'author': 'Fire Tales',
          'description': 'Meet Spark, a small dragon who discovers that being different makes you special! A heartwarming story about friendship and self-acceptance.',
          'coverEmoji': '🐲🔥',
          'traits': ['brave', 'kind', 'creative'],
          'ageRating': '6+',
          'estimatedReadingTime': 14,
          'content': [
            "In a valley surrounded by tall mountains, there lived a little dragon named Spark who was different from all the other dragons.",
            "While other dragons breathed fire, Spark could only make tiny sparkles that danced in the air like fireflies.",
            "One day, when the village was in danger, Spark discovered that his special sparkles were exactly what was needed to save everyone!",
          ],
        },
        {
          'title': 'Ocean Friends',
          'author': 'Marina Deep',
          'description': 'Dive into an underwater adventure with Finn the fish and his ocean friends! Learn about friendship, teamwork, and protecting our seas.',
          'coverEmoji': '🐠🌊',
          'traits': ['curious', 'kind', 'adventurous'],
          'ageRating': '6+',
          'estimatedReadingTime': 16,
          'content': [
            "Deep beneath the sparkling waves, in a coral reef full of colors, lived a cheerful little fish named Finn.",
            "Finn loved exploring the ocean and making new friends, from tiny seahorses to gentle sea turtles.",
            "When the reef faced a big problem, Finn and his friends had to work together to find a solution and save their beautiful home.",
          ],
        },
      ];

      print('Adding ${sampleBooks.length} sample books to database...');
      
      for (final bookData in sampleBooks) {
        await _firestore.collection('books').add({
          ...bookData,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('Added book: ${bookData['title']}');
      }
      
      print('Sample books initialized successfully!');
    } catch (e) {
      print('Error initializing sample books: $e');
      rethrow; // Re-throw to handle in calling code
    }
  }

  // FIXED: Load all books with content filtering - removes orderBy constraint
  Future<void> loadAllBooks({String? userId}) async {
    try {
      _isLoading = true;
      _error = null;
      // Delay notifying listeners to ensure we finish the build phase
      Future.delayed(Duration.zero, () => notifyListeners());

      // FIXED: Remove orderBy to get ALL books, regardless of createdAt field
      final querySnapshot = await _firestore
          .collection('books')
          .get();

      _allBooks = querySnapshot.docs
          .map((doc) => Book.fromFirestore(doc))
          .toList();

      print('DEBUG: Loaded ${_allBooks.length} books from Firestore');
      if (_allBooks.isNotEmpty) {
        print('DEBUG: First few book titles: ${_allBooks.take(5).map((b) => b.title).join(", ")}');
      }

      // Apply content filtering if userId is provided
      if (userId != null) {
        try {
          final booksData = _allBooks.map((book) => {
            'id': book.id,
            'title': book.title,
            'author': book.author,
            'description': book.description,
            'ageRating': book.ageRating,
            'traits': book.traits,
            'content': book.content,
          }).toList();

          final filteredBooksData = await _contentFilterService.filterBooks(booksData, userId);
          final filteredIds = filteredBooksData.map((book) => book['id']).toSet();
          
          _filteredBooks = _allBooks.where((book) => filteredIds.contains(book.id)).toList();
          print('DEBUG: After filtering: ${_filteredBooks.length} books');
        } catch (filterError) {
          print('Error applying content filter: $filterError');
          // Fallback to all books if filtering fails
          _filteredBooks = _allBooks;
        }
      } else {
        _filteredBooks = _allBooks;
      }

      _isLoading = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch (e) {
      print('Error loading books: $e');
      _error = 'Failed to load books: $e';
      _isLoading = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    }
  }

  // Get recommended books based on personality traits with enhanced filtering
  Future<void> loadRecommendedBooks(List<String> userTraits, {String? userId}) async {
    try {
      _isLoading = true;
      Future.delayed(Duration.zero, () => notifyListeners());

      if (_allBooks.isEmpty) {
        await loadAllBooks(userId: userId);
      }

      // Use API service for enhanced recommendations
      try {
        final recommendedBooksData = await _apiService.getRecommendedBooks(userTraits);
        final recommendedIds = recommendedBooksData.map((book) => book['id']).toSet();
        
        _recommendedBooks = (userId != null ? _filteredBooks : _allBooks)
            .where((book) => recommendedIds.contains(book.id))
            .toList();
      } catch (e) {
        print('API recommendation failed, using local filtering: $e');
        // Fallback to local filtering if API fails
        _recommendedBooks = (userId != null ? _filteredBooks : _allBooks).where((book) {
          return book.traits.any((trait) => userTraits.contains(trait));
        }).toList();
      }

      // If no trait matches, show some default books
      if (_recommendedBooks.isEmpty) {
        _recommendedBooks = (userId != null ? _filteredBooks : _allBooks).take(5).toList();
      }

      _isLoading = false;
      Future.delayed(Duration.zero, () => notifyListeners());
    } catch (e) {
      print('Error loading recommendations: $e');
      _error = 'Failed to load recommendations: $e';
      _isLoading = false;
      Future.delayed(Duration.zero, () => notifyListeners());
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

      Future.delayed(Duration.zero, () => notifyListeners());
    } catch (e) {
      print('Error loading user progress: $e');
      // Don't notify listeners on error to avoid build issues
    }
  }

  // Update reading progress with enhanced tracking
  Future<void> updateReadingProgress({
    required String userId,
    required String bookId,
    required int currentPage,
    required int totalPages,
    required int additionalReadingTime,
    bool? isCompleted,
    int? currentChapter,
    int? currentPageInChapter,
  }) async {
    try {
      final progressPercentage = totalPages > 0 ? currentPage / totalPages : 0.0;
      final bookCompleted = isCompleted ?? (currentPage >= totalPages);
      final sessionEnd = DateTime.now();

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
          'isCompleted': bookCompleted,
          'currentChapter': currentChapter,
          'currentPageInChapter': currentPageInChapter,
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
          'isCompleted': bookCompleted,
          'currentChapter': currentChapter,
          'currentPageInChapter': currentPageInChapter,
        });
      }

      // Track analytics
      if (_sessionStart != null) {
        final book = getBookById(bookId);
        await _analyticsService.trackReadingSession(
          bookId: bookId,
          bookTitle: book?.title ?? 'Unknown',
          pageNumber: currentPage,
          totalPages: totalPages,
          sessionDurationSeconds: sessionEnd.difference(_sessionStart!).inSeconds,
          sessionStart: _sessionStart!,
          sessionEnd: sessionEnd,
        );
      }

      // Track content filter reading time
      await _contentFilterService.trackReadingTime(userId, additionalReadingTime);

      // Check and unlock achievements
      await _checkAchievements(userId);

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

  // Start reading session
  void startReadingSession() {
    _sessionStart = DateTime.now();
  }

  // End reading session
  void endReadingSession() {
    _sessionStart = null;
  }

  // Check and unlock achievements
  Future<void> _checkAchievements(String userId) async {
    try {
      // Get user stats
      final completedBooks = _userProgress.where((p) => p.isCompleted).length;
      final totalReadingTime = _userProgress.fold<int>(
        0, 
        (sum, progress) => sum + progress.readingTimeMinutes,
      );

      // Get analytics for streak calculation
      final analytics = await _analyticsService.getUserReadingAnalytics(userId);
      final currentStreak = analytics['currentStreak'] ?? 0;
      final totalSessions = analytics['totalSessions'] ?? 0;

      // Check achievements
      await _achievementService.checkAndUnlockAchievements(
        booksCompleted: completedBooks,
        readingStreak: currentStreak,
        totalReadingMinutes: totalReadingTime,
        totalSessions: totalSessions,
      );
    } catch (e) {
      print('Error checking achievements: $e');
    }
  }

  // Get filtered books for user
  Future<List<Book>> getFilteredBooks(String userId) async {
    if (_filteredBooks.isEmpty && _allBooks.isNotEmpty) {
      await loadAllBooks(userId: userId);
    }
    return _filteredBooks;
  }

  // Track book interaction
  Future<void> trackBookInteraction({
    required String bookId,
    required String action,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _analyticsService.trackBookInteraction(
        bookId: bookId,
        action: action,
        metadata: metadata,
      );
    } catch (e) {
      print('Error tracking book interaction: $e');
    }
  }

  // Get reading time restrictions
  Future<Map<String, dynamic>> getReadingTimeRestrictions(String userId) async {
    return await _contentFilterService.getReadingTimeRestrictions(userId);
  }

  // Check if user has exceeded daily reading limit
  Future<bool> hasExceededDailyLimit(String userId) async {
    return await _contentFilterService.hasExceededDailyLimit(userId);
  }

  // Report inappropriate content
  Future<void> reportInappropriateContent({
    required String bookId,
    required String reason,
    required String description,
  }) async {
    await _contentFilterService.reportInappropriateContent(
      bookId: bookId,
      reason: reason,
      description: description,
    );
  }

  // Clear error
  void clearError() {
    _error = null;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  // NEW: Get books by reading status
  List<Book> getBooksByStatus(String status) {
    switch (status.toLowerCase()) {
      case 'all':
        return _allBooks;
      case 'ongoing':
        // Books with progress but not completed
        final ongoingBookIds = _userProgress
            .where((progress) => progress.progressPercentage > 0 && !progress.isCompleted)
            .map((progress) => progress.bookId)
            .toSet();
        return _allBooks.where((book) => ongoingBookIds.contains(book.id)).toList();
      case 'completed':
        // Books that are completed
        final completedBookIds = _userProgress
            .where((progress) => progress.isCompleted)
            .map((progress) => progress.bookId)
            .toSet();
        return _allBooks.where((book) => completedBookIds.contains(book.id)).toList();
      default:
        return _allBooks;
    }
  }

  // NEW: Search books by title, author, or description
  List<Book> searchBooks(String query) {
    if (query.isEmpty) return _allBooks;
    
    final lowercaseQuery = query.toLowerCase();
    return _allBooks.where((book) {
      return book.title.toLowerCase().contains(lowercaseQuery) ||
             book.author.toLowerCase().contains(lowercaseQuery) ||
             book.description.toLowerCase().contains(lowercaseQuery) ||
             book.traits.any((trait) => trait.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // NEW: Filter books by age rating
  List<Book> filterBooksByAge(String ageRating) {
    if (ageRating.isEmpty || ageRating == 'All') return _allBooks;
    return _allBooks.where((book) => book.ageRating == ageRating).toList();
  }

  // NEW: Filter books by traits
  List<Book> filterBooksByTraits(List<String> traits) {
    if (traits.isEmpty) return _allBooks;
    return _allBooks.where((book) {
      return book.traits.any((trait) => traits.contains(trait));
    }).toList();
  }

  // NEW: Get favorite books (for now, return first 10 books as favorites)
  // TODO: Implement proper favorites system with user preferences
  List<Book> getFavoriteBooks() {
    // For now, return books that have been read (have progress)
    final readBookIds = _userProgress.map((progress) => progress.bookId).toSet();
    final favoriteBooks = _allBooks.where((book) => readBookIds.contains(book.id)).toList();
    
    // If no read books, return first 5 books as sample favorites
    if (favoriteBooks.isEmpty) {
      return _allBooks.take(5).toList();
    }
    
    return favoriteBooks;
  }

  // NEW: Add book to favorites (placeholder for future implementation)
  Future<void> addToFavorites(String bookId) async {
    // TODO: Implement favorites in Firestore
    print('Adding book $bookId to favorites');
    notifyListeners();
  }

  // NEW: Remove book from favorites (placeholder for future implementation)
  Future<void> removeFromFavorites(String bookId) async {
    // TODO: Implement favorites removal in Firestore
    print('Removing book $bookId from favorites');
    notifyListeners();
  }
}
