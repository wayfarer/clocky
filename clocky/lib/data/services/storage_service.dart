import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/client.dart';
import '../models/project.dart';
import '../models/time_entry.dart';

class StorageService {
  static const String _clientsKey = 'clients';
  static const String _projectsKey = 'projects';
  static const String _timeEntriesKey = 'time_entries';

  Future<void> saveClient(Client client) async {
    final prefs = await SharedPreferences.getInstance();
    final clients = await getClients();
    
    final index = clients.indexWhere((c) => c.id == client.id);
    if (index >= 0) {
      clients[index] = client;
    } else {
      clients.add(client);
    }
    
    await prefs.setString(
      _clientsKey,
      jsonEncode(clients.map((c) => c.toJson()).toList()),
    );
  }

  Future<List<Client>> getClients() async {
    final prefs = await SharedPreferences.getInstance();
    final clientsJson = prefs.getString(_clientsKey);
    
    if (clientsJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(clientsJson);
    return decoded.map((c) => Client.fromJson(c)).toList();
  }

  Future<void> saveProject(Project project) async {
    final prefs = await SharedPreferences.getInstance();
    final projects = await getProjects();
    
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index >= 0) {
      projects[index] = project;
    } else {
      projects.add(project);
    }
    
    await prefs.setString(
      _projectsKey,
      jsonEncode(projects.map((p) => p.toJson()).toList()),
    );
  }

  Future<List<Project>> getProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final projectsJson = prefs.getString(_projectsKey);
    
    if (projectsJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(projectsJson);
    return decoded.map((p) => Project.fromJson(p)).toList();
  }

  Future<List<Project>> getProjectsForClient(String clientId) async {
    final projects = await getProjects();
    return projects.where((p) => p.clientId == clientId).toList();
  }

  Future<void> saveTimeEntry(TimeEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getTimeEntries();
    
    final index = entries.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      entries[index] = entry;
    } else {
      entries.add(entry);
    }
    
    await prefs.setString(
      _timeEntriesKey,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }

  Future<List<TimeEntry>> getTimeEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_timeEntriesKey);
    
    if (entriesJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(entriesJson);
    return decoded.map((e) => TimeEntry.fromJson(e)).toList();
  }

  Future<List<TimeEntry>> getTimeEntriesForProject(String projectId) async {
    final entries = await getTimeEntries();
    return entries.where((e) => e.projectId == projectId).toList();
  }
}