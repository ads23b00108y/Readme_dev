# PDF Reading Feature - UI Guide

## Access Points

### 1. From Library Screen
```
┌─────────────────────────────────────┐
│  Library                            │
│  ┌─────────────────────────────┐   │
│  │  [All Books] [Ongoing] ...  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌───────┐  ┌───────┐  ┌───────┐  │
│  │ Book  │  │ Book  │  │ Book  │  │
│  │  📖   │  │  📖   │  │  📖   │  │
│  └───────┘  └───────┘  └───────┘  │
│                                     │
│                   ┌──────────────┐  │
│                   │ 📄 Read PDF  │ ← Floating Action Button
│                   └──────────────┘  │
└─────────────────────────────────────┘
```

### 2. From Book Details Screen
```
┌─────────────────────────────────────┐
│  ← The Great Adventure              │
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │        Book Cover           │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Description: Once upon a time...  │
│                                     │
│  ┌──────────┐  ┌──────────────┐   │
│  │ 📄 PDF   │  │ ▶ Start      │   │ ← PDF Button
│  └──────────┘  │   Reading    │   │
│                └──────────────┘   │
└─────────────────────────────────────┘
```

## PDF Reading Screen

### Main Reading View
```
┌─────────────────────────────────────┐
│  ← My Document           📑 🔖 ⚙️   │ ← Back, TOC*, Bookmark, Settings
│  by Author Name                     │
│                                     │
│  Page 5 of 120        42% complete │
│  ████████░░░░░░░░░░░░░░░░░         │ ← Progress Bar
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │                             │   │
│  │     PDF Page Content        │   │ ← PDF Viewer
│  │                             │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│   ◀        ⏯️ Play/Pause      ▶   │ ← Navigation
└─────────────────────────────────────┘

* TOC button only appears if PDF has table of contents
```

### Table of Contents View
```
┌─────────────────────────────────────┐
│  ← Table of Contents                │
├─────────────────────────────────────┤
│                                     │
│  🔖 Chapter 1: Introduction      ▶  │
│  🔖 Chapter 2: Getting Started   ▶  │
│  🔖 Chapter 3: Advanced Topics   ▶  │
│  🔖 Chapter 4: Conclusion        ▶  │
│  ...                                │
│                                     │
└─────────────────────────────────────┘
```

### Settings Panel
```
┌─────────────────────────────────────┐
│         Reading Settings            │
├─────────────────────────────────────┤
│                                     │
│  TTS Speed:  ◄─────●─────►  1.0x   │
│              0.5x       2.0x        │
│                                     │
│  ────────────────────────────────   │
│                                     │
│  Bookmarks                          │
│  🔖 Page 15 - 2024-01-15 10:30     │
│  🔖 Page 42 - 2024-01-15 11:15     │
│  🔖 Page 87 - 2024-01-15 14:20     │
│                                     │
│          [Close]                    │
└─────────────────────────────────────┘
```

## User Interactions

### Reading Flow
```
1. Select PDF
   ↓
2. PDF loads → First page displayed
   ↓
3. User can:
   - Play TTS (reads current page)
   - Navigate pages (← →)
   - Add bookmark (🔖)
   - Access TOC (📑) if available
   - Adjust settings (⚙️)
   ↓
4. Progress automatically saved
   ↓
5. Complete reading → Completion dialog
```

### TTS Flow
```
User clicks Play
   ↓
Text extracted from current page
   ↓
TTS begins reading
   ↓
User can:
   - Pause/Resume
   - Adjust speed in settings
   - Navigate to different page (auto-stops TTS)
```

### Chapter Navigation Flow
```
User clicks TOC button (📑)
   ↓
TOC view opens
   ↓
User selects chapter
   ↓
PDF jumps to chapter page
   ↓
TOC closes, reading continues
```

## Icons Legend

- 📄 PDF file
- 📑 Table of Contents / Menu
- 🔖 Bookmark
- ⚙️ Settings
- ▶ Play / Start
- ⏸️ Pause
- ◀ Previous
- ▶ Next
- ← Back
- ✓ Complete

## Color Scheme

- Primary: Purple (#8E44AD)
- Background: Cream (#FFFDF7)
- Progress: Purple gradient
- Buttons: Purple with white text
- Text: Dark gray (#333)
