import 'package:app/views/components/header.dart';
import 'package:app/views/medicine/create_medication_step3_frequency_type.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

enum MedicationType {
  comprimido,
  injecao,
  gotas,
  pomada,
  inalador,
  liquido,
}

class CreateMedicationStep2Type extends StatelessWidget {
  CreateMedicationStep2Type({
    super.key,
    required this.medicationName,
  });

  final TextEditingController medicationName;
  MedicationType medicationType = MedicationType.comprimido;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(
        title: 'Forma de consumo',
        subtitle: 'Qual a forma de consumo?',
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
                            medicationType = MedicationType.comprimido,
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateMedicationStep3FrequencyType(
                                        medicationName: medicationName,
                                        medicationType: medicationType),
                              ),
                            ),
                          },
                          child: const Text('Comprimido'),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => {
                            medicationType = MedicationType.injecao,
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateMedicationStep3FrequencyType(
                                        medicationName: medicationName,
                                        medicationType: medicationType),
                              ),
                            ),
                          },
                          child: const Text('Injeção'),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => {
                            medicationType = MedicationType.gotas,
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateMedicationStep3FrequencyType(
                                        medicationName: medicationName,
                                        medicationType: medicationType),
                              ),
                            ),
                          },
                          child: const Text('Gotas'),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => {
                            medicationType = MedicationType.pomada,
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateMedicationStep3FrequencyType(
                                        medicationName: medicationName,
                                        medicationType: medicationType),
                              ),
                            ),
                          },
                          child: const Text('Pomada'),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => {
                            medicationType = MedicationType.inalador,
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateMedicationStep3FrequencyType(
                                        medicationName: medicationName,
                                        medicationType: medicationType),
                              ),
                            ),
                          },
                          child: const Text('Inalador'),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => {
                            medicationType = MedicationType.liquido,
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateMedicationStep3FrequencyType(
                                        medicationName: medicationName,
                                        medicationType: medicationType),
                              ),
                            ),
                          },
                          child: const Text('Liquido'),
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
