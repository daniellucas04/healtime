import 'package:app/dao/medication_dao.dart';
import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/medication.dart';
import 'package:app/models/medicationschedule.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/medicine/edit_medication_view.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

Future<Medication?> getById(int id) async {
  return MedicationDao(database: await DatabaseHelper.instance.database)
      .getById(id);
}

class MedicationsCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const MedicationsCard({super.key, required this.items});

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

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? SizedBox(
            width: context.widthPercentage(1),
            child: const Padding(
              padding: EdgeInsets.only(top: 54, left: 30, right: 30),
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
                    textAlign: TextAlign.center,
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
          )
        : SizedBox(
            width: context.widthPercentage(1),
            child: Padding(
              padding: const EdgeInsets.only(top: 54),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final medication = items[index];
                  return Column(
                    children: [
                      Card(
                        shadowColor: Colors.black87,
                        elevation: 2,
                        margin: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                accentLightTheme,
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
                                            if (context.mounted) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  '/',
                                                  (route) => false);
                                            }
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
                                            if (context.mounted) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  '/',
                                                  (route) => false);
                                            }
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
                                            if (context.mounted) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  '/',
                                                  (route) => false);
                                            }
                                          }
                                        },
                                        child: const Text('Esquecido'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          navigator.pop();
                                        },
                                        child: const Text('Cancelar'),
                                      )
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
              ),
            ),
          );
  }
}
