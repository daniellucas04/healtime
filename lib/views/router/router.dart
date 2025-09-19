import 'package:app/views/homepage_screen.dart';
import 'package:app/views/medicine/create_medication_view.dart';
import 'package:flutter/material.dart';

var routes = {
  '/': (BuildContext context) => HomePageScreen(),
  '/medicine_registration': (BuildContext context) => const CreateMedication(),
};
