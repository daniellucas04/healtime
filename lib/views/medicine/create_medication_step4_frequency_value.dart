import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/max_value_input_formatter.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step3_frequency_type.dart';
import 'package:app/views/medicine/create_medication_step5_duration.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateMedicationStep4FrequencyValue extends StatelessWidget {
  CreateMedicationStep4FrequencyValue({
    super.key,
    required this.medicationName,
    required this.medicationType,
    required this.medicationFrequencyType,
  });

  final TextEditingController medicationName;
  final MedicationType medicationType;
  final MedicationFrequencyType medicationFrequencyType;
  final TextEditingController medicationFrequencyValue =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(
        title: 'Intervalo entre as doses',
        subtitle: 'Em que intervalo irá tomar as doses?',
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
                      const Text(
                        'A Cada',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: medicationFrequencyValue,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                            (medicationFrequencyType ==
                                        MedicationFrequencyType.vezesAoDia ||
                                    medicationFrequencyType ==
                                        MedicationFrequencyType.horas)
                                ? MaxValueInputFormatter(23)
                                : medicationFrequencyType ==
                                        MedicationFrequencyType.dias
                                    ? MaxValueInputFormatter(6)
                                    : MaxValueInputFormatter(99)
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
                      Text(
                        medicationFrequencyType ==
                                MedicationFrequencyType.vezesAoDia
                            ? "vezes ao dia"
                            : medicationFrequencyType.name,
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (medicationFrequencyValue.text != "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateMedicationStep5Duration(
                                medicationName: medicationName,
                                medicationType: medicationType,
                                medicationFrequencyType:
                                    medicationFrequencyType,
                                medicationFrequencyValue:
                                    medicationFrequencyValue,
                              ),
                            ),
                          );
                        } else {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Alert(
                              message: 'Adicione o intervalo de tempo',
                              title: 'Campo Inválido',
                              actions: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text('OK'),
                                )
                              ],
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
      ),
    );
  }
}
