# Platform Support

This document outlines Clocky's platform-specific implementations and feature availability.

## Feature Matrix

| Feature                | Desktop (Win/Mac/Linux) | Mobile (iOS/Android) | Web |
|-----------------------|-------------------------|---------------------|-----|
| Client Management     | ✅ Full                 | ✅ Full             | ✅ Full |
| Project Management    | ✅ Full                 | ✅ Full             | ✅ Full |
| Time Tracking         | ✅ Full                 | ✅ Full             | ✅ Full |
| Data Export          | ✅ Full                 | ⚠️ Planned          | ⚠️ Planned |
| File System Access    | ✅ Full                 | ⚠️ Limited          | ❌ N/A |
| Offline Support      | ✅ Full                 | ✅ Full             | ⚠️ Limited |

## Implementation Details

### Desktop Platforms

Desktop platforms have full access to native file system operations through the `dart:io` package. Key implementations:

```dart
// Example from FileService
if (Platform.isMacOS) {
  // macOS-specific file handling
} else if (Platform.isWindows) {
  // Windows-specific file handling
} else if (Platform.isLinux) {
  // Linux-specific file handling
}
```

#### Platform-Specific Features
- File system access for data export
- Native file dialogs
- System tray integration (planned)

### Mobile Platforms

Mobile platforms require special handling for file system access and platform-specific UI conventions.

#### iOS Implementation TODOs
- Implement share sheet for saving files
- Add Files app integration
- Handle proper file associations

#### Android Implementation TODOs
- Implement Storage Access Framework (SAF)
- Add proper file provider
- Handle scoped storage requirements

### Web Platform

Web platform has specific limitations and requirements:

#### Current Limitations
- No direct file system access
- Limited offline capabilities
- Browser-specific considerations

#### Planned Web Features
- Download API integration
- IndexedDB for offline support
- PWA capabilities

## Development Guidelines

### Platform Detection

Use the following pattern for platform-specific code:

```dart
if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
  // Desktop-specific code
} else if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
  // Mobile-specific code
} else {
  // Web-specific code
}
```

### File System Operations

1. **Desktop Platforms**
   - Use `dart:io` for direct file system access
   - Implement platform-specific file paths
   - Handle file permissions appropriately

2. **Mobile Platforms**
   - Use platform-specific APIs for file access
   - Implement proper file providers
   - Handle storage permissions

3. **Web Platform**
   - Use download API for file saving
   - Implement proper MIME types
   - Handle CORS and security restrictions

### UI Considerations

1. **Desktop**
   - Larger click targets
   - Hover states
   - Menu bars and keyboard shortcuts

2. **Mobile**
   - Touch-optimized interfaces
   - Platform-specific gestures
   - Responsive layouts

3. **Web**
   - Browser compatibility
   - Responsive design
   - Progressive enhancement

## Testing Requirements

Each platform requires specific testing considerations:

1. **Desktop**
   - Test on Windows, macOS, and Linux
   - Verify file system operations
   - Check platform-specific UI elements

2. **Mobile**
   - Test on iOS and Android
   - Verify permissions handling
   - Test touch interactions

3. **Web**
   - Test across major browsers
   - Verify offline functionality
   - Check responsive design

## Future Improvements

1. **Desktop**
   - [ ] System tray integration
   - [ ] Native file dialogs
   - [ ] Global keyboard shortcuts

2. **Mobile**
   - [ ] Share sheet integration
   - [ ] Mobile widgets
   - [ ] Platform-specific notifications

3. **Web**
   - [ ] PWA support
   - [ ] Improved offline capabilities
   - [ ] Browser extension integration