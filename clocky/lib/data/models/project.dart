import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  const Project._();

  const factory Project({
    required String id,
    required String clientId,
    required String name,
    String? description,
    double? budget,
    required DateTime createdAt,
    @Default(true) bool isActive,
  }) = _Project;

  factory Project.create({
    required String clientId,
    required String name,
    String? description,
    double? budget,
  }) {
    return Project(
      id: const Uuid().v4(),
      clientId: clientId,
      name: name,
      description: description,
      budget: budget,
      createdAt: DateTime.now(),
    );
  }

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}