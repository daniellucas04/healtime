import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final Icon icon;
  final String label;

  const FormInput({
    Key? key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      decoration: InputDecoration(
        label: Text(label),
        suffixIcon: icon,
      ),
    );
  }
}
