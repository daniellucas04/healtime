import 'package:app/views/components/alert.dart';
import 'package:app/views/components/create_header.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step3_frequency_type.dart';
import 'package:app/views/medicine/create_medication_step5_frequency_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateMedicationStep4Duration extends StatelessWidget {
  CreateMedicationStep4Duration({
    super.key,
    required this.medicationName,
    required this.medicationType,
    required this.medicationFrequencyType,
  });

  final TextEditingController medicationName;
  final MedicationType medicationType;
  final MedicationFrequencyType medicationFrequencyType;
  final TextEditingController medicationDuration = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'olá 4'),
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
                    children: [
                      const Text('A Cada'),
                      SizedBox(
                        width: 50,
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
                              borderRadius: BorderRadius.zero,
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                      ),
                      Text(medicationFrequencyType ==
                              MedicationFrequencyType.vezesAoDia
                          ? "vezes ao dia"
                          : medicationFrequencyType.name)
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
                                      CreateMedicationStep5FrequencyValue(
                                          medicationName: medicationName,
                                          medicationType: medicationType,
                                          medicationFrequencyType:
                                              medicationFrequencyType,
                                          medicationDuration:
                                              medicationDuration)));
                        } else {
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
      )),
    );
  }
}
