import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/time_entry.dart';
import '../../../data/models/project.dart';
import '../../../data/models/client.dart';
import '../../timer/providers/timer_provider.dart';
import '../../projects/providers/projects_provider.dart';
import '../../clients/providers/clients_provider.dart';
import '../providers/date_range_provider.dart';
import '../widgets/date_range_selector.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeEntries = ref.watch(timerProvider).savedEntries;
    final dateRange = ref.watch(dateRangeProvider);
    final projects = ref.watch(projectsProvider);
    final clients = ref.watch(clientsProvider);

    if (timeEntries.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No time entries yet to generate reports'),
        ),
      );
    }

    // Filter entries by date range
    final filteredEntries = timeEntries.where(
      (entry) => dateRange.includes(entry.startTime),
    ).toList();

    // Calculate totals for filtered entries
    double totalEarnings = 0;
    Duration totalDuration = Duration.zero;

    for (final entry in filteredEntries) {
      if (!entry.isBillable) continue;
      
      final project = projects.firstWhere(
        (p) => p.id == entry.projectId,
        orElse: () => Project.create(
          clientId: 'unknown',
          name: 'Unknown Project',
        ),
      );
      
      final client = clients.firstWhere(
        (c) => c.id == project.clientId,
        orElse: () => Client.create(
          name: 'Unknown Client',
          hourlyRate: 0,
        ),
      );

      totalDuration += entry.duration;
      totalEarnings += entry.calculateBillableAmount(client.hourlyRate);
    }

    final hours = totalDuration.inHours;
    final minutes = (totalDuration.inMinutes % 60);

    Widget content;
    if (filteredEntries.isEmpty) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DateRangeSelector(),
            const SizedBox(height: 32),
            Text(
              'No time entries for ${dateRange.label}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    } else {
      content = ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const DateRangeSelector(),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Total Hours',
                          value: '$hours:${minutes.toString().padLeft(2, '0')}',
                          icon: Icons.timer,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Total Earnings',
                          value: '\$${totalEarnings.toStringAsFixed(2)}',
                          icon: Icons.attach_money,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'By Client',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  for (final client in clients) ...[
                    _buildClientSummary(client, projects, filteredEntries),
                    if (client != clients.last) const Divider(),
                  ],
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: content,
    );
  }

  Widget _buildClientSummary(
    Client client,
    List<Project> projects,
    List<TimeEntry> allEntries,
  ) {
    final clientProjects = projects.where((p) => p.clientId == client.id).toList();
    Duration totalDuration = Duration.zero;
    double totalEarnings = 0;

    for (final project in clientProjects) {
      final projectEntries = allEntries.where((e) => e.projectId == project.id);
      for (final entry in projectEntries) {
        if (!entry.isBillable) continue;
        totalDuration += entry.duration;
        totalEarnings += entry.calculateBillableAmount(client.hourlyRate);
      }
    }

    final hours = totalDuration.inHours;
    final minutes = (totalDuration.inMinutes % 60);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${clientProjects.length} projects',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$hours:${minutes.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${totalEarnings.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
}