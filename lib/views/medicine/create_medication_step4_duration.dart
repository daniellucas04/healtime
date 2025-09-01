import 'package:app/views/components/alert.dart';
import 'package:app/views/components/create_header.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step3_frequency.dart';
import 'package:app/views/medicine/create_medication_step5_quantity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CreateMedicationStep4Duration extends StatelessWidget {
  CreateMedicationStep4Duration({super.key, required this.medicationName, required this.medicationType, required this.medicationFrequency,});

  final TextEditingController medicationName;
  final MedicationType medicationType;
  final MedicationFrequency medicationFrequency;
  final TextEditingController medicationDuration = TextEditingController();

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
                      children: [
                        const Text('A Cada'),
                        TextField(
                          controller: medicationDuration,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly 
                          ],
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Colors.grey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                            ),
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                        Text(medicationFrequency == MedicationFrequency.vezesAoDia ? "Vezes ao dia" : medicationFrequency.name)
                      ],
                    ),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if(medicationDuration.text != ""){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CreateMedicationStep5Quantity(medicationName: medicationName, medicationType: medicationType, medicationFrequency: medicationFrequency, medicationDuration: medicationDuration)));
                          }else{
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Alert(
                                message: 'Adicione o intervalo de tempo',
                                title: 'Campo Invalido',
                              ),
                            );
                          }
                        },
                        child: const Text('Próximo'),
                      ),
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
