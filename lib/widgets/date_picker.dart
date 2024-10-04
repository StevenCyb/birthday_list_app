import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime>? onDateChanged;

  DatePicker({
    super.key,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    this.onDateChanged,
  })  : initialDate = initialDate ?? DateTime.now(),
        firstDate = firstDate ?? DateTime(1900, 1, 1),
        lastDate = lastDate ?? DateTime.now();

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  late TextEditingController _controller;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(text: _formatDate(_selectedDate));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _controller.text = _formatDate(_selectedDate);
      });

      if (widget.onDateChanged != null) {
        widget.onDateChanged!(_selectedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: const InputDecoration(
        hintText: 'Select date',
        hintStyle: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
