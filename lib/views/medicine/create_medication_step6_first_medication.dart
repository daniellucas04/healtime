import 'package:app/views/components/alert.dart';
import 'package:app/views/components/create_header.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step3_frequency.dart';
import 'package:flutter/material.dart';


class CreateMedicationStep6FirstMedication extends StatelessWidget {
  CreateMedicationStep6FirstMedication({super.key, required this.medicationName, required this.medicationType, required this.medicationFrequency, required this.medicationDuration, required this.medicationQuantity,});

  final TextEditingController medicationName;
  final MedicationType medicationType;
  final MedicationFrequency medicationFrequency;
  final TextEditingController medicationDuration;
  final TextEditingController medicationQuantity;
  final TextEditingController medicationDate = TextEditingController();
  final TextEditingController medicationTime = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    TimeOfDay hour = TimeOfDay.now();
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
                        TextField(
                          controller: medicationDate,
                          readOnly: true, // Impede digitação manual
                          decoration: const InputDecoration(
                            labelText: "Data e Hora",
                            hintText: "Selecione...",
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async => {
                            date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            ) as DateTime,
                            medicationDate.text = date.toString(),
                            print(date)
                            
                          },
                        ),
                        TextField(
                          controller: medicationTime,
                          readOnly: true, // Impede digitação manual
                          decoration: const InputDecoration(
                            labelText: "Data e Hora",
                            hintText: "Selecione...",
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async =>  {
                            hour = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ) as TimeOfDay,
                            medicationTime.text = hour.toString(),
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if(medicationDuration.text != ""){
                            date = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              hour.hour,
                              hour.minute
                            );
                            print(date);
                          }else{
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false, // user must tap button!
                              builder: (context) => const Alert(
                                message: 'Teste',
                                title: 'title',
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
