import 'package:flutter/material.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step3_frequency_type.dart';
import 'package:app/views/medicine/create_medication_step8_users.dart';
import 'package:app/views/theme/theme.dart'; // para context.heightPercentage

class CreateMedicationStep7FirstMedication extends StatefulWidget {
  CreateMedicationStep7FirstMedication({
    super.key,
    required this.medicationName,
    required this.medicationType,
    required this.medicationFrequencyType,
    required this.medicationFrequencyValue,
    required this.medicationQuantity,
    required this.medicationDuration,
  });

  final TextEditingController medicationName;
  final MedicationType medicationType;
  final MedicationFrequencyType medicationFrequencyType;
  final TextEditingController medicationFrequencyValue;
  final TextEditingController medicationDuration;
  final TextEditingController medicationQuantity;

  @override
  State<CreateMedicationStep7FirstMedication> createState() =>
      _CreateMedicationStep7FirstMedicationState();
}

class _CreateMedicationStep7FirstMedicationState
    extends State<CreateMedicationStep7FirstMedication> {
  final TextEditingController medicationDate = TextEditingController();
  DateTime? medicationFirstDate;

  void _showAlertDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => Alert(
        title: title,
        message: message,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void _onNextPressed() {
    if (medicationFirstDate == null) {
      _showAlertDialog('Campo Inválido', 'Adicione a data da primeira dose.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateMedicationStep8UserMedication(
          medicationName: widget.medicationName,
          medicationType: widget.medicationType,
          medicationFrequencyType: widget.medicationFrequencyType,
          medicationFrequencyValue: widget.medicationFrequencyValue,
          medicationDuration: widget.medicationDuration,
          medicationQuantity: widget.medicationQuantity,
          medicationFirstDate: medicationFirstDate!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(
        title: 'Data da primeira dose',
        subtitle: 'Qual a data que irá começar o tratamento?',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: (context.heightPercentage(0.05))),
            Container(
              height: context.heightPercentage(0.90) - 200,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      TextField(
                        controller: medicationDate,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Data e Hora da Primeira Dose",
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          final picked = await dateTimePicker(context: context);
                          if (picked != null) {
                            setState(() {
                              medicationFirstDate = picked;
                              medicationDate.text = dateHourFormat(picked); // Função utilitária para formatar
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _onNextPressed,
                      child: const Text('Próximo'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}