import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/file_service.dart';

final fileServiceProvider = Provider<FileService>((ref) => FileService());