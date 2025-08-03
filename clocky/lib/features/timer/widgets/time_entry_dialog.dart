import 'package:flutter/material.dart';
import '../../../data/models/time_entry.dart';

class TimeEntryDialog extends StatefulWidget {
  final TimeEntry entry;
  final Function(TimeEntry) onSave;
  final VoidCallback onDelete;

  const TimeEntryDialog({
    super.key,
    required this.entry,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<TimeEntryDialog> createState() => _TimeEntryDialogState();
}

class _TimeEntryDialogState extends State<TimeEntryDialog> {
  late TextEditingController _descriptionController;
  late DateTime _startTime;
  late DateTime? _endTime;
  late bool _isBillable;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.entry.description);
    _startTime = widget.entry.startTime;
    _endTime = widget.entry.endTime;
    _isBillable = widget.entry.isBillable;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(bool isStartTime) async {
    final currentTime = isStartTime ? _startTime : (_endTime ?? DateTime.now());
    
    final date = await showDatePicker(
      context: context,
      initialDate: currentTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentTime),
    );

    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Validate the new datetime
    if (isStartTime) {
      if (_endTime != null && dateTime.isAfter(_endTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Start time cannot be after end time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      setState(() => _startTime = dateTime);
    } else {
      if (dateTime.isBefore(_startTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time cannot be before start time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      setState(() => _endTime = dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Time Entry'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'What did you work on?',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Start Time'),
              subtitle: Text(
                _startTime.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: const Icon(Icons.edit),
              onTap: () => _selectDateTime(true),
            ),
            ListTile(
              title: const Text('End Time'),
              subtitle: Text(
                _endTime?.toString() ?? 'Still running',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: const Icon(Icons.edit),
              onTap: widget.entry.isActive ? null : () => _selectDateTime(false),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _isBillable,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _isBillable = value;
                      });
                    }
                  },
                ),
                const Text('Billable'),
              ],
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
          onPressed: widget.onDelete,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Delete'),
        ),
        FilledButton(
          onPressed: () {
            // Validate times
            if (_endTime != null && _endTime!.isBefore(_startTime)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('End time cannot be before start time'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            // Validate against current time for active entries
            if (_endTime == null && _startTime.isAfter(DateTime.now())) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Start time cannot be in the future for active entries'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            final updatedEntry = widget.entry.copyWith(
              description: _descriptionController.text.trim(),
              startTime: _startTime,
              endTime: _endTime,
              isBillable: _isBillable,
            );
            widget.onSave(updatedEntry);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}