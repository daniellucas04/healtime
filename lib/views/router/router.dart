import 'package:app/views/components/tutorial_screen.dart';
import 'package:app/views/backup/backup_view.dart';
import 'package:app/views/homepage_screen.dart';
import 'package:app/views/medicine/create_medication_view.dart';
import 'package:app/views/menu/menu_view.dart';
import 'package:app/views/people/create_people_view.dart';
import 'package:app/views/people/home_people.dart';
import 'package:app/views/report/report_view.dart';
import 'package:flutter/material.dart';

var routes = {
  '/homepage': (BuildContext context) => const HomePageScreen(),
  '/tutorial_screen': (BuildContext context) => const TutorialScreen(),
  '/medicine_registration': (BuildContext context) => const CreateMedication(),
  '/people': (BuildContext context) => const HomePeople(),
  '/create_people': (BuildContext context) => const CreatePeopleView(),
  '/menu': (BuildContext context) => const MenuView(),
  '/backup': (BuildContext context) => const BackupView()
};
