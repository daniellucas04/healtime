import 'package:app/views/people/create_people_step1_name.dart';
import 'package:flutter/material.dart';

class CreatePeopleView extends StatelessWidget {
  const CreatePeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CreatePeopleStep1Name(),
      ),
    );
  }
}