import 'package:flutter/material.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: <Widget>[
          const Text('Homepage'),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/medicine_registration');
            },
            child: Text('Launch screen'),
          ),
        ],
      )),
    );
  }
}
