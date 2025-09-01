import 'package:flutter/material.dart';

class Alert extends StatelessWidget{
  
  final String title;
  final String message;
  final String? buttonMessage;

  const Alert({
    Key? key, 
    required this.title,
    required this.message, 
    this.buttonMessage,
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
      actions: <Widget>[
        TextButton(
          child: buttonMessage != null ? Text(buttonMessage!) : const Text('Comfirmar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
} 