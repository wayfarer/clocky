import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Handles file system operations with platform-specific implementations.
/// 
/// Current platform support:
/// - Desktop (Windows, macOS, Linux): Full support for saving and opening files
/// - Mobile (iOS, Android): Not yet implemented
/// - Web: Not yet implemented
/// 
/// Usage:
/// ```dart
/// final fileService = FileService();
/// final filePath = await fileService.saveFile(
///   fileName: 'example.csv',
///   content: 'Hello, World!',
/// );
/// if (filePath != null) {
///   await fileService.showFileInExplorer(filePath);
/// }
/// ```
class FileService {
  /// Saves data to a file on desktop platforms.
  /// 
  /// Returns the path to the saved file if successful, null if failed or unsupported platform.
  /// 
  /// Platform-specific behavior:
  /// - Windows: Saves to user's Downloads folder
  /// - macOS: Saves to app's sandboxed Downloads directory
  /// - Linux: Saves to user's Downloads folder
  /// - Mobile/Web: Returns null (not implemented)
  /// 
  /// TODO: Implement mobile file saving:
  /// - iOS: 
  ///   - Use share sheet for saving files
  ///   - Implement file provider for Files app integration
  ///   - Handle proper file associations
  /// 
  /// - Android:
  ///   - Use Storage Access Framework (SAF)
  ///   - Implement proper file provider
  ///   - Handle scoped storage requirements
  /// 
  /// TODO: Implement web file saving:
  /// - Use download API with proper MIME types
  /// - Handle CORS and security restrictions
  /// - Implement proper file naming
  Future<String?> saveFile({
    required String fileName,
    required String content,
    String? directory,
  }) async {
    if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      try {
        Directory targetDir;
        if (directory != null) {
          targetDir = Directory(directory);
        } else {
          if (Platform.isMacOS) {
            // On macOS, use the app's Downloads directory in the sandbox
            final appDocDir = await getApplicationDocumentsDirectory();
            targetDir = Directory('${appDocDir.path}/Downloads');
          } else {
            // On other platforms, use the system Downloads directory
            final homeDir = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
            if (homeDir == null) return null;
            targetDir = Directory('$homeDir/Downloads');
          }
        }
        
        if (!targetDir.existsSync()) {
          targetDir.createSync(recursive: true);
        }

        // Sanitize the filename
        final sanitizedFileName = sanitizeFileName(fileName);

        // Ensure unique filename
        String uniqueFileName = sanitizedFileName;
        int counter = 1;
        while (File('${targetDir.path}/$uniqueFileName').existsSync()) {
          final parts = sanitizedFileName.split('.');
          if (parts.length > 1) {
            uniqueFileName = '${parts.first}_$counter.${parts.last}';
          } else {
            uniqueFileName = '${sanitizedFileName}_$counter';
          }
          counter++;
        }

        final file = File('${targetDir.path}/$uniqueFileName');
        await file.writeAsString(content);
        return file.path;
      } catch (e) {
        debugPrint('Error saving file: $e');
        return null;
      }
    }
    
    // Not supported on mobile/web yet
    return null;
  }

  /// Shows the file in the system file explorer.
  /// 
  /// Platform-specific behavior:
  /// - macOS: Opens Finder and selects the file
  /// - Windows: Opens Explorer and selects the file
  /// - Linux: Opens the parent directory
  /// - Mobile/Web: Returns false (not implemented)
  /// 
  /// Returns true if successful, false otherwise.
  /// 
  /// TODO: Implement mobile file opening:
  /// - iOS: Use UIDocumentInteractionController
  /// - Android: Use Intent.ACTION_VIEW
  /// 
  /// TODO: Implement web file opening:
  /// - Not applicable (files are downloaded directly)
  Future<bool> showFileInExplorer(String filePath) async {
    try {
      if (Platform.isMacOS) {
        // On macOS, use the "open" command to reveal in Finder
        return await Process.run('open', ['-R', filePath])
            .then((result) => result.exitCode == 0);
      } else if (Platform.isWindows) {
        // On Windows, use Explorer's "select" command
        return await Process.run('explorer.exe', ['/select,', filePath])
            .then((result) => result.exitCode == 0);
      } else if (Platform.isLinux) {
        // On Linux, try to use xdg-open on the parent directory
        final dir = Directory(filePath).parent.path;
        return await Process.run('xdg-open', [dir])
            .then((result) => result.exitCode == 0);
      }
    } catch (e) {
      debugPrint('Error showing file: $e');
    }
    return false;
  }

  /// Sanitizes a filename by removing or replacing invalid characters.
  /// 
  /// This ensures the filename is valid across all supported platforms.
  String sanitizeFileName(String fileName) {
    // Replace invalid characters with underscores
    final sanitized = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
    // Remove any multiple underscores
    return sanitized.replaceAll(RegExp(r'_+'), '_');
  }
}