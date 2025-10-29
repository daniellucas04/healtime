import 'dart:async';
import 'package:app/dao/medication_dao.dart';
import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/medication.dart';
import 'package:app/models/medicationschedule.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/medication_card.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/components/sidebar.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<List<Map<String, dynamic>>> getAll(DateTime searchDate,
    {int? userId}) async {
  return MedicationScheduleDao(database: await DatabaseHelper.instance.database)
      .getAll(searchDate, userId: userId);
}

Future<Medication?> getById(int id) async {
  return MedicationDao(database: await DatabaseHelper.instance.database)
      .getById(id);
}

Future<int> getActiveUser() async {
  return await UserDao(database: await DatabaseHelper.instance.database)
      .getActiveUser();
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  DateTime searchDate = DateTime.now();
  int? selectedUserId;
  late Timer _timer;

  Future<void> loadUser() async {
    final id = await getActiveUser();
    setState(() {
      selectedUserId = id;
    });
  }

  void _updateData(Timer timer) async {
    var meds = await MedicationScheduleDao(
            database: await DatabaseHelper.instance.database)
        .updateAll(selectedUserId!);
    for (var med in meds) {
      if (DateTime.parse(med['date']).isBefore(DateTime.now())) {
        Duration difference =
            DateTime.parse(med['date']).difference(DateTime.now());
        if (difference < const Duration(hours: -10)) {
          await MedicationScheduleDao(
                  database: await DatabaseHelper.instance.database)
              .update(MedicationSchedule(
                  id: med['id'],
                  date: med['date'],
                  status:
                      med['status'] == 'Atrasado' ? 'Esquecido' : med['status'],
                  medicationId: med['medication_id']));
        } else {
          await MedicationScheduleDao(
                  database: await DatabaseHelper.instance.database)
              .update(MedicationSchedule(
                  id: med['id'],
                  date: med['date'],
                  status:
                      med['status'] == 'Pendente' ? 'Atrasado' : med['status'],
                  medicationId: med['medication_id']));
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    _timer = Timer.periodic(const Duration(minutes: 10), _updateData);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Sidebar(
        onUserSelected: (userId) {
          setState(() {
            selectedUserId = userId;
          });
        },
      ),
      resizeToAvoidBottomInset: false,
      appBar: Header(
        title: 'Seja bem-vindo!',
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAll(searchDate, userId: selectedUserId),
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
              MedicationsCard(
                items: items,
                searchDate: searchDate,
                onChange: (DateTime? newSearchDate) {
                  setState(() {
                    searchDate = newSearchDate!;
                    Navigator.pop(context);
                  });
                },
              ),
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
