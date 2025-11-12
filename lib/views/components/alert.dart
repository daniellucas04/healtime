import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final Function? onChange;
  final String title;
  final Widget content;
  final List<Widget> actions;

  const Alert({
    Key? key,
    required this.title,
    this.onChange,
    required this.content,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            this.title,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [content],
      ),
      actions: actions,
    );
  }
}
