import 'package:app/controllers/user_controller.dart';
import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/models/medicationschedule.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/homepage_screen.dart';
import 'package:app/views/medicine/create_medication_step1_name.dart';
import 'package:app/views/medicine/edit_medication_view.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:app/controllers/user_medication_controller.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/medication.dart';
import 'package:share_plus/share_plus.dart';

class MedicationsCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final DateTime searchDate;
  final Function(DateTime? searchDate) onChange;

  const MedicationsCard({
    super.key,
    required this.items,
    required this.onChange,
    required this.searchDate,
  });

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

    return updatedMedicationSchedule != 0;
  }

  void _shareMedication(medication) async {
    var userMedication = await UserMedicationController()
        .getUserFromMedication(medication['medication_id']);

    var user = await UserController().getById(userMedication[0]['user_id']);
    String? username = user?.name.toUpperCase();
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
    return SizedBox(
      width: context.widthPercentage(1),
      child: items.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) =>
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 56),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final medication = items[index];

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade900,
                          Colors.blue.shade700,
                          _setMedicationColor(medication['status']),
                          _setMedicationColor(medication['status']),
                        ],
                      ),
                    ),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      shadowColor: Colors.black45,
                      child: InkWell(
                        onTap: () async {
                          _showMedicationStatusDialog(context, medication);
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
                                  medication: editMedication,
                                ),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          medication['name'].toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      spacing: 8,
                                      children: [
                                        Text(
                                          "${medication['type'].toString()[0].toUpperCase()}${medication['type'].toString().substring(1)}:",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          medication['quantity'].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Text(
                                          '-',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "${medication['status']}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      timeFormat(
                                        DateTime.parse(medication['date']),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _shareMedication(medication),
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  _getQuantityBadge(medication) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 0, 204, 231),
        shape: BoxShape.circle,
      ),
      child: Text(
        "${medication['quantity']}",
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  _showMedicationStatusDialog(context, medication) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
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
                medication['id'],
              )) {
                onChange(searchDate);
              }
            },
            iconAlignment: IconAlignment.end,
            icon: const Icon(
              Icons.check_circle_outline_rounded,
              size: 20,
            ),
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
                medication['id'],
              )) {
                onChange(searchDate);
              }
            },
            iconAlignment: IconAlignment.end,
            icon: const Icon(
              Icons.restore,
              size: 20,
            ),
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
                medication['id'],
              )) {
                onChange(searchDate);
              }
            },
            iconAlignment: IconAlignment.end,
            icon: const Icon(
              Icons.hide_source,
              size: 20,
            ),
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
  }
}
