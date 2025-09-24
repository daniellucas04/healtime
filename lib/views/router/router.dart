import 'package:app/views/homepage_screen.dart';
import 'package:app/views/medicine/create_medication_view.dart';
import 'package:app/views/people/create_people_view.dart';
import 'package:app/views/people/home_people.dart';
import 'package:flutter/material.dart';

var routes = {
  '/': (BuildContext context) => const HomePageScreen(),
  '/medicine_registration': (BuildContext context) => const CreateMedication(),
  '/people': (BuildContext context) => const HomePeople(),
  '/create_people': (BuildContext context) => const CreatePeopleView(),
};
