# ReadMe - Personalized Reading App for Kids

A Flutter-based reading application with personality-based book recommendations and advanced reading features.

## Features

### Core Reading Features
- **Text-to-Speech (TTS)**: Reads books aloud with adjustable speed
- **Progress Tracking**: Tracks reading progress, session duration, and completion
- **Bookmarks**: Save and return to favorite pages
- **Chapter Navigation**: Navigate through book chapters with table of contents

### PDF Reading Support ✨ NEW
- **PDF Upload**: Select and read PDF files with full TTS support
- **Text Extraction**: Automatic text extraction from PDF pages for TTS
- **Progress Tracking**: Same tracking features as regular books
- **Table of Contents**: Navigate PDF chapters if TOC is available
- **Bookmarks**: Add bookmarks to PDF pages

See [PDF Reading Feature Documentation](docs/PDF_READING_FEATURE.md) for detailed information.

### User Management
- Firebase authentication
- User profiles with reading preferences
- Reading history and statistics
- Achievement system

### Book Library
- Curated collection of children's books
- Personality-based recommendations
- Age-appropriate content filtering
- Search and filter capabilities

## Getting Started

### Prerequisites
- Flutter SDK (>=3.1.0 <4.0.0)
- Firebase project setup
- Android/iOS development environment

### Installation

1. Clone the repository:
```bash
git clone https://github.com/ads23b00108y/Readme_dev.git
cd Readme_dev
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up Firebase:
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Configure Firebase in the Firebase console

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   └── chapter.dart          # Chapter model
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── book_provider.dart
│   └── user_provider.dart
├── screens/                  # UI screens
│   ├── book/                 # Book-related screens
│   │   ├── reading_screen.dart
│   │   ├── reading_screen_enhanced.dart
│   │   ├── reading_screen_pdf.dart  # PDF reading screen
│   │   └── book_details_screen.dart
│   └── child/                # Child user screens
│       └── library_screen.dart
└── services/                 # Backend services
    ├── api_service.dart
    ├── analytics_service.dart
    └── notification_service.dart
```

## Key Dependencies

- **firebase_core**: Firebase integration
- **provider**: State management
- **flutter_tts**: Text-to-speech functionality
- **syncfusion_flutter_pdfviewer**: PDF rendering
- **syncfusion_flutter_pdf**: PDF text extraction
- **file_picker**: File selection
- **cached_network_image**: Image caching

## Usage

### Reading Books
1. Browse the library
2. Select a book
3. Click "Start Reading" or "Continue Reading"
4. Use play/pause for TTS
5. Navigate with arrow buttons

### Reading PDFs
1. From library, tap the "Read PDF" floating button, OR
2. From any book details, tap the "PDF" button
3. Select a PDF file from your device
4. Use the same controls as regular books
5. Access TOC if available via the menu button

## Contributing

This is a personal project. Feel free to fork and adapt for your needs.

## License

This project is for educational purposes.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Syncfusion PDF Documentation](https://help.syncfusion.com/flutter/pdf/overview)
