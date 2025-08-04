import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/project.dart';
import '../../../data/models/client.dart';
import '../../../data/models/time_entry.dart';
import '../../timer/providers/timer_provider.dart';
import '../../clients/providers/clients_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/grouped_time_entries.dart';
import '../widgets/project_form_dialog.dart';

class ProjectDetailsScreen extends ConsumerWidget {
  final Project project;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(clientsProvider).firstWhere(
          (c) => c.id == project.clientId,
          orElse: () => Client.create(name: 'Unknown', hourlyRate: 0),
        );

    final timeEntries = ref.watch(timerProvider).savedEntries.where(
          (e) => e.projectId == project.id,
        ).toList();

    // Calculate project totals
    Duration totalDuration = Duration.zero;
    double totalEarnings = 0;

    for (final entry in timeEntries) {
      if (!entry.isBillable) continue;
      totalDuration += entry.duration;
      totalEarnings += entry.calculateBillableAmount(client.hourlyRate);
    }

    final hours = totalDuration.inHours;
    final minutes = (totalDuration.inMinutes % 60);

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ProjectFormDialog(
                  clients: ref.read(clientsProvider),
                  existingProject: project,
                  onSave: (clientId, name, description, budget) {
                    final updatedProject = project.copyWith(
                      clientId: clientId,
                      name: name,
                      description: description,
                      budget: budget,
                    );
                    ref.read(projectsProvider.notifier).updateProject(updatedProject);
                  },
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'toggle_status':
                  ref.read(projectsProvider.notifier).toggleProjectStatus(project);
                  break;
                case 'export':
                  // TODO: Implement data export
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle_status',
                child: Text(
                  project.isActive ? 'Mark as Inactive' : 'Mark as Active',
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Text('Export Data'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSummaryCard(
            context,
            client: client,
            totalHours: hours,
            totalMinutes: minutes,
            totalEarnings: totalEarnings,
          ),
          if (project.description?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                project.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          if (project.budget != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Budget Progress',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: totalEarnings / project.budget!,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${totalEarnings.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '\$${project.budget!.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          GroupedTimeEntries(
            entries: timeEntries,
            hourlyRate: client.hourlyRate,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Start timer for this project
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Timer'),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required Client client,
    required int totalHours,
    required int totalMinutes,
    required double totalEarnings,
  }) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rate: \$${client.hourlyRate}/hr',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: project.isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    project.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: project.isActive ? Colors.green[700] : Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Hours',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalHours:${totalMinutes.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Earnings',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalEarnings.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}