import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/client.dart';
import '../providers/clients_provider.dart';

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
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showClientDialog(context, ref, client),
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