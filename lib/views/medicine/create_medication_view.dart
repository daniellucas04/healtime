import 'package:app/views/components/create_header.dart';
import 'package:app/views/components/form_input.dart';
import 'package:flutter/material.dart';

class CreateMedicationScreen extends StatelessWidget {
  const CreateMedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const CreateHeader(
              icon: const Icon(
                Icons.medication,
                size: 65,
                color: Colors.white,
              ),
              title: "Qual medicamento gostaria de adicionar?",
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              height: 520,
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const FormInput(
                    key: Key('medication_name'),
                    icon: Icon(
                      Icons.search,
                      color: Colors.black87,
                    ),
                    label: 'Nome do medicamento',
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(Colors.blue),
                        foregroundColor:
                            WidgetStatePropertyAll<Color>(Colors.white),
                      ),
                      onPressed: () {
                        print('Proxima tela de cadastro');
                      },
                      child: const Text(
                        'Próximo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
