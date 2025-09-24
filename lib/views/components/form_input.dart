import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormInput extends StatelessWidget {
  final Icon? icon;
  final String label;
  final TextEditingController controller;

  const FormInput({
    Key? key,
    this.icon,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      key: key,
      inputFormatters: [
        LengthLimitingTextInputFormatter(25)
      ],
      decoration: InputDecoration(
        label: Text(label),
        suffixIcon: icon,
      ),
    );
  }
}
