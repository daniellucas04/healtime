import 'package:app/controllers/user_medication_controller.dart';
import 'package:app/dao/medication_dao.dart';
import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/medication.dart';
import 'package:app/models/medicationschedule.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/medicine/create_medication_step1_name.dart';
import 'package:app/views/medicine/edit_medication_view.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Future<Medication?> getById(int id) async {
  return MedicationDao(database: await DatabaseHelper.instance.database)
      .getById(id);
}

class MedicationsCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final DateTime searchDate;
  final Function(DateTime? searchDate) onChange;

  const MedicationsCard(
      {super.key,
      required this.items,
      required this.onChange,
      required this.searchDate});

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
        .update(
      MedicationSchedule(
          date: date, status: status, medicationId: medicationId, id: id),
    );

    if (updatedMedicationSchedule != 0) {
      return true;
    }

    return false;
  }

  void _shareMedication(medication) async {
    var userMedication = await UserMedicationController()
        .getUserFromMedication(medication['id']);

    String username = userMedication[0]['name']!;
    String medicationName = medication['name'];
    String medicationDate = dateFormat(
      DateTime.parse(medication['date']),
    );
    String medicationHour = timeFormat(DateTime.parse(medication['date']));

    SharePlus.instance.share(
      ShareParams(
        title: 'Compartilhar medicamento agendado',
        text:
            '''Olá $username! Você possui um medicamento agendado.\n\n- ${medicationName.toUpperCase()} ($medicationDate) às $medicationHour''',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? Column(
            spacing: 14,
            children: [
              SizedBox(
                width: context.widthPercentage(1),
                child: Padding(
                  padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 400),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  CreateMedicationStep1Name(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add_circle_outline_outlined,
                      size: 24,
                    ),
                    label: const Text(
                      'Novo medicamento',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
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
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    title: const Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Text(
                                          'Ajuste o estado da medicação',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Escolha uma opção para o estado da medicação:',
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton.icon(
                                        onPressed: () async {
                                          if (await _updateMedicationScheduleStatus(
                                              medication['date'],
                                              'Tomado',
                                              medication['medication_id'],
                                              medication['id'])) {
                                            onChange(searchDate);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.check_circle_outline_rounded,
                                          size: 20,
                                        ),
                                        iconAlignment: IconAlignment.end,
                                        label: const Text(
                                          'Tomado',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () async {
                                          if (await _updateMedicationScheduleStatus(
                                              medication['date'],
                                              'Atrasado',
                                              medication['medication_id'],
                                              medication['id'])) {
                                            onChange(searchDate);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.restore,
                                          size: 20,
                                        ),
                                        iconAlignment: IconAlignment.end,
                                        label: const Text(
                                          'Atrasado',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () async {
                                          if (await _updateMedicationScheduleStatus(
                                              medication['date'],
                                              'Esquecido',
                                              medication['medication_id'],
                                              medication['id'])) {
                                            onChange(searchDate);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.hide_source,
                                          size: 20,
                                        ),
                                        iconAlignment: IconAlignment.end,
                                        label: const Text(
                                          'Esquecido',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Cancelar',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
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
                                  spacing: 10,
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
                                    TextButton(
                                      style: const ButtonStyle(
                                        backgroundColor:
                                            WidgetStatePropertyAll<Color>(
                                          Colors.black12,
                                        ),
                                        alignment: Alignment.center,
                                        animationDuration:
                                            Duration(milliseconds: 300),
                                      ),
                                      onPressed: () =>
                                          _shareMedication(medication),
                                      child: const Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                        size: 22,
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
