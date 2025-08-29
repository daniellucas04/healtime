import 'package:app/views/components/create_header.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step4_duration.dart';
import 'package:flutter/material.dart';

enum MedicationFrequency {
  dias,
  horas,
  meses,
  vezesAoDia,
}

class CreateMedicationStep3Frequency extends StatelessWidget {
  CreateMedicationStep3Frequency({super.key, required this.medicationName, required this.medicationType,});

  final TextEditingController medicationName;
  final MedicationType medicationType;
  MedicationFrequency medicationFrequency = MedicationFrequency.dias;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const CreateHeader(
                icon: Icon(
                  Icons.medication,
                  size: 65,
                ),
                title: "Adicione informações sobre o medicamento",
              ),
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
                        TextButton(
                          onPressed: () => {
                            medicationFrequency = MedicationFrequency.vezesAoDia,
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CreateMedicationStep4Duration(medicationName: medicationName, medicationType: medicationType, medicationFrequency: medicationFrequency)
                              )
                            )
                          }, 
                          child: const Text('X Vezes ao Dia'),
                        ),
                        const Divider(),
                        TextButton(
                          onPressed: () => {
                            medicationFrequency = MedicationFrequency.horas,
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CreateMedicationStep4Duration(medicationName: medicationName, medicationType: medicationType, medicationFrequency: medicationFrequency)
                              )
                            )
                          }, 
                          child: const Text('De X em X Horas'),
                        ),
                        const Divider(),
                        TextButton(
                          onPressed: () => {
                            medicationFrequency = MedicationFrequency.dias,
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CreateMedicationStep4Duration(medicationName: medicationName, medicationType: medicationType, medicationFrequency: medicationFrequency)
                              )
                            )
                          }, 
                          child: const Text('De X em X Dias'),
                        ),
                        const Divider(),
                        TextButton(
                          onPressed: () => {
                            medicationFrequency = MedicationFrequency.meses,
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CreateMedicationStep4Duration(medicationName: medicationName, medicationType: medicationType, medicationFrequency: medicationFrequency)
                              )
                            )
                          }, 
                          child: const Text('De X em X meses'),
                        ),
                        const Divider(),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
