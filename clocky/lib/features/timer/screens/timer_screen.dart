import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/project.dart';
import '../../../data/models/client.dart';
import '../../../data/models/time_entry.dart';
import '../providers/timer_provider.dart';
import '../../projects/providers/projects_provider.dart';
import '../../clients/providers/clients_provider.dart';

final selectedProjectProvider = StateProvider<String?>((ref) => null);

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final projects = ref.watch(projectsProvider);
    final clients = ref.watch(clientsProvider);

    if (projects.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Timer'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Create a project to start tracking time'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  DefaultTabController.of(context).animateTo(0); // Switch to Projects tab
                },
                child: const Text('Create Project'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: Column(
        children: [
          _buildTimerSection(context, ref, timerState),
          const Divider(height: 32),
          Expanded(
            child: _buildTimeEntriesList(timerState.savedEntries, projects, clients),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection(
    BuildContext context,
    WidgetRef ref,
    TimerState timerState,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimerDisplay(timerState.displayDuration),
          const SizedBox(height: 20),
          _buildControls(ref, timerState.isRunning),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay(Duration? duration) {
    final hours = ((duration?.inHours ?? 0)).toString().padLeft(2, '0');
    final minutes = ((duration?.inMinutes ?? 0) % 60).toString().padLeft(2, '0');
    final seconds = ((duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0');

    return Text(
      '$hours:$minutes:$seconds',
      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildControls(WidgetRef ref, bool isRunning) {
    final projects = ref.watch(projectsProvider);
    final clients = ref.watch(clientsProvider);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isRunning) ...[
          DropdownButtonFormField<String>(
            items: projects.map((project) {
              final client = clients.firstWhere(
                (c) => c.id == project.clientId,
                orElse: () => Client.create(name: 'Unknown', hourlyRate: 0),
              );
              return DropdownMenuItem(
                value: project.id,
                child: Text('${client.name} - ${project.name}'),
              );
            }).toList(),
            onChanged: (value) {
              ref.read(selectedProjectProvider.notifier).state = value;
            },
            decoration: const InputDecoration(
              labelText: 'Select Project',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isRunning
                  ? null
                  : () {
                      final projectId = ref.read(selectedProjectProvider);
                      if (projectId == null) {
                        ScaffoldMessenger.of(ref.context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a project first'),
                          ),
                        );
                        return;
                      }
                      
                      ref.read(timerProvider.notifier).startTimer(
                            projectId: projectId,
                          );
                    },
              child: const Text('Start'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: isRunning
                  ? () => ref.read(timerProvider.notifier).stopTimer()
                  : null,
              child: const Text('Stop'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeEntriesList(
    List<TimeEntry> entries,
    List<Project> projects,
    List<Client> clients,
  ) {
    if (entries.isEmpty) {
      return const Center(
        child: Text('No time entries yet'),
      );
    }

    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[entries.length - 1 - index]; // Show newest first
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
          subtitle: Text(client.name),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${hours}h ${minutes}m',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (entry.isBillable)
                Text(
                  '\$${((hours + minutes / 60.0) * client.hourlyRate).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}