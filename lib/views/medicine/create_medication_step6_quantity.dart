import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step3_frequency_type.dart';
import 'package:app/views/medicine/create_medication_step7_first_medication.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateMedicationStep6Quantity extends StatelessWidget {
  CreateMedicationStep6Quantity({
    super.key,
    required this.medicationName,
    required this.medicationType,
    required this.medicationFrequencyType,
    required this.medicationFrequencyValue,
    required this.medicationDuration,
  });

  final TextEditingController medicationName;
  final MedicationType medicationType;
  final MedicationFrequencyType medicationFrequencyType;
  final TextEditingController medicationFrequencyValue;
  final TextEditingController medicationDuration;
  final TextEditingController medicationQuantity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(
        title: 'Quantidade',
        subtitle: 'Quantas unidades do medicamento possui?',
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
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: medicationQuantity,
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
                      Text(
                        medicationType == MedicationType.comprimido
                            ? 'Comprimidos'
                            : medicationType == MedicationType.gotas
                                ? 'Gotas'
                                : medicationType == MedicationType.liquido
                                    ? 'Ml'
                                    : 'Quantidade',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (medicationQuantity.text != "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateMedicationStep7FirstMedication(
                                      medicationName: medicationName,
                                      medicationType: medicationType,
                                      medicationFrequencyType:
                                          medicationFrequencyType,
                                      medicationFrequencyValue:
                                          medicationFrequencyValue,
                                      medicationDuration: medicationDuration,
                                      medicationQuantity: medicationQuantity),
                            ),
                          );
                        } else {
                          final navigator = Navigator.of(context);
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Alert(
                              message: 'Adicione a quantidade',
                              title: 'Campo Inválido',
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    navigator.pop();
                                  },
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
