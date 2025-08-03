import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/project.dart';
import '../../../data/models/client.dart';
import '../providers/projects_provider.dart';
import '../../clients/providers/clients_provider.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    final clients = ref.watch(clientsProvider);

    if (clients.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Projects'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Add a client before creating projects'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  DefaultTabController.of(context).animateTo(1); // Switch to Clients tab
                },
                child: const Text('Add Client'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: projects.isEmpty
          ? const Center(
              child: Text('No projects yet. Add your first project!'),
            )
          : ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                final client = clients.firstWhere(
                  (c) => c.id == project.clientId,
                  orElse: () => Client.create(name: 'Unknown', hourlyRate: 0),
                );

                return ListTile(
                  title: Text(project.name),
                  subtitle: Text('Client: ${client.name}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (project.budget != null)
                        Text(
                          '\$${project.budget!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showProjectDialog(context, ref, project),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProjectDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showProjectDialog(
    BuildContext context,
    WidgetRef ref, [
    Project? existingProject,
  ]) async {
    final clients = ref.read(clientsProvider);
    String selectedClientId = existingProject?.clientId ?? clients.first.id;
    
    final nameController = TextEditingController(text: existingProject?.name);
    final descController = TextEditingController(
      text: existingProject?.description ?? '',
    );
    final budgetController = TextEditingController(
      text: existingProject?.budget?.toString() ?? '',
    );

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingProject == null ? 'Add Project' : 'Edit Project'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedClientId,
                items: clients.map((client) {
                  return DropdownMenuItem(
                    value: client.id,
                    child: Text(client.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedClientId = value;
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Client',
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  hintText: 'Enter project name',
                ),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter project description (optional)',
                ),
                maxLines: 3,
              ),
              TextField(
                controller: budgetController,
                decoration: const InputDecoration(
                  labelText: 'Budget',
                  hintText: 'Enter project budget (optional)',
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final description = descController.text.trim();
              final budget = double.tryParse(budgetController.text);

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a project name'),
                  ),
                );
                return;
              }

              final project = existingProject == null
                  ? Project.create(
                      clientId: selectedClientId,
                      name: name,
                      description: description.isEmpty ? null : description,
                      budget: budget,
                    )
                  : existingProject.copyWith(
                      clientId: selectedClientId,
                      name: name,
                      description: description.isEmpty ? null : description,
                      budget: budget,
                    );

              if (existingProject == null) {
                ref.read(projectsProvider.notifier).addProject(project);
              } else {
                ref.read(projectsProvider.notifier).updateProject(project);
              }

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}