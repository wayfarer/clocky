import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'time_entry.freezed.dart';
part 'time_entry.g.dart';

@freezed
class TimeEntry with _$TimeEntry {
  const TimeEntry._();

  const factory TimeEntry({
    required String id,
    required String projectId,
    required DateTime startTime,
    DateTime? endTime,
    String? description,
    @Default(true) bool isBillable,
  }) = _TimeEntry;

  factory TimeEntry.create({
    required String projectId,
    String? description,
    bool isBillable = true,
  }) {
    return TimeEntry(
      id: const Uuid().v4(),
      projectId: projectId,
      startTime: DateTime.now(),
      description: description,
      isBillable: isBillable,
    );
  }

  Duration get duration {
    return endTime?.difference(startTime) ?? DateTime.now().difference(startTime);
  }

  bool get isActive => endTime == null;

  double calculateBillableAmount(double hourlyRate) {
    final hours = duration.inMinutes / 60.0;
    return isBillable ? hours * hourlyRate : 0;
  }

  factory TimeEntry.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryFromJson(json);
}