import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/project.dart';
import '../../../data/models/client.dart';
import '../providers/timer_provider.dart';
import '../../projects/providers/projects_provider.dart';
import '../../clients/providers/clients_provider.dart';

class RunningTimerIndicator extends ConsumerWidget {
  const RunningTimerIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final currentEntry = timerState.currentEntry;
    
    if (currentEntry == null) return const SizedBox.shrink();

    final projects = ref.watch(projectsProvider);
    final clients = ref.watch(clientsProvider);
    
    final project = projects.firstWhere(
      (p) => p.id == currentEntry.projectId,
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

    final duration = timerState.displayDuration ?? Duration.zero;
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentEntry.isPaused)
            const Icon(Icons.pause, size: 16)
          else
            const Icon(Icons.timer, size: 16),
          const SizedBox(width: 8),
          Text(
            '$hours:$minutes:$seconds',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 8),
          Text('• ${project.name}'),
        ],
      ),
    );
  }
}