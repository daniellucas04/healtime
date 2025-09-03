import 'package:app/views/components/create_header.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step4_duration.dart';
import 'package:flutter/material.dart';

enum MedicationFrequencyType {
  dias,
  horas,
  semanas,
  vezesAoDia,
}

class CreateMedicationStep3FrequencyType extends StatelessWidget {
  CreateMedicationStep3FrequencyType({
    super.key,
    required this.medicationName,
    required this.medicationType,
  });

  final TextEditingController medicationName;
  final MedicationType medicationType;
  MedicationFrequencyType medicationFrequencyType =
      MedicationFrequencyType.dias;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Olá 2'),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            Container(
              height: 400,
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => {
                            medicationFrequencyType =
                                MedicationFrequencyType.vezesAoDia,
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateMedicationStep4Duration(
                                            medicationName: medicationName,
                                            medicationType: medicationType,
                                            medicationFrequencyType:
                                                medicationFrequencyType)))
                          },
                          child: const Text('X Vezes ao Dia'),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => {
                            medicationFrequencyType =
                                MedicationFrequencyType.horas,
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateMedicationStep4Duration(
                                            medicationName: medicationName,
                                            medicationType: medicationType,
                                            medicationFrequencyType:
                                                medicationFrequencyType)))
                          },
                          child: const Text('De X em X Horas'),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => {
                            medicationFrequencyType =
                                MedicationFrequencyType.dias,
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateMedicationStep4Duration(
                                            medicationName: medicationName,
                                            medicationType: medicationType,
                                            medicationFrequencyType:
                                                medicationFrequencyType)))
                          },
                          child: const Text('De X em X Dias'),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => {
                            medicationFrequencyType =
                                MedicationFrequencyType.semanas,
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateMedicationStep4Duration(
                                            medicationName: medicationName,
                                            medicationType: medicationType,
                                            medicationFrequencyType:
                                                medicationFrequencyType)))
                          },
                          child: const Text('De X em X semanas'),
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
