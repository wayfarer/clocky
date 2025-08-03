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
    @Default([]) List<DateTime> pausedAt,
    @Default([]) List<DateTime> resumedAt,
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
    Duration total = endTime?.difference(startTime) ?? DateTime.now().difference(startTime);
    
    // Subtract paused durations
    for (int i = 0; i < pausedAt.length; i++) {
      final pauseTime = pausedAt[i];
      final resumeTime = i < resumedAt.length ? resumedAt[i] : DateTime.now();
      total -= resumeTime.difference(pauseTime);
    }
    
    return total;
  }

  bool get isActive => endTime == null;
  
  bool get isPaused => pausedAt.length > resumedAt.length;

  TimeEntry pause() {
    if (isPaused || !isActive) return this;
    return copyWith(
      pausedAt: [...pausedAt, DateTime.now()],
    );
  }

  TimeEntry resume() {
    if (!isPaused || !isActive) return this;
    return copyWith(
      resumedAt: [...resumedAt, DateTime.now()],
    );
  }

  double calculateBillableAmount(double hourlyRate) {
    final hours = duration.inMinutes / 60.0;
    return isBillable ? hours * hourlyRate : 0;
  }

  factory TimeEntry.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryFromJson(json);
}