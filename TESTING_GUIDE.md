# 🧪 Testing Guide for PDF Feature

## Quick Start

### Prerequisites
1. Flutter environment set up
2. Android/iOS device or emulator
3. Sample PDF files for testing
4. ReadMe app built and running

### Installation
```bash
# Navigate to project directory
cd /home/runner/work/Readme_dev/Readme_dev

# Install dependencies
flutter pub get

# Build the app
flutter build apk  # For Android
# OR
flutter build ios  # For iOS

# Run on device
flutter run
```

## 📱 Manual Testing Checklist

### Phase 1: Basic Functionality

#### Test 1.1: Upload Small PDF
- [ ] Open any book in the reading screen
- [ ] Click the upload button (📤) in the header
- [ ] Select a small PDF (< 5MB)
- [ ] Verify PDF loads successfully
- [ ] Verify success message appears
- [ ] Check that PDF displays correctly

**Expected**: PDF loads within 1-2 seconds, displays clearly

#### Test 1.2: View PDF Pages
- [ ] Swipe right to go to next page
- [ ] Swipe left to go to previous page
- [ ] Use Next button to navigate forward
- [ ] Use Previous button to navigate backward
- [ ] Check page number updates correctly
- [ ] Verify progress bar updates

**Expected**: Smooth navigation, accurate page tracking

#### Test 1.3: Text-to-Speech
- [ ] Click the Play button
- [ ] Verify text is being spoken
- [ ] Check that TTS uses extracted text from current page
- [ ] Pause and resume playback
- [ ] Navigate to different page while playing
- [ ] Verify TTS stops/restarts appropriately

**Expected**: Clear speech, accurate text reading

#### Test 1.4: Progress Tracking
- [ ] Navigate to page 3 of PDF
- [ ] Close the reading screen
- [ ] Reopen the same book
- [ ] Verify it resumes from page 3
- [ ] Check progress percentage is accurate

**Expected**: Progress persists across sessions

### Phase 2: Error Handling

#### Test 2.1: File Size Limit
- [ ] Try to upload a PDF > 50MB
- [ ] Verify error message appears
- [ ] Check error message mentions size limit
- [ ] Verify app doesn't crash
- [ ] Confirm user can try again

**Expected**: Clear error message, graceful handling

#### Test 2.2: Invalid File Format
- [ ] Try to upload a non-PDF file (e.g., .txt, .doc)
- [ ] Verify file picker filters to PDF only
- [ ] If user bypasses filter, verify error handling
- [ ] Confirm app remains stable

**Expected**: Only PDFs selectable, or clear error if not

#### Test 2.3: Corrupted PDF
- [ ] Upload a corrupted/invalid PDF file
- [ ] Verify error message appears
- [ ] Check "Try Another PDF" button works
- [ ] Confirm app doesn't crash

**Expected**: Clear error, recovery option available

#### Test 2.4: No Text Extraction
- [ ] Upload a scanned PDF (image-only, no text layer)
- [ ] Verify PDF displays
- [ ] Click TTS button
- [ ] Check appropriate message for no text
- [ ] Confirm navigation still works

**Expected**: PDF displays, TTS disabled with explanation

### Phase 3: Backward Compatibility

#### Test 3.1: Text Book Reading
- [ ] Open a regular text-based book
- [ ] Verify it displays correctly
- [ ] Check font size adjustment works
- [ ] Verify TTS works
- [ ] Test navigation (next/previous)
- [ ] Verify progress tracking

**Expected**: All text book features work unchanged

#### Test 3.2: Chapter-Based Books
- [ ] Open a book with chapters
- [ ] Verify chapter navigation works
- [ ] Check chapter information displays
- [ ] Test progress tracking per chapter
- [ ] Verify TTS reads chapter content

**Expected**: Chapter features work as before

#### Test 3.3: Switch Between Modes
- [ ] Open text book
- [ ] Upload PDF from text book screen
- [ ] Switch to reading PDF
- [ ] Go back and open another text book
- [ ] Verify both modes work correctly

**Expected**: Seamless switching, no conflicts

### Phase 4: Performance Testing

#### Test 4.1: Large PDF Performance
- [ ] Upload a large PDF (40-50MB)
- [ ] Measure loading time
- [ ] Check memory usage
- [ ] Navigate through pages
- [ ] Verify app remains responsive

**Expected**: < 5 second load, smooth navigation

#### Test 4.2: Multiple Sessions
- [ ] Upload and read PDF
- [ ] Close app completely
- [ ] Reopen app
- [ ] Open same PDF
- [ ] Verify progress restored
- [ ] Check no memory issues

**Expected**: Consistent performance, no leaks

#### Test 4.3: Long Reading Session
- [ ] Read PDF for 10+ minutes
- [ ] Navigate through 20+ pages
- [ ] Use TTS multiple times
- [ ] Monitor app performance
- [ ] Check battery usage

**Expected**: Stable performance, reasonable battery use

### Phase 5: Edge Cases

#### Test 5.1: Empty PDF
- [ ] Upload a PDF with 0 pages (if possible)
- [ ] Verify error handling
- [ ] Check user feedback

**Expected**: Clear error message

#### Test 5.2: Single Page PDF
- [ ] Upload a 1-page PDF
- [ ] Verify displays correctly
- [ ] Check navigation buttons disabled/enabled appropriately
- [ ] Test TTS on single page
- [ ] Complete the "book"

**Expected**: Proper handling of single page

#### Test 5.3: Very Long PDF
- [ ] Upload 100+ page PDF
- [ ] Navigate to middle pages
- [ ] Check performance
- [ ] Verify progress tracking
- [ ] Test completion at end

**Expected**: Handles long documents well

#### Test 5.4: Special Characters
- [ ] Upload PDF with unicode/special characters
- [ ] Verify text extraction works
- [ ] Check TTS pronunciation
- [ ] Verify display is correct

**Expected**: Proper handling of special characters

#### Test 5.5: Landscape PDFs
- [ ] Upload landscape-oriented PDF
- [ ] Check display orientation
- [ ] Verify navigation works
- [ ] Test on different screen sizes

**Expected**: Proper orientation handling

## 🐛 Bug Reporting Template

If you find any issues, please report using this format:

```
### Issue Title
[Brief description of the issue]

### Steps to Reproduce
1. [First step]
2. [Second step]
3. [...]

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens]

### Environment
- Device: [e.g., Pixel 6, iPhone 13]
- OS Version: [e.g., Android 13, iOS 16]
- App Version: [version number]
- PDF File: [size, type, source]

### Screenshots/Logs
[Attach if available]

### Severity
- [ ] Critical (app crashes)
- [ ] High (feature broken)
- [ ] Medium (inconvenience)
- [ ] Low (minor issue)
```

## 📊 Test Results Template

Use this to track your testing progress:

```
### Test Session Report

Date: [Date]
Tester: [Name]
Environment: [Device/OS]

#### Tests Passed: X/35
#### Tests Failed: X/35
#### Tests Blocked: X/35

#### Critical Issues Found: X
#### High Priority Issues: X
#### Medium Priority Issues: X
#### Low Priority Issues: X

#### Summary
[Brief summary of testing session]

#### Recommendations
[Any suggestions for improvements]
```

## 🎯 Success Criteria

### Minimum Acceptance Criteria
- [ ] All Phase 1 tests pass (basic functionality)
- [ ] No critical bugs in Phase 2 (error handling)
- [ ] Phase 3 shows full backward compatibility
- [ ] Performance is acceptable in Phase 4
- [ ] Major edge cases handled in Phase 5

### Full Acceptance Criteria
- [ ] 95%+ of all tests pass
- [ ] No critical or high priority bugs
- [ ] Performance meets expectations
- [ ] User experience is smooth
- [ ] Documentation is accurate

## 🔧 Debugging Tips

### Common Issues and Solutions

#### Issue: PDF won't load
**Check**:
- File size (must be < 50MB)
- File format (must be .pdf)
- File permissions
- Available storage space

**Solution**: Try smaller PDF or check file integrity

#### Issue: No text extracted for TTS
**Check**:
- Is it a scanned PDF?
- Does it have a text layer?
- Is text selectable in other PDF viewers?

**Solution**: Use PDFs with text layer, or note limitation

#### Issue: App crashes on upload
**Check**:
- Device memory available
- PDF file integrity
- Console logs for errors

**Solution**: Check logs, try different PDF

#### Issue: Progress not saving
**Check**:
- User authentication
- Firestore connectivity
- Console for database errors

**Solution**: Verify Firebase connection

### Viewing Logs

#### Android
```bash
flutter logs
# OR
adb logcat | grep flutter
```

#### iOS
```bash
flutter logs
# OR
Open Xcode console
```

## 📈 Performance Benchmarks

### Expected Performance Metrics

| Operation | Target | Acceptable | Unacceptable |
|-----------|--------|------------|--------------|
| Small PDF load (< 5MB) | < 1s | < 2s | > 3s |
| Medium PDF load (10-30MB) | < 2s | < 4s | > 5s |
| Large PDF load (40-50MB) | < 4s | < 6s | > 8s |
| Page navigation | < 500ms | < 1s | > 2s |
| Text extraction | < 1s | < 2s | > 3s |
| TTS start | < 1s | < 2s | > 3s |

### Memory Usage Targets

| Scenario | Target | Acceptable | Unacceptable |
|----------|--------|------------|--------------|
| Base app | 50MB | 75MB | > 100MB |
| + Small PDF | +5MB | +10MB | > +20MB |
| + Medium PDF | +20MB | +35MB | > +50MB |
| + Large PDF | +45MB | +55MB | > +75MB |

## 🎓 Additional Resources

### Sample PDFs for Testing
- Small: Alice in Wonderland (< 1MB)
- Medium: Technical manual (10-20MB)
- Large: Comprehensive textbook (40-50MB)
- Scanned: Old document scan (no text layer)
- Special: Math/scientific notation PDF

### Tools
- PDF readers for comparison
- Memory profilers
- Performance monitoring tools
- Screen recording software

## ✅ Final Checklist

Before marking testing as complete:

- [ ] All test phases completed
- [ ] Test results documented
- [ ] Bugs reported (if any)
- [ ] Performance meets targets
- [ ] Documentation reviewed for accuracy
- [ ] Screenshots/recordings captured
- [ ] Recommendations provided
- [ ] Sign-off given (or issues logged)

---

**Testing Status**: ⏳ Pending  
**Last Updated**: 2024  
**Next Review**: After manual testing

Happy Testing! 🧪📚
