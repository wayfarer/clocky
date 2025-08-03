import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/project.dart';
import '../../../data/models/client.dart';
import '../../../data/models/time_entry.dart';
import '../../timer/providers/timer_provider.dart';
import '../../clients/providers/clients_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/project_progress_card.dart';
import '../widgets/recent_activity_list.dart';

class ProjectDashboardScreen extends ConsumerWidget {
  const ProjectDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    final clients = ref.watch(clientsProvider);
    final timeEntries = ref.watch(timerProvider).savedEntries;

    if (projects.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No projects yet'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _showAddProjectDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add Project'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddProjectDialog(context, ref),
          child: const Icon(Icons.add),
        ),
      );
    }

    // Group projects by status
    final activeProjects = projects.where((p) => p.isActive).toList();
    final inactiveProjects = projects.where((p) => !p.isActive).toList();

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    icon: Icons.folder,
                    title: 'Active Projects',
                    value: activeProjects.length.toString(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    icon: Icons.people,
                    title: 'Clients',
                    value: clients.length.toString(),
                  ),
                ),
              ],
            ),
          ),
          if (activeProjects.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Active Projects',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: activeProjects.length,
              itemBuilder: (context, index) {
                final project = activeProjects[index];
                final client = clients.firstWhere(
                  (c) => c.id == project.clientId,
                  orElse: () => Client.create(name: 'Unknown', hourlyRate: 0),
                );
                final projectEntries = timeEntries
                    .where((e) => e.projectId == project.id)
                    .toList();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ProjectProgressCard(
                    project: project,
                    client: client,
                    entries: projectEntries,
                    onTap: () => _showProjectDetails(context, project),
                  ),
                );
              },
            ),
          ],
          if (timeEntries.isNotEmpty) ...[
            RecentActivityList(
              entries: timeEntries,
              projects: projects,
              clients: clients,
            ),
          ],
          if (inactiveProjects.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: ExpansionTile(
                title: Text(
                  'Inactive Projects (${inactiveProjects.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                children: inactiveProjects.map((project) {
                  final client = clients.firstWhere(
                    (c) => c.id == project.clientId,
                    orElse: () => Client.create(name: 'Unknown', hourlyRate: 0),
                  );
                  final projectEntries = timeEntries
                      .where((e) => e.projectId == project.id)
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ProjectProgressCard(
                      project: project,
                      client: client,
                      entries: projectEntries,
                      onTap: () => _showProjectDetails(context, project),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProjectDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  void _showProjectDetails(BuildContext context, Project project) {
    // TODO: Implement project details screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Project details coming soon!'),
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context, WidgetRef ref) {
    // We'll keep using the existing project dialog for now
    // TODO: Create a new enhanced project dialog
  }
}