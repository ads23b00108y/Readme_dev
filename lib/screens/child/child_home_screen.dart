// File: lib/screens/child/child_home_screen.dart
import 'package:flutter/material.dart';
import '../book/book_details_screen.dart';
import 'library_screen.dart';
import 'settings_screen.dart';

class ChildHomeScreen extends StatelessWidget {
  const ChildHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose what',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'to read today',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Profile avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF8E44AD).withOpacity(0.1),
                      border: Border.all(
                        color: const Color(0xFF8E44AD),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '👦',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Reading calendar/streak
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF8E44AD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Thu 26, jun',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Week calendar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDayCircle('Mon', true),
                        _buildDayCircle('Tue', true),
                        _buildDayCircle('Wed', true),
                        _buildDayCircle('Thu', true, isToday: true),
                        _buildDayCircle('Fri', false),
                        _buildDayCircle('Sat', false),
                        _buildDayCircle('Sun', false),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Uncompleted section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Uncompleted',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See all >',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8E44AD),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 15),
              
              // Uncompleted book card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookDetailsScreen(
                        bookId: '1',
                        title: 'The enchanted monkey',
                        author: 'Maya Adventure',
                        description: 'Follow Koko the monkey on an amazing adventure through the magical jungle! Discover hidden treasures, make new friends, and learn about courage and friendship.',
                        ageRating: '6+',
                        emoji: '🐒✨',
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Book cover
                      Container(
                        width: 60,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8E44AD).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            '📚',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Book info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'The enchanted monkey',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Explore with koko',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Continue reading >',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8E44AD),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Progress bar
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: 0.7,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF8E44AD),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  '70%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Recommended books section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended books',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See all >',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8E44AD),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 15),
              
              // Recommended books list
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookDetailsScreen(
                        bookId: '2',
                        title: 'Fairytale adventures',
                        author: 'Emma Wonder',
                        description: 'Enter a world of magic and wonder! Meet brave princesses, helpful fairies, and discover that true magic comes from kindness and courage.',
                        ageRating: '6+',
                        emoji: '🧚‍♀️🌟',
                      ),
                    ),
                  );
                },
                child: _buildBookCard(
                  context,
                  'Fairytale adventures',
                  'A jungle mystery',
                  '6+',
                  '🧚‍♀️🌟',
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookDetailsScreen(
                        bookId: '3',
                        title: 'Space explorers',
                        author: 'Captain Cosmos',
                        description: 'Blast off on an incredible journey through space! Meet friendly aliens, explore distant planets, and learn about the wonders of the universe.',
                        ageRating: '7+',
                        emoji: '🚀🤖',
                      ),
                    ),
                  );
                },
                child: _buildBookCard(
                  context,
                  'Space explorers',
                  'Robot friends',
                  '7+',
                  '🚀🤖',
                ),
              ),
              
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(context, Icons.home, 'Home', true),
            _buildNavItem(context, Icons.library_books, 'Library', false),
            _buildNavItem(context, Icons.settings, 'Settings', false),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCircle(String day, bool isCompleted, {bool isToday = false}) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted 
              ? (isToday ? Colors.white : const Color(0xFFF7DC6F))
              : Colors.transparent,
            border: isToday 
              ? null 
              : Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1,
                ),
          ),
          child: Center(
            child: isCompleted
              ? Icon(
                  Icons.check,
                  size: 16,
                  color: isToday ? const Color(0xFF8E44AD) : Colors.white,
                )
              : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildBookCard(BuildContext context, String title, String subtitle, String age, String emoji) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Book cover
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF8E44AD).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 25),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Book info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_stories,
                      size: 16,
                      color: Color(0xFF8E44AD),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.star_outline,
                      size: 16,
                      color: Color(0xFF8E44AD),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 16,
                      color: Color(0xFF8E44AD),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      age,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Read button
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF8E44AD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Read >',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (label == 'Library' && !isActive) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LibraryScreen(),
            ),
          );
        } else if (label == 'Settings' && !isActive) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF8E44AD) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF8E44AD) : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}