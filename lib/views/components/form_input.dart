import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final Icon icon;
  final String label;
  final TextEditingController controller;

  const FormInput({
    Key? key,
    required this.icon,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      key: key,
      decoration: InputDecoration(
        label: Text(label),
        suffixIcon: icon,
      ),
    );
  }
}
