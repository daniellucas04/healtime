import 'package:app/dao/medication_dao.dart';
import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/medication.dart';
import 'package:app/models/medicationschedule.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/components/sidebar.dart';
import 'package:app/views/medicine/edit_medication_view.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<List<Map<String, dynamic>>> getAll(DateTime searchDate) async {
  return MedicationScheduleDao(database: await DatabaseHelper.instance.database)
      .getAll(searchDate);
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

  Future<bool> _updateMedicationScheduleStatus(
      String date, String status, int medicationId, int id) async {
    var updatedMedicationSchedule = await MedicationScheduleDao(
            database: await DatabaseHelper.instance.database)
        .update(MedicationSchedule(
            date: date, status: status, medicationId: medicationId, id: id));

    if (updatedMedicationSchedule != 0) {
      return true;
    }

    return false;
  }

  Color _setMedicationColor(status) {
    if (status == 'Tomado') {
      return const Color.fromARGB(255, 10, 218, 131);
    }

    if (status == 'Atrasado') {
      return const Color.fromARGB(255, 189, 192, 13);
    }

    if (status == 'Esquecido') {
      return const Color.fromARGB(255, 211, 35, 12);
    }

    return const Color.fromARGB(255, 8, 50, 150);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Sidebar(
        onUserSelected: (userId) {
          setState(() {
            // selectedUserId = userId; // Atualiza o ID do usuário selecionado
          });
        },
      ),
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

          if (items.isEmpty) {
            return Column(
              children: [
                Row(
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
                            Icons.keyboard_double_arrow_left_outlined)),
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
                          searchDate = searchDate.add(const Duration(days: 1));
                        });
                      },
                      icon: const Icon(
                          Icons.keyboard_double_arrow_right_outlined),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                const Center(
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 50,
                        right: 50,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        'Nenhum registro encontrado',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final medication = items[index];
              return Column(
                children: [
                  index == 0
                      ? Container(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      searchDate = searchDate
                                          .add(const Duration(days: -1));
                                    });
                                  },
                                  icon: const Icon(Icons
                                      .keyboard_double_arrow_left_outlined)),
                              TextButton(
                                onPressed: () async {
                                  DateTime? selectedDate = await datePicker(
                                      context: context,
                                      initialDate: searchDate);
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
                                      searchDate = searchDate
                                          .add(const Duration(days: 1));
                                    });
                                  },
                                  icon: const Icon(Icons
                                      .keyboard_double_arrow_right_outlined))
                            ],
                          ))
                      : const SizedBox(
                          height: 1,
                          width: 1,
                        ),
                  Card(
                    shadowColor: Colors.black87,
                    elevation: 8,
                    margin: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(
                          colors: [
                            accentLightTheme,
                            _setMedicationColor(medication['status']),
                          ],
                          begin: AlignmentGeometry.bottomLeft,
                          end: AlignmentGeometry.topRight,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor: Colors.blue.withAlpha(100),
                          onTap: () async {
                            final navigator = Navigator.of(context);
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => Alert(
                                title: 'Ajuste o estado da medicação',
                                message: 'Escolha uma opção',
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      if (await _updateMedicationScheduleStatus(
                                          medication['date'],
                                          'Tomado',
                                          medication['medication_id'],
                                          medication['id'])) {
                                        navigator.pushNamed('/');
                                      }
                                    },
                                    child: const Text('Tomado'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (await _updateMedicationScheduleStatus(
                                          medication['date'],
                                          'Atrasado',
                                          medication['medication_id'],
                                          medication['id'])) {
                                        navigator.pushNamed('/');
                                      }
                                    },
                                    child: const Text('Atrasado'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (await _updateMedicationScheduleStatus(
                                          medication['date'],
                                          'Esquecido',
                                          medication['medication_id'],
                                          medication['id'])) {
                                        navigator.pushNamed('/');
                                      }
                                    },
                                    child: const Text('Esquecido'),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        navigator.pop();
                                      },
                                      child: const Text('Cancelar'))
                                ],
                              ),
                            );
                          },
                          onLongPress: () async {
                            int medicationId = medication['medication_id'];
                            Medication? editMedication =
                                await getById(medicationId);
                            if (!context.mounted) return;

                            if (editMedication != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditMedication(
                                      medication: editMedication),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    dense: true,
                                    textColor: Colors.white,
                                    title: Text(
                                      medication['name'].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${medication['type']}: ${medication['quantity']}\n${medication['status']}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  timeFormat(
                                    DateTime.parse(medication['date']),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
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
