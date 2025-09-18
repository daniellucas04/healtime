import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;

  const Alert({
    Key? key,
    required this.title,
    required this.message,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(message),
          ],
        ),
      ),
      actions: actions,
    );
  }
}
