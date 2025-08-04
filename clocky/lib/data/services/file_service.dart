import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  /// Saves data to a file on desktop platforms.
  /// 
  /// Returns the path to the saved file if successful, null if failed or unsupported platform.
  /// 
  /// TODO: Implement mobile file saving:
  /// - iOS: Use share sheet or files app
  /// - Android: Use SAF (Storage Access Framework)
  /// 
  /// TODO: Implement web file saving:
  /// - Use download API
  /// - Handle CORS and security restrictions
  
  /// Sanitizes a filename by removing or replacing invalid characters
  String sanitizeFileName(String fileName) {
    // Replace invalid characters with underscores
    final sanitized = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
    // Remove any multiple underscores
    return sanitized.replaceAll(RegExp(r'_+'), '_');
  }

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
    
    // TODO: Handle other platforms
    return null;
  }

  /// Shows the file in the system file explorer (Finder on macOS, Explorer on Windows).
  /// Returns true if successful, false otherwise.
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
}