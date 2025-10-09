import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/main.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/medication_card.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/components/sidebar.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

Future<List<Map<String, dynamic>>> getAll(DateTime searchDate) async {
  return MedicationScheduleDao(database: await DatabaseHelper.instance.database)
      .getAll(searchDate);
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  DateTime searchDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const Sidebar(),
      resizeToAvoidBottomInset: false,
      appBar: Header(
        title: 'Seja bem-vindo!',
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAll(searchDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];

          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            searchDate =
                                searchDate.add(const Duration(days: -1));
                          });
                        },
                        icon: const Icon(
                          Icons.keyboard_double_arrow_left_outlined,
                          size: 34,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          DateTime? selectedDate = await datePicker(
                              context: context, initialDate: searchDate);
                          setState(() {
                            if (selectedDate != null) {
                              searchDate = selectedDate;
                            }
                          });
                        },
                        child: Text(
                          DateFormat('dd/MM').format(searchDate),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            searchDate =
                                searchDate.add(const Duration(days: 1));
                          });
                        },
                        icon: const Icon(
                          Icons.keyboard_double_arrow_right_outlined,
                          size: 34,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MedicationsCard(items: items),
            ],
          );
        },
      ),
      bottomNavigationBar: const NavBar(
        pageIndex: 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 35,
          color: backgroundDarkTheme50,
        ),
        onPressed: () => {
          Navigator.pushNamed(context, '/medicine_registration'),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
