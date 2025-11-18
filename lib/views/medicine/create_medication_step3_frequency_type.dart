import 'package:app/views/components/header.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step4_frequency_value.dart';
import 'package:app/views/theme/theme.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: const Header(
        title: 'Frequência de consumo',
        subtitle: 'Qual a freqência que deve tomar?',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: (context.heightPercentage(0.05)),
            ),
            Container(
              height: (context.heightPercentage(0.95) - 200),
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
                                    CreateMedicationStep4FrequencyValue(
                                  medicationName: medicationName,
                                  medicationType: medicationType,
                                  medicationFrequencyType:
                                      medicationFrequencyType,
                                ),
                              ),
                            ),
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
                                    CreateMedicationStep4FrequencyValue(
                                  medicationName: medicationName,
                                  medicationType: medicationType,
                                  medicationFrequencyType:
                                      medicationFrequencyType,
                                ),
                              ),
                            ),
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
                                    CreateMedicationStep4FrequencyValue(
                                  medicationName: medicationName,
                                  medicationType: medicationType,
                                  medicationFrequencyType:
                                      medicationFrequencyType,
                                ),
                              ),
                            ),
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
                                    CreateMedicationStep4FrequencyValue(
                                        medicationName: medicationName,
                                        medicationType: medicationType,
                                        medicationFrequencyType:
                                            medicationFrequencyType),
                              ),
                            ),
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
      ),
    );
  }
}
