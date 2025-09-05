import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step3_frequency_type.dart';
import 'package:app/views/medicine/create_medication_step6_quantity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateMedicationStep5Duration extends StatelessWidget {
  CreateMedicationStep5Duration({
    super.key,
    required this.medicationName,
    required this.medicationType,
    required this.medicationFrequencyType,
    required this.medicationDuration,
  });

  final TextEditingController medicationName;
  final MedicationType medicationType;
  final MedicationFrequencyType medicationFrequencyType;
  final TextEditingController medicationDuration;
  final TextEditingController medicationFrequencyValue =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(
        title: 'Duração do tratamento',
        subtitle: 'Quantos dias o tratamento irá durar?',
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text('Total'),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: medicationDuration,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2)
                          ],
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                      ),
                      const Text('Dias'),
                    ],
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (medicationDuration.text != "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateMedicationStep6Quantity(
                                medicationName: medicationName,
                                medicationType: medicationType,
                                medicationFrequencyType:
                                    medicationFrequencyType,
                                medicationFrequencyValue:
                                    medicationFrequencyValue,
                                medicationDuration: medicationDuration,
                              ),
                            ),
                          );
                        } else {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Alert(
                              message: 'Adicione o intervalo de tempo',
                              title: 'Campo Inválido',
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
      )),
    );
  }
}
