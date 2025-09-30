import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../providers/book_provider.dart';
import '../../providers/auth_provider.dart';
import '../../screens/child/library_screen.dart';

/// PDF Reading Screen with TTS, Progress Tracking, and Session Management
/// 
/// Features:
/// - PDF file upload/selection
/// - Page-by-page PDF viewing
/// - Text-to-Speech for current page
/// - Progress tracking (current page, % completed)
/// - Bookmarks support
/// - Reading session tracking
/// - Chapter navigation (for PDFs with TOC)
class ReadingScreenPDF extends StatefulWidget {
  final String? bookId;
  final String? title;
  final String? author;
  final String? pdfPath;

  const ReadingScreenPDF({
    super.key,
    this.bookId,
    this.title,
    this.author,
    this.pdfPath,
  });

  @override
  State<ReadingScreenPDF> createState() => _ReadingScreenPDFState();
}

class _ReadingScreenPDFState extends State<ReadingScreenPDF> {
  // PDF Viewer Controller
  final PdfViewerController _pdfViewerController = PdfViewerController();
  
  // TTS
  late FlutterTts _flutterTts;
  bool _isTtsInitialized = false;
  bool _isPlaying = false;
  double _ttsSpeed = 1.0;
  
  // PDF Document
  String? _pdfPath;
  PdfDocument? _pdfDocument;
  
  // Progress tracking
  int _currentPage = 0;
  int _totalPages = 0;
  double _readingProgress = 0.0;
  DateTime? _sessionStart;
  
  // UI State
  bool _isLoading = true;
  String? _error;
  double _fontSize = 18.0;
  
  // Bookmarks
  final List<Map<String, dynamic>> _bookmarks = [];
  
  // Text extraction cache
  final Map<int, String> _pageTextCache = {};
  
  @override
  void initState() {
    super.initState();
    _sessionStart = DateTime.now();
    _initializeTts();
    
    if (widget.pdfPath != null) {
      _loadPdfFromPath(widget.pdfPath!);
    } else {
      // Prompt user to select PDF
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectPdfFile();
      });
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _updateReadingProgress();
    _pdfDocument?.dispose();
    super.dispose();
  }

  Future<void> _initializeTts() async {
    try {
      _flutterTts = FlutterTts();
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(_ttsSpeed);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      _flutterTts.setCompletionHandler(() {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
      
      setState(() {
        _isTtsInitialized = true;
      });
    } catch (e) {
      print('TTS Initialization Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Text-to-speech not available'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _selectPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        await _loadPdfFromPath(result.files.single.path!);
      } else {
        setState(() {
          _error = 'No PDF file selected';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error selecting PDF file: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPdfFromPath(String path) async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _pdfPath = path;
      });

      // Load PDF document for text extraction
      final bytes = await File(path).readAsBytes();
      _pdfDocument = PdfDocument(inputBytes: bytes);
      
      setState(() {
        _totalPages = _pdfDocument!.pages.count;
        _currentPage = 0;
        _readingProgress = 0.0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading PDF: $e';
        _isLoading = false;
      });
    }
  }

  Future<String> _extractTextFromPage(int pageIndex) async {
    // Check cache first
    if (_pageTextCache.containsKey(pageIndex)) {
      return _pageTextCache[pageIndex]!;
    }

    if (_pdfDocument == null || pageIndex >= _pdfDocument!.pages.count) {
      return '';
    }

    try {
      final page = _pdfDocument!.pages[pageIndex];
      final textExtractor = PdfTextExtractor(_pdfDocument!);
      final text = textExtractor.extractText(startPageIndex: pageIndex, endPageIndex: pageIndex);
      
      // Cache the extracted text
      _pageTextCache[pageIndex] = text;
      return text;
    } catch (e) {
      print('Error extracting text from page $pageIndex: $e');
      return '';
    }
  }

  Future<void> _togglePlayPause() async {
    if (!_isTtsInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text-to-speech is not available'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      if (_isPlaying) {
        await _flutterTts.stop();
        setState(() {
          _isPlaying = false;
        });
      } else {
        // Extract text from current page
        final text = await _extractTextFromPage(_currentPage);
        
        if (text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No text found on this page'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        await _flutterTts.speak(text);
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print('TTS Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _readingProgress = _totalPages > 0 ? (_currentPage + 1) / _totalPages : 0.0;
      _isPlaying = false;
    });
    _flutterTts.stop();
    _updateReadingProgress();
  }

  Future<void> _nextPage() async {
    if (_currentPage < _totalPages - 1) {
      _pdfViewerController.nextPage();
    } else {
      await _completeBook();
    }
  }

  Future<void> _previousPage() async {
    if (_currentPage > 0) {
      _pdfViewerController.previousPage();
    }
  }

  void _addBookmark() {
    final bookmark = {
      'page': _currentPage,
      'timestamp': DateTime.now(),
    };
    
    setState(() {
      _bookmarks.add(bookmark);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmark added at page ${_currentPage + 1}'),
        backgroundColor: const Color(0xFF8E44AD),
      ),
    );
  }

  void _goToBookmark(int pageIndex) {
    _pdfViewerController.jumpToPage(pageIndex + 1);
  }

  Future<void> _updateReadingProgress() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      
      final user = authProvider.currentUser;
      if (user == null || _sessionStart == null) return;

      final sessionEnd = DateTime.now();
      final additionalReadingTime = sessionEnd.difference(_sessionStart!).inMinutes;

      await bookProvider.updateReadingProgress(
        userId: user.uid,
        bookId: widget.bookId ?? 'pdf_${_pdfPath?.hashCode ?? 'unknown'}',
        currentPage: _currentPage,
        totalPages: _totalPages,
        additionalReadingTime: additionalReadingTime,
      );
    } catch (e) {
      print('Error updating reading progress: $e');
    }
  }

  Future<void> _completeBook() async {
    await _flutterTts.stop();
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      
      final user = authProvider.currentUser;
      if (user != null && _sessionStart != null) {
        final sessionEnd = DateTime.now();
        final totalReadingTime = sessionEnd.difference(_sessionStart!).inMinutes;

        await bookProvider.updateReadingProgress(
          userId: user.uid,
          bookId: widget.bookId ?? 'pdf_${_pdfPath?.hashCode ?? 'unknown'}',
          currentPage: _totalPages,
          totalPages: _totalPages,
          additionalReadingTime: totalReadingTime,
          isCompleted: true,
        );
      }
    } catch (e) {
      print('Error completing book: $e');
    }

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text(
              '🎉 Congratulations!',
              style: TextStyle(color: Color(0xFF8E44AD)),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'You\'ve finished reading this PDF!',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Great job on completing all $_totalPages pages! 📚✨',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Read Again', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E44AD),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LibraryScreen()),
                  );
                },
                child: const Text('Go to Library'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildSettingsSheet(),
    );
  }

  Widget _buildSettingsSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Reading Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8E44AD),
            ),
          ),
          const SizedBox(height: 20),
          
          // TTS Speed
          Row(
            children: [
              const Text('TTS Speed:', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Slider(
                  value: _ttsSpeed,
                  min: 0.5,
                  max: 2.0,
                  divisions: 6,
                  activeColor: const Color(0xFF8E44AD),
                  onChanged: (value) {
                    setState(() {
                      _ttsSpeed = value;
                    });
                    _flutterTts.setSpeechRate(value);
                  },
                ),
              ),
              Text('${_ttsSpeed.toStringAsFixed(1)}x'),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Bookmarks
          if (_bookmarks.isNotEmpty) ...[
            const Divider(),
            const Text(
              'Bookmarks',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: _bookmarks.length,
                itemBuilder: (context, index) {
                  final bookmark = _bookmarks[index];
                  return ListTile(
                    leading: const Icon(Icons.bookmark, color: Color(0xFF8E44AD)),
                    title: Text('Page ${bookmark['page'] + 1}'),
                    subtitle: Text(
                      '${bookmark['timestamp'].toString().split('.')[0]}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _goToBookmark(bookmark['page']);
                    },
                  );
                },
              ),
            ),
          ],
          
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8E44AD),
              foregroundColor: Colors.white,
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFFDF7),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF8E44AD),
              ),
              const SizedBox(height: 20),
              Text(
                _pdfPath == null ? 'Waiting for PDF selection...' : 'Loading PDF...',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFFDF7),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 20),
                Text(
                  _error!,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _selectPdfFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8E44AD),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Select PDF'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_pdfPath == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFFDF7),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.picture_as_pdf, size: 64, color: Color(0xFF8E44AD)),
              const SizedBox(height: 20),
              const Text(
                'Select a PDF to start reading',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectPdfFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E44AD),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Select PDF'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF8E44AD)),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title ?? 'PDF Document',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8E44AD),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.author != null)
                              Text(
                                'by ${widget.author}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _addBookmark,
                        icon: const Icon(Icons.bookmark_add, color: Color(0xFF8E44AD)),
                      ),
                      IconButton(
                        onPressed: _showSettings,
                        icon: const Icon(Icons.settings, color: Color(0xFF8E44AD)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Progress bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Page ${_currentPage + 1} of $_totalPages',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            '${(_readingProgress * 100).toStringAsFixed(0)}% complete',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _readingProgress,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8E44AD)),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // PDF Viewer
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SfPdfViewer.file(
                      File(_pdfPath!),
                      controller: _pdfViewerController,
                      onPageChanged: (PdfPageChangedDetails details) {
                        _onPageChanged(details.newPageNumber - 1);
                      },
                    ),
                  ),
                ),
              ),
            ),
            
            // Navigation controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous page
                  IconButton(
                    onPressed: _currentPage > 0 ? _previousPage : null,
                    icon: Icon(
                      Icons.chevron_left,
                      size: 32,
                      color: _currentPage > 0 
                          ? const Color(0xFF8E44AD)
                          : Colors.grey[400],
                    ),
                  ),
                  
                  // Play/Pause button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8E44AD), Color(0xFFE056FD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8E44AD).withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      iconSize: 40,
                      onPressed: _togglePlayPause,
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  // Next page
                  IconButton(
                    onPressed: _currentPage < _totalPages - 1 ? _nextPage : null,
                    icon: Icon(
                      Icons.chevron_right,
                      size: 32,
                      color: _currentPage < _totalPages - 1
                          ? const Color(0xFF8E44AD)
                          : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
