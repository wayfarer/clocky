import 'package:flutter/material.dart';
import '../../../data/models/time_entry.dart';
import '../../../data/models/project.dart';
import '../../../data/models/client.dart';

class RecentActivityList extends StatelessWidget {
  final List<TimeEntry> entries;
  final List<Project> projects;
  final List<Client> clients;

  const RecentActivityList({
    super.key,
    required this.entries,
    required this.projects,
    required this.clients,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedEntries = List.of(entries)
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
    final recentEntries = sortedEntries.take(5).toList();

    if (recentEntries.isEmpty) {
      return Center(
        child: Text(
          'No recent activity',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Recent Activity',
            style: theme.textTheme.titleMedium,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentEntries.length,
          itemBuilder: (context, index) {
            final entry = recentEntries[index];
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

            final duration = entry.duration;
            final hours = duration.inHours;
            final minutes = (duration.inMinutes % 60);

            return ListTile(
              title: Text(project.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(client.name),
                  if (entry.description?.isNotEmpty ?? false)
                    Text(
                      entry.description!,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$hours:${minutes.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatDate(entry.startTime),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}