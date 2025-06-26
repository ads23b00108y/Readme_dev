import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reading_provider.dart';
import '../../services/tts_service.dart';
import '../../services/offline_service.dart';
import '../../services/gamification_service.dart';

class ReadingScreen extends StatefulWidget {
  final String bookTitle;
  final String bookId;
  final String childId;
  final String fullText;

  const ReadingScreen({
    super.key,
    required this.bookTitle,
    required this.bookId,
    required this.childId,
    required this.fullText,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final TTSService _ttsService = TTSService();
  final OfflineService _offlineService = OfflineService();
  late GamificationService _gamificationService;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ReadingProvider>(context, listen: false);
    _gamificationService = Provider.of<GamificationService>(context, listen: false);

    provider.loadBook(widget.fullText);
    _ttsService.speak(provider.pages[provider.currentPage]);

    _saveProgress(provider.currentPage);
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  Future<void> _saveProgress(int currentPage) async {
    try {
      await _offlineService.saveReadingProgress(
        widget.childId,
        widget.bookId,
        currentPage,
        _gamificationService.dailyMinutes,
      );
    } catch (e) {
      debugPrint('Error saving progress: $e');
    }
  }

  void _nextPage() async {
    final provider = Provider.of<ReadingProvider>(context, listen: false);
    provider.nextPage();
    _ttsService.speak(provider.pages[provider.currentPage]);

    _gamificationService.addReadingMinutes(1);
    _gamificationService.checkStreak();
    await _saveProgress(provider.currentPage);
  }

  void _previousPage() async {
    final provider = Provider.of<ReadingProvider>(context, listen: false);
    provider.previousPage();
    _ttsService.speak(provider.pages[provider.currentPage]);

    _gamificationService.addReadingMinutes(1);
    _gamificationService.checkStreak();
    await _saveProgress(provider.currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadingProvider>(
      builder: (context, provider, _) {
        if (provider.pages.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.bookTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: () => _ttsService.pause(),
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () => _ttsService.resume(),
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: () => _ttsService.stop(),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (provider.currentPage + 1) / provider.pages.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      provider.pages[provider.currentPage],
                      style: const TextStyle(fontSize: 18, height: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: provider.currentPage > 0 ? _previousPage : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                    ),
                    Text(
                      '${provider.currentPage + 1} / ${provider.pages.length}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      onPressed: provider.currentPage < provider.pages.length - 1
                          ? _nextPage
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                    ),
                  ],
                ),
                Consumer<GamificationService>(
                  builder: (context, gamification, _) {
                    return Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.timer, color: Colors.blue),
                              Text('${gamification.dailyMinutes} min'),
                              const Text('Today', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.local_fire_department, color: Colors.orange),
                              Text('${gamification.currentStreak}'),
                              const Text('Streak', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              Text('${gamification.totalPoints}'),
                              const Text('Points', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
