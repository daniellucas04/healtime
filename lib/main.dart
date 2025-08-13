import 'package:app/views/homepage_screen.dart';
import 'package:app/views/medicine/medicine_register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (BuildContext context) => const HomePageScreen(),
      '/medicine_registration': (BuildContext context) =>
          const MedicineRegisterScreen()
    },
  ));
}
