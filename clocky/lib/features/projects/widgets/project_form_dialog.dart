import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/project.dart';
import '../../../data/models/client.dart';

class ProjectFormDialog extends ConsumerStatefulWidget {
  final List<Client> clients;
  final Project? existingProject;
  final Function(String clientId, String name, String? description, double? budget) onSave;

  const ProjectFormDialog({
    super.key,
    required this.clients,
    required this.onSave,
    this.existingProject,
  });

  @override
  ConsumerState<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends ConsumerState<ProjectFormDialog> {
  late String selectedClientId;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController budgetController;

  @override
  void initState() {
    super.initState();
    selectedClientId = widget.existingProject?.clientId ?? widget.clients.first.id;
    nameController = TextEditingController(text: widget.existingProject?.name);
    descriptionController = TextEditingController(text: widget.existingProject?.description);
    budgetController = TextEditingController(
      text: widget.existingProject?.budget?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(widget.existingProject == null ? 'Create Project' : 'Edit Project'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text('Client'),
            ),
            DropdownButtonFormField<String>(
              value: selectedClientId,
              items: widget.clients.map((client) {
                return DropdownMenuItem(
                  value: client.id,
                  child: Text(client.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedClientId = value);
                }
              },
              decoration: const InputDecoration(
                hintText: 'Select client',
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text('Project Name'),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter project name',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text('Description'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter project description (optional)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text('Budget'),
            ),
            TextField(
              controller: budgetController,
              decoration: const InputDecoration(
                hintText: 'Enter project budget (optional)',
                prefixText: '\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            if (widget.existingProject != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    widget.existingProject!.isActive
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: widget.existingProject!.isActive
                        ? Colors.green[700]
                        : theme.disabledColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.existingProject!.isActive ? 'Active' : 'Inactive',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    ' (use menu to change)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a project name'),
                ),
              );
              return;
            }

            final budget = double.tryParse(budgetController.text);
            final description = descriptionController.text.trim();

            widget.onSave(
              selectedClientId,
              name,
              description.isNotEmpty ? description : null,
              budget,
            );
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}