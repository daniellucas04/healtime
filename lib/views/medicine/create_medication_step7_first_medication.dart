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
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

class CreateMedicationStep7FirstMedication extends StatelessWidget {
  CreateMedicationStep7FirstMedication({
    super.key,
    required this.medicationName,
    required this.medicationType,
    required this.medicationFrequencyType,
    required this.medicationFrequencyValue,
    required this.medicationQuantity,
    required this.medicationDuration,
  });

  final TextEditingController medicationName;
  final MedicationType medicationType;
  final MedicationFrequencyType medicationFrequencyType;
  final TextEditingController medicationFrequencyValue;
  final TextEditingController medicationDuration;
  final TextEditingController medicationQuantity;
  final TextEditingController medicationDate = TextEditingController();
  DateTime? medicationFirstDate;

  Future<void> saveMedication(context) async {
    if (!context.mounted) return;

    var interval = 0;
    var duration = int.parse(medicationDuration.text);
    DateTime incrementDate = medicationFirstDate!;
    DateTime finalDate =
        DateTime(incrementDate.year, incrementDate.month, incrementDate.day);
    finalDate = finalDate.add(Duration(days: duration));

    if (medicationFirstDate != null) {
      Medication medication = Medication(
        name: medicationName.text,
        type: medicationType.name,
        frequencyType: medicationFrequencyType.name,
        frequencyValue: int.parse(medicationFrequencyValue.text),
        duration: int.parse(medicationFrequencyValue.text),
        quantity: int.parse(medicationQuantity.text),
        firstMedication: medicationFirstDate.toString(),
      );

      var insertedMedication = MedicationController().save(medication);

      if (await insertedMedication != 0) {
        if (medicationFrequencyType == MedicationFrequencyType.dias) {
          interval = int.parse(medicationFrequencyValue.text) * 24;
        } else if (medicationFrequencyType == MedicationFrequencyType.semanas) {
          interval = int.parse(medicationFrequencyValue.text) * 168;
        } else if (medicationFrequencyType ==
            MedicationFrequencyType.vezesAoDia) {
          interval = (24 ~/ int.parse(medicationFrequencyValue.text));
        } else {
          interval = int.parse(medicationFrequencyValue.text);
        }

        while (incrementDate.isBefore(finalDate)) {
          await MedicationScheduleDao(
                  database: await DatabaseHelper.instance.database)
              .insert(MedicationSchedule(
                  date: incrementDate.toString(),
                  status: "N",
                  medicationId: await insertedMedication));
          incrementDate = incrementDate.add(Duration(hours: interval));
        }
      }

      if (await insertedMedication != 0) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        return;
      }

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => Alert(
          message: 'Ocorreu um erro ao cadastrar o medicamento',
          title: 'Erro ao Cadastrar',
          actions: [
            TextButton(
              onPressed: () {},
              child: Text('OK'),
            )
          ],
        ),
      );
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Alert(
        message: 'Adicione a data',
        title: 'Campo Inválido',
        actions: [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(
        title: 'Data da primeira dose',
        subtitle: 'Qual a data que irá começar o tratamento?',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: (context.heightPercentage(0.05)),
            ),
            Container(
              height: (context.heightPercentage(0.90) - 200),
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      TextField(
                        controller: medicationDate,
                        readOnly: true, // Impede digitação manual
                        decoration: const InputDecoration(
                          labelText: "Data e Hora",
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async => {
                          medicationFirstDate =
                              await dateTimePicker(context: context),
                          if (medicationFirstDate != null)
                            {
                              medicationDate.text =
                                  dateFormat(medicationFirstDate!),
                            }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        saveMedication(context);
                      },
                      child: const Text('Finalizar'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
