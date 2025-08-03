import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/date_range_provider.dart';

class DateRangeSelector extends ConsumerWidget {
  const DateRangeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRange = ref.watch(dateRangeProvider);
    final presetRanges = ref.watch(presetRangesProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date Range',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...presetRanges.map((range) => ChoiceChip(
                  label: Text(range.label),
                  selected: range.label == selectedRange.label,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(dateRangeProvider.notifier).state = range;
                    }
                  },
                )),
                ActionChip(
                  avatar: const Icon(Icons.date_range),
                  label: const Text('Custom'),
                  onPressed: () => _showCustomRangePicker(context, ref, selectedRange),
                ),
              ],
            ),
            if (selectedRange.label == 'Custom Range') ...[
              const SizedBox(height: 8),
              Text(
                '${_formatDate(selectedRange.start)} - ${_formatDate(selectedRange.end)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _showCustomRangePicker(
    BuildContext context,
    WidgetRef ref,
    DateRange currentRange,
  ) async {
    final initialDateRange = DateTimeRange(
      start: currentRange.start,
      end: currentRange.end,
    );

    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      ref.read(dateRangeProvider.notifier).state = DateRange.custom(
        pickedRange.start,
        pickedRange.end,
      );
    }
  }
}