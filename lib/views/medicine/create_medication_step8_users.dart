import 'package:app/controllers/medication_controller.dart';
import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/medication.dart';
import 'package:app/models/medicationschedule.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step3_frequency_type.dart';
import 'package:app/views/medicine/create_medication_step9_notifications.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:app/dao/user_dao.dart';
import 'package:app/models/usermedication.dart';
import 'package:app/models/user.dart';
import 'package:app/controllers/user_medication_controller.dart';

class CreateMedicationStep8UserMedication extends StatefulWidget {
  CreateMedicationStep8UserMedication({
    super.key,
    required this.medicationName,
    required this.medicationType,
    required this.medicationFrequencyType,
    required this.medicationFrequencyValue,
    required this.medicationDuration,
    required this.medicationQuantity,
    required this.medicationFirstDate,
  });

  final TextEditingController medicationName;
  final MedicationType medicationType;
  final MedicationFrequencyType medicationFrequencyType;
  final TextEditingController medicationFrequencyValue;
  final TextEditingController medicationDuration;
  final TextEditingController medicationQuantity;
  final DateTime medicationFirstDate;

  @override
  State<CreateMedicationStep8UserMedication> createState() =>
      _CreateMedicationStep8UserMedicationState();
}

class _CreateMedicationStep8UserMedicationState
    extends State<CreateMedicationStep8UserMedication> {
  User? selectedUser;
  late Future<List<User>> usersFuture;

  @override
  void initState() {
    super.initState();
    usersFuture = _getUsersWithDefault();
  }

  Future<List<User>> _getUsersWithDefault() async {
    final dao = UserDao(database: await DatabaseHelper.instance.database);
    var users = await dao.getAll();

    if (users.isEmpty) {
      await dao.insert(User(
        name: 'Você',
        birthDate: DateTime(2000, 1, 1).toString(),
        active: 1,
      ));
      users = await dao.getAll();
    }

    return users;
  }

  Future<void> _handleFinish() async {
    if (selectedUser == null) {
      _showAlert('Selecione um usuário', 'Usuário obrigatório');
      return;
    }

    // Criação do medicamento
    final medication = Medication(
      name: widget.medicationName.text,
      type: widget.medicationType.name,
      frequencyType: widget.medicationFrequencyType.name,
      frequencyValue: int.parse(widget.medicationFrequencyValue.text),
      duration: int.parse(widget.medicationDuration.text),
      quantity: int.parse(widget.medicationQuantity.text),
      firstMedication: widget.medicationFirstDate.toIso8601String(),
    );

    final medicationId = await MedicationController().save(medication);

    if (medicationId == 0) {
      _showAlert('Erro ao cadastrar', 'Não foi possível salvar o medicamento.');
      return;
    }

    // Inserir vínculo user-medication
    await UserMedicationController().linkUserToMedication(UserMedication(
      userId: selectedUser!.id!,
      medicationId: medicationId,
    ));

    // Criar agenda (calculate interval)
    int interval = 0;
    if (widget.medicationFrequencyType == MedicationFrequencyType.dias) {
      interval = int.parse(widget.medicationFrequencyValue.text) * 24;
    } else if (widget.medicationFrequencyType ==
        MedicationFrequencyType.semanas) {
      interval = int.parse(widget.medicationFrequencyValue.text) * 168;
    } else if (widget.medicationFrequencyType ==
        MedicationFrequencyType.vezesAoDia) {
      interval = (24 ~/ int.parse(widget.medicationFrequencyValue.text));
    } else {
      interval = int.parse(widget.medicationFrequencyValue.text);
    }

    DateTime incrementDate = widget.medicationFirstDate;
    DateTime finalDate = incrementDate.add(Duration(
      days: int.parse(widget.medicationDuration.text),
    ));

    final scheduleDao = MedicationScheduleDao(
      database: await DatabaseHelper.instance.database,
    );

    // Inserindo todas as doses
    List<Future<int>> medicationsSchedule = [];
    while (incrementDate.isBefore(finalDate)) {
      var insert = scheduleDao.insert(MedicationSchedule(
        date: incrementDate.toIso8601String(),
        status: "Pendente",
        medicationId: medicationId,
      ));
      incrementDate = incrementDate.add(Duration(hours: interval));

      medicationsSchedule.add(insert);
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateMedicationStep9Notifications(
          medicationList: medicationsSchedule,
        ),
      ),
    );
  }

  void _showAlert(String title, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Alert(
        title: title,
        message: message,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // widget.medicationName.dispose();
    // widget.medicationFrequencyValue.dispose();
    // widget.medicationDuration.dispose();
    // widget.medicationQuantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: 'Usuário',
        subtitle: 'O remédio vai ser para qual usuário?',
      ),
      body: FutureBuilder<List<User>>(
        future: usersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: context.heightPercentage(0.05)),
                Container(
                  height: context.heightPercentage(0.90) - 200,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButtonFormField<User>(
                        isExpanded: true,
                        value: selectedUser,
                        hint: const Text("Selecione um usuário"),
                        items: users.map((user) {
                          return DropdownMenuItem<User>(
                            value: user,
                            child: Text(user.name),
                          );
                        }).toList(),
                        onChanged: (user) {
                          setState(() {
                            selectedUser = user;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _handleFinish,
                          child: const Text('Próximo'),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
