import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/project.dart';
import '../../../data/services/storage_service.dart';
import '../../clients/providers/clients_provider.dart';

class ProjectsNotifier extends StateNotifier<List<Project>> {
  final StorageService _storage;

  ProjectsNotifier(this._storage) : super([]) {
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final projects = await _storage.getProjects();
    state = projects;
  }

  Future<void> addProject(Project project) async {
    await _storage.saveProject(project);
    state = [...state, project];
  }

  Future<void> updateProject(Project project) async {
    await _storage.saveProject(project);
    state = [
      for (final p in state)
        if (p.id == project.id) project else p
    ];
  }

  List<Project> getProjectsForClient(String clientId) {
    return state.where((p) => p.clientId == clientId).toList();
  }
}

final projectsProvider = StateNotifierProvider<ProjectsNotifier, List<Project>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ProjectsNotifier(storage);
});