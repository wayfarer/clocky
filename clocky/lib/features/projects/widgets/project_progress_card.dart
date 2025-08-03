import 'package:flutter/material.dart';
import '../../../data/models/project.dart';
import '../../../data/models/client.dart';
import '../../../data/models/time_entry.dart';

class ProjectProgressCard extends StatelessWidget {
  final Project project;
  final Client client;
  final List<TimeEntry> entries;
  final VoidCallback onTap;

  const ProjectProgressCard({
    super.key,
    required this.project,
    required this.client,
    required this.entries,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Calculate total hours and earnings
    Duration totalDuration = Duration.zero;
    double totalEarnings = 0;

    for (final entry in entries) {
      if (!entry.isBillable) continue;
      totalDuration += entry.duration;
      totalEarnings += entry.calculateBillableAmount(client.hourlyRate);
    }

    final hours = totalDuration.inHours;
    final minutes = (totalDuration.inMinutes % 60);

    // Calculate budget progress
    double? progressPercent;
    if (project.budget != null && project.budget! > 0) {
      progressPercent = (totalEarnings / project.budget! * 100).clamp(0, 100);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          client.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
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
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (project.description?.isNotEmpty ?? false) ...[
                const SizedBox(height: 8),
                Text(
                  project.description!,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (progressPercent != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressPercent / 100,
                          backgroundColor: theme.colorScheme.surfaceVariant,
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${progressPercent.toStringAsFixed(1)}%',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Budget: \$${project.budget!.toStringAsFixed(2)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}