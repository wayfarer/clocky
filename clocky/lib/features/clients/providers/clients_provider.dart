import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/client.dart';
import '../../../data/services/storage_service.dart';

final storageServiceProvider = Provider((ref) => StorageService());

class ClientsNotifier extends StateNotifier<List<Client>> {
  final StorageService _storage;

  ClientsNotifier(this._storage) : super([]) {
    _loadClients();
  }

  Future<void> _loadClients() async {
    final clients = await _storage.getClients();
    state = clients;
  }

  Future<void> addClient(Client client) async {
    await _storage.saveClient(client);
    state = [...state, client];
  }

  Future<void> updateClient(Client client) async {
    await _storage.saveClient(client);
    state = [
      for (final c in state)
        if (c.id == client.id) client else c
    ];
  }
}

final clientsProvider = StateNotifierProvider<ClientsNotifier, List<Client>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ClientsNotifier(storage);
});