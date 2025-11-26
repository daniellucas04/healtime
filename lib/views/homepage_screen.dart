import 'dart:async';
import 'package:app/dao/medication_dao.dart';
import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/helpers/session.dart';
import 'package:app/models/medication.dart';
import 'package:app/models/medicationschedule.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/medication_card.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/components/sidebar.dart';
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

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  DateTime searchDate = DateTime.now();
  int? selectedUserId;
  Timer? _timer;

  Future<void> loadUser() async {
    final id = await Session.getActiveUser();

    setState(() {
      selectedUserId = id;
    });

    _updateData(Timer(const Duration(), () {}));

    _timer = Timer.periodic(const Duration(minutes: 10), _updateData);
  }

  void _updateData(Timer timer) async {
    if (selectedUserId == null) return;
    final db = await DatabaseHelper.instance.database;
    final dao = MedicationScheduleDao(database: db);

    // Obtém todos os medicamentos agendados do usuário
    final meds = await dao.updateAll(selectedUserId!);

    final now = DateTime.now();

    for (var med in meds) {
      final medDate = DateTime.parse(med['date']);
      final currentStatus = med['status'];

      if (medDate.isBefore(now)) {
        final hoursDiff = now.difference(medDate).inHours;

        String newStatus = currentStatus;

        if (hoursDiff >= 10) {
          // Já passaram mais de 10 horas → 'Esquecido'
          if (currentStatus == 'Atrasado' || currentStatus == 'Pendente') {
            newStatus = 'Esquecido';
          }
        } else {
          // Entre 0 e 10 horas → 'Atrasado'
          if (currentStatus == 'Pendente') {
            newStatus = 'Atrasado';
          }
        }
        // Atualiza somente se necessário
        if (newStatus != currentStatus) {
          await dao.update(
            MedicationSchedule(
              id: med['id'],
              date: med['date'],
              status: newStatus,
              medicationId: med['medication_id'],
            ),
          );
        }
      }
    }

    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Sidebar(
        onUserSelected: (userId) {
          setState(() {
            selectedUserId = userId;
            if (selectedUserId != null) {
              Session.setActiveUser(selectedUserId!);
            }
          });
        },
        userId: selectedUserId ?? 1,
      ),
      resizeToAvoidBottomInset: false,
      appBar: const Header(
        title: 'Seja bem-vindo!',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getAll(searchDate, userId: selectedUserId);
          setState(() {});
        },
        child: FutureBuilder<List<Map<String, dynamic>>>(
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
      ),
      bottomNavigationBar: const NavBar(
        pageIndex: 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 35,
        ),
        onPressed: () => {
          Navigator.pushNamed(context, '/medicine_registration'),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
