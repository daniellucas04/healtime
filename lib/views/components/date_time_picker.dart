import 'package:flutter/material.dart';

Future<DateTime?> dateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= DateTime(2000);
  lastDate ??= DateTime(2100);

  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (selectedDate == null) return null;

  if (!context.mounted) return null;

  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );

  if (selectedTime == null) return selectedDate;

  return DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );
}

Future<DateTime?> datePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= DateTime(2000);
  lastDate ??= DateTime(2100);

  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (selectedDate == null) return null;

  if (!context.mounted) return null;

  return DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
  );
}

String dateHourFormat(DateTime date) {
  return '${date.day}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(2, '0')} '
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

String dateFormat(DateTime date){
  return '${date.day}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(2, '0')}';
}

String timeFormat(DateTime date) {
  return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
