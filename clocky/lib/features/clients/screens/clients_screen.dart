import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/client.dart';
import '../../../data/services/export_service.dart';
import '../../../data/providers/file_service_provider.dart';
import '../providers/clients_provider.dart';
import '../../projects/providers/projects_provider.dart';
import '../../timer/providers/timer_provider.dart';
import '../widgets/client_export_dialog.dart';

class ClientsScreen extends ConsumerWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
      ),
      body: clients.isEmpty
          ? const Center(
              child: Text('No clients yet. Add your first client!'),
            )
          : ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                return ListTile(
                  title: Text(client.name),
                  subtitle: Text('Rate: \$${client.hourlyRate}/hr'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () => _showExportDialog(context, ref, client),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showClientDialog(context, ref, client),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showClientDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showExportDialog(BuildContext context, WidgetRef ref, Client client) async {
    showDialog(
      context: context,
      builder: (context) => ClientExportDialog(
        client: client,
        onExport: (startDate, endDate) async {
          final exportService = ExportService();
          final projects = ref.read(projectsProvider);
          final timeEntries = ref.read(timerProvider).savedEntries;

          final csv = exportService.generateClientCsv(
            client: client,
            projects: projects,
            entries: timeEntries,
            startDate: startDate,
            endDate: endDate,
          );

          final fileService = ref.read(fileServiceProvider);
          final fileName = 'clocky_${client.name.toLowerCase().replaceAll(' ', '_')}_'
              '${startDate.year}${startDate.month.toString().padLeft(2, '0')}.csv';
          
          final filePath = await fileService.saveFile(
            fileName: fileName,
            content: csv,
          );

          if (!context.mounted) return;

          if (filePath != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('File exported successfully'),
                action: SnackBarAction(
                  label: 'Show File',
                  onPressed: () {
                    fileService.showFileInExplorer(filePath).then((success) {
                      if (!success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not open file location'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    });
                  },
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to export file'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _showClientDialog(
    BuildContext context,
    WidgetRef ref, [
    Client? existingClient,
  ]) async {
    final nameController = TextEditingController(text: existingClient?.name);
    final emailController = TextEditingController(text: existingClient?.email);
    final rateController = TextEditingController(
      text: existingClient?.hourlyRate.toString() ?? '',
    );
    final notesController = TextEditingController(text: existingClient?.notes);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingClient == null ? 'Add Client' : 'Edit Client'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('Name'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter client name',
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('Email'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter client email (optional)',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('Hourly Rate'),
              ),
              TextField(
                controller: rateController,
                decoration: const InputDecoration(
                  hintText: 'Enter hourly rate',
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('Notes'),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  hintText: 'Enter notes (optional)',
                ),
                maxLines: 3,
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
              final email = emailController.text.trim();
              final rate = double.tryParse(rateController.text) ?? 0;
              final notes = notesController.text.trim();

              if (name.isEmpty || rate <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a name and valid hourly rate'),
                  ),
                );
                return;
              }

              final client = existingClient == null
                  ? Client.create(
                      name: name,
                      email: email.isEmpty ? null : email,
                      hourlyRate: rate,
                      notes: notes.isEmpty ? null : notes,
                    )
                  : existingClient.copyWith(
                      name: name,
                      email: email.isEmpty ? null : email,
                      hourlyRate: rate,
                      notes: notes.isEmpty ? null : notes,
                    );

              if (existingClient == null) {
                ref.read(clientsProvider.notifier).addClient(client);
              } else {
                ref.read(clientsProvider.notifier).updateClient(client);
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