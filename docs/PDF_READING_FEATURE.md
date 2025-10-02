# PDF Reading Feature

## Overview
The PDF reading screen allows users to upload and read PDF documents with full text-to-speech support, progress tracking, and session management.

## Features

### 1. PDF File Upload
- Users can select PDF files using the file picker
- Supports both local file paths and file selection dialog
- Accessible from:
  - Book details screen (PDF button)
  - Library screen (floating action button - "Read PDF")

### 2. PDF Viewing
- Page-by-page PDF rendering using Syncfusion PDF Viewer
- Smooth page navigation with next/previous buttons
- Page indicator showing current page and total pages
- Progress bar showing reading completion percentage

### 3. Text-to-Speech Integration
- Extracts text from current PDF page
- Reads text aloud using Flutter TTS
- Play/pause controls
- Adjustable TTS speed (0.5x to 2.0x)
- Text extraction is cached for performance

### 4. Progress Tracking
- Tracks current page and reading progress
- Session duration tracking
- Integration with existing reading progress system
- Updates user's reading statistics in Firebase

### 5. Bookmarks
- Add bookmarks at any page
- View and navigate to saved bookmarks
- Bookmark list accessible from settings

### 6. Table of Contents Support
- Automatically extracts PDF bookmarks/TOC if available
- Chapter navigation button appears when TOC is present
- Quick jump to any chapter from TOC view

### 7. Reading Session Features
- Session start time tracking
- Automatic progress updates
- Completion dialog when finishing the PDF
- Reading history integration

## Usage

### From Book Details Screen
1. Navigate to any book's details page
2. Click the "PDF" button
3. Select a PDF file from your device
4. Start reading with TTS support

### From Library Screen
1. Open the library
2. Click the floating "Read PDF" button
3. Select a PDF file
4. Start reading

### Controls
- **Play/Pause**: Toggle text-to-speech for current page
- **Next/Previous**: Navigate between pages
- **Bookmark**: Save current page
- **TOC** (if available): Jump to chapters
- **Settings**: Adjust TTS speed, view bookmarks

## Technical Details

### Dependencies
- `syncfusion_flutter_pdfviewer`: PDF rendering
- `syncfusion_flutter_pdf`: PDF text extraction and TOC parsing
- `file_picker`: File selection dialog
- `flutter_tts`: Text-to-speech functionality

### Key Components
- `ReadingScreenPDF`: Main PDF reading widget
- `PdfViewerController`: Controls PDF navigation
- `PdfDocument`: Handles PDF document operations
- Text extraction cache: Improves performance for re-reading pages

### Files Modified
- `pubspec.yaml`: Added PDF dependencies
- `lib/screens/book/reading_screen_pdf.dart`: New PDF reading screen
- `lib/screens/book/book_details_screen.dart`: Added PDF button
- `lib/screens/child/library_screen.dart`: Added PDF FAB

## Future Enhancements
- Highlight text being read by TTS
- Search within PDF
- Annotations and notes
- PDF zoom controls
- Night mode for PDF reading
