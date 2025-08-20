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
        floatingLabelAlignment: FloatingLabelAlignment.start,
        floatingLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black54,
        ),
        label: Text(label),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black26, width: 2.0),
          borderRadius: BorderRadius.circular(100),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12, width: 2.0),
          borderRadius: BorderRadius.circular(100),
        ),
        suffixIcon: icon,
      ),
    );
  }
}
