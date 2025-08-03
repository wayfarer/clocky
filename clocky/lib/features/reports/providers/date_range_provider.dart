import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateRange {
  final DateTime start;
  final DateTime end;
  final String label;

  const DateRange({
    required this.start,
    required this.end,
    required this.label,
  });

  bool includes(DateTime date) {
    return date.isAfter(start.subtract(const Duration(seconds: 1))) &&
           date.isBefore(end.add(const Duration(seconds: 1)));
  }

  static DateRange thisWeek() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeek = DateTime(start.year, start.month, start.day);
    final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    return DateRange(
      start: startOfWeek,
      end: endOfWeek,
      label: 'This Week',
    );
  }

  static DateRange thisMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return DateRange(
      start: start,
      end: end,
      label: 'This Month',
    );
  }

  static DateRange lastMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 1, 1);
    final end = DateTime(now.year, now.month, 0, 23, 59, 59);
    return DateRange(
      start: start,
      end: end,
      label: 'Last Month',
    );
  }

  static DateRange custom(DateTime start, DateTime end) {
    return DateRange(
      start: DateTime(start.year, start.month, start.day),
      end: DateTime(end.year, end.month, end.day, 23, 59, 59),
      label: 'Custom Range',
    );
  }

  static DateRange allTime() {
    return DateRange(
      start: DateTime(2000),
      end: DateTime.now(),
      label: 'All Time',
    );
  }
}

final dateRangeProvider = StateProvider<DateRange>((ref) => DateRange.thisMonth());

final presetRangesProvider = Provider<List<DateRange>>((ref) => [
  DateRange.thisWeek(),
  DateRange.thisMonth(),
  DateRange.lastMonth(),
  DateRange.allTime(),
]);