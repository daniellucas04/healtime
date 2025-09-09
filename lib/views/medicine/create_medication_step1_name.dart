import 'package:app/helpers/screen_size.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/form_input.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

class CreateMedicationStep1Name extends StatelessWidget {
  CreateMedicationStep1Name({
    super.key,
  });

  final TextEditingController medicationName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(
        title: "Nome do medicamento",
        subtitle: 'Qual o nome do medicamento?',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: (context.heightPercentage(0.05)),
            ),
            Container(
              height: (context.heightPercentage(0.95) - 200),
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 36,
                    children: [
                      FormInput(
                        controller: medicationName,
                        key: const Key('medication_name'),
                        label: 'Nome',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (medicationName.text != "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateMedicationStep2Type(
                                medicationName: medicationName,
                              ),
                            ),
                          );
                        } else {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Alert(
                              message: 'Digite o nome do medicamento',
                              title: 'Campo Inválido',
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Próximo',
                      ),
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
