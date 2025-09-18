import 'package:flutter/services.dart';

class MaxValueInputFormatter extends TextInputFormatter {
  final int max;

  MaxValueInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final intValue = int.tryParse(newValue.text);
    if (intValue == null || intValue > max) {
      return oldValue; // Rejeita a nova entrada
    }
    return newValue;
  }
}
