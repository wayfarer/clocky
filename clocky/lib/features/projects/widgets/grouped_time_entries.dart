import 'package:flutter/material.dart';
import '../../../data/models/time_entry.dart';

class GroupedTimeEntries extends StatelessWidget {
  final List<TimeEntry> entries;
  final double hourlyRate;

  const GroupedTimeEntries({
    super.key,
    required this.entries,
    required this.hourlyRate,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(
        child: Text('No time entries yet'),
      );
    }

    // Sort entries by date, newest first
    final sortedEntries = List<TimeEntry>.from(entries)
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    // Group entries by date
    final groupedEntries = <DateTime, List<TimeEntry>>{};
    for (final entry in sortedEntries) {
      final date = DateTime(
        entry.startTime.year,
        entry.startTime.month,
        entry.startTime.day,
      );
      groupedEntries.putIfAbsent(date, () => []).add(entry);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedEntries.length,
      itemBuilder: (context, index) {
        final date = groupedEntries.keys.elementAt(index);
        final dayEntries = groupedEntries[date]!;
        
        // Calculate day totals
        Duration totalDuration = Duration.zero;
        double totalEarnings = 0;
        
        for (final entry in dayEntries) {
          if (!entry.isBillable) continue;
          totalDuration += entry.duration;
          totalEarnings += entry.calculateBillableAmount(hourlyRate);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    _formatDate(date),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatDuration(totalDuration),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (totalEarnings > 0)
                        Text(
                          '\$${totalEarnings.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            ...dayEntries.map((entry) => _buildTimeEntryTile(context, entry)),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget _buildTimeEntryTile(BuildContext context, TimeEntry entry) {
    final duration = entry.duration;
    final earnings = entry.calculateBillableAmount(hourlyRate);

    return ListTile(
      title: Text(
        entry.description ?? 'No description',
        style: TextStyle(
          color: entry.isPaused
              ? Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5)
              : null,
        ),
      ),
      subtitle: Text(
        '${_formatTime(entry.startTime)} - ${entry.endTime != null ? _formatTime(entry.endTime!) : 'ongoing'}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatDuration(duration),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: entry.isPaused
                  ? Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5)
                  : null,
            ),
          ),
          if (entry.isBillable)
            Text(
              '\$${earnings.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      leading: entry.isPaused
          ? const Icon(Icons.pause, size: 16)
          : entry.isActive
              ? const Icon(Icons.play_arrow, size: 16)
              : null,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }

    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}