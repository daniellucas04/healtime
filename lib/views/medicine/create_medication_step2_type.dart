import 'package:app/views/components/create_header.dart';
import 'package:app/views/medicine/create_medication_step3_frequency.dart';
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
  CreateMedicationStep2Type({super.key, required this.medicationName,});

  final TextEditingController medicationName;
  MedicationType medicationType = MedicationType.comprimido;

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
                height: 440,
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () => {
                            medicationType = MedicationType.comprimido,
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMedicationStep3Frequency(medicationName: medicationName, medicationType: medicationType)))
                          }, 
                          child: const Text('Comprimido'),
                        ),
                        const Divider(),
                        TextButton(
                          onPressed: () => {
                            medicationType = MedicationType.injecao,
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMedicationStep3Frequency(medicationName: medicationName, medicationType: medicationType)))
                          }, 
                          child: const Text('Injeção'),
                        ),
                        const Divider(),
                        TextButton(
                          onPressed: () => {
                            medicationType = MedicationType.gotas,
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMedicationStep3Frequency(medicationName: medicationName, medicationType: medicationType)))
                          }, 
                          child: const Text('Gotas'),
                        ),
                        const Divider(),
                        TextButton(
                          onPressed: () => {
                            medicationType = MedicationType.pomada,
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMedicationStep3Frequency(medicationName: medicationName, medicationType: medicationType)))
                          }, 
                          child: const Text('Pomada'),
                        ),
                        const Divider(),
                        TextButton(
                          onPressed: () => {
                            medicationType = MedicationType.inalador,
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMedicationStep3Frequency(medicationName: medicationName, medicationType: medicationType)))
                          }, 
                          child: const Text('Inalador'),
                        ),
                        const Divider(),
                        TextButton(
                          onPressed: () => {
                            medicationType = MedicationType.liquido,
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMedicationStep3Frequency(medicationName: medicationName, medicationType: medicationType)))
                          }, 
                          child: const Text('Liquido'),
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
