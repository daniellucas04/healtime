import 'package:app/views/homepage_screen.dart';
import 'package:app/views/medicine/create_medication_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (BuildContext context) => const HomePageScreen(),
      '/medicine_registration': (BuildContext context) =>
          const CreateMedicationScreen()
    },
  ));
}
