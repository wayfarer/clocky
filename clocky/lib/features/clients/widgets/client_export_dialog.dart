import 'package:flutter/material.dart';
import '../../../data/models/client.dart';

class ClientExportDialog extends StatefulWidget {
  final Client client;
  final Function(DateTime startDate, DateTime endDate) onExport;

  const ClientExportDialog({
    super.key,
    required this.client,
    required this.onExport,
  });

  @override
  State<ClientExportDialog> createState() => _ClientExportDialogState();
}

class _ClientExportDialogState extends State<ClientExportDialog> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    // Default to current month
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, 1);
    // Get the last day of the current month
    endDate = DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate ? startDate : endDate;
    final now = DateTime.now();
    final lastDate = DateTime(now.year, now.month, now.day);
    
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(lastDate) ? lastDate : initialDate,
      firstDate: DateTime(2020),
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          if (endDate.isBefore(startDate)) {
            endDate = startDate;
          }
        } else {
          endDate = picked;
          if (startDate.isAfter(endDate)) {
            startDate = endDate;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Export Client Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Export time entries for ${widget.client.name}'),
          const SizedBox(height: 16),
          const Text('Select Date Range'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'Start Date',
                  date: startDate,
                  onTap: () => _selectDate(context, true),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateField(
                  label: 'End Date',
                  date: endDate,
                  onTap: () => _selectDate(context, false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Note: Only billable time entries will be included in the export.',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () {
            widget.onExport(startDate, endDate);
            Navigator.pop(context);
          },
          icon: const Icon(Icons.download),
          label: const Text('Export'),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
            ),
            const Icon(Icons.calendar_today, size: 16),
          ],
        ),
      ),
    );
  }
}