import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/project.dart';
import '../../../data/models/client.dart';

class StartTimerDialog extends ConsumerStatefulWidget {
  final List<Project> projects;
  final List<Client> clients;
  final Function(String projectId, String? description, bool isBillable) onStart;
  final String? initialProjectId;

  const StartTimerDialog({
    super.key,
    required this.projects,
    required this.clients,
    required this.onStart,
    this.initialProjectId,
  });

  @override
  ConsumerState<StartTimerDialog> createState() => _StartTimerDialogState();
}

class _StartTimerDialogState extends ConsumerState<StartTimerDialog> {
  late String? selectedProjectId;
  final descriptionController = TextEditingController();
  bool isBillable = true;

  @override
  void initState() {
    super.initState();
    selectedProjectId = widget.initialProjectId;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return AlertDialog(
      title: const Text('Start Timer'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text('Project'),
            ),
            DropdownButtonFormField<String>(
              value: selectedProjectId,
              items: widget.projects.map((project) {
                final client = widget.clients.firstWhere(
                  (c) => c.id == project.clientId,
                  orElse: () => Client.create(name: 'Unknown', hourlyRate: 0),
                );
                return DropdownMenuItem(
                  value: project.id,
                  child: Text('${client.name} - ${project.name}'),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedProjectId = value),
              decoration: const InputDecoration(
                hintText: 'Select project',
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text('Description'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'What are you working on?',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isBillable,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => isBillable = value);
                    }
                  },
                ),
                const Text('Billable'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: selectedProjectId == null
              ? null
              : () {
                  widget.onStart(
                    selectedProjectId!,
                    descriptionController.text.trim(),
                    isBillable,
                  );
                  Navigator.pop(context);
                },
          child: const Text('Start'),
        ),
      ],
    );
  }
}