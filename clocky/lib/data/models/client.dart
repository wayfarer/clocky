import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'client.freezed.dart';
part 'client.g.dart';

@freezed
class Client with _$Client {
  const Client._();

  const factory Client({
    required String id,
    required String name,
    String? email,
    required double hourlyRate,
    String? notes,
    required DateTime createdAt,
  }) = _Client;

  factory Client.create({
    required String name,
    String? email,
    required double hourlyRate,
    String? notes,
  }) {
    return Client(
      id: const Uuid().v4(),
      name: name,
      email: email,
      hourlyRate: hourlyRate,
      notes: notes,
      createdAt: DateTime.now(),
    );
  }

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
}