import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step3_frequency_type.dart';
import 'package:app/views/medicine/create_medication_step7_first_medication.dart';
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
                      const Text('Total'),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: medicationQuantity,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2)
                          ],
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                            ),
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
                      Text(medicationType == MedicationType.comprimido
                          ? 'Comprimidos'
                          : medicationType == MedicationType.gotas
                              ? 'Gotas'
                              : medicationType == MedicationType.liquido
                                  ? 'Ml'
                                  : 'Quantidade')
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
                                          medicationDuration:
                                              medicationDuration,
                                          medicationQuantity:
                                              medicationQuantity)));
                        } else {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Alert(
                              message: 'Adicione a quantidade',
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
