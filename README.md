# ReadMe - Personalized Reading App for Kids

A Flutter application that provides personalized reading experiences for children with personality-based book recommendations, text-to-speech capabilities, and progress tracking.

## Features

### 📚 Book Reading
- Support for both text-based books and PDF documents
- Interactive reading with page navigation
- Reading progress tracking
- Session timing and analytics

### 🎧 Text-to-Speech (TTS)
- Built-in text-to-speech for all books
- Adjustable reading speed (0.5x to 2.0x)
- Auto-progression to next page after completion
- TTS support for PDF books via text extraction

### 📄 PDF Support (NEW!)
- Upload and read PDF files directly in the app
- Syncfusion PDF viewer for smooth rendering
- Automatic text extraction for TTS playback
- Page-by-page progress tracking
- File size validation (max 50MB)
- Error handling for corrupted or invalid PDFs

### 🎨 Reading Customization
- Adjustable font size (14-28pt)
- Warm, comfortable reading background
- Chapter-based navigation for longer books
- Progress indicators and completion tracking

### 👤 User Features
- User authentication and profiles
- Personalized book recommendations
- Reading history and achievements
- Parental dashboard for monitoring progress

## Getting Started

### Prerequisites
- Flutter SDK (>=3.1.0 <4.0.0)
- Firebase account for backend services
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

3. Configure Firebase:
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update Firebase configuration in `lib/firebase_options.dart`

4. Run the app:
```bash
flutter run
```

## PDF Upload Feature

### How to Upload a PDF Book

1. Open any book in the reading screen
2. Click the upload icon (📤) in the header
3. Select a PDF file from your device
4. The PDF will load with full navigation and TTS support

### PDF Requirements
- Format: PDF only
- Maximum size: 50MB
- Must contain readable text for TTS functionality

### PDF Features
- Page-by-page viewing with Syncfusion PDF Viewer
- Automatic text extraction for TTS
- Progress tracking across pages
- Same navigation controls as text books
- Font size settings (for text-based books only)

## Architecture

### Key Components
- **Book Provider**: Manages book data, including both text and PDF books
- **Reading Screen**: Unified interface for text and PDF reading
- **TTS Service**: Flutter TTS integration with text extraction for PDFs
- **Progress Tracking**: Session-based reading analytics

### Dependencies
- `flutter_tts`: Text-to-speech functionality
- `file_picker`: PDF file selection
- `syncfusion_flutter_pdfviewer`: PDF rendering
- `syncfusion_flutter_pdf`: PDF text extraction
- `firebase_core`, `firebase_auth`, `cloud_firestore`: Backend services
- `provider`: State management

## Development

### Project Structure
```
lib/
├── models/          # Data models (Book, Chapter, etc.)
├── providers/       # State management (BookProvider, UserProvider, etc.)
├── screens/         # UI screens
│   ├── book/       # Reading-related screens
│   ├── auth/       # Authentication screens
│   └── child/      # Child user screens
├── services/        # Backend services
└── widgets/         # Reusable UI components
```

### Adding New Features
1. Update models in `lib/models/` if needed
2. Modify providers in `lib/providers/` for state management
3. Create/update screens in `lib/screens/`
4. Add services in `lib/services/` for business logic

## Testing

Run tests with:
```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes with minimal modifications
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Syncfusion Flutter PDF](https://help.syncfusion.com/flutter/pdf/overview)
