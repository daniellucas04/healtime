import 'package:app/views/components/create_header.dart';
import 'package:app/views/components/form_input.dart';
import 'package:flutter/material.dart';

enum MedicationType {
  comprimido,
  injecao,
  gotas,
  pomada,
  inalador,
  liquido,
}

class CreateMedicationScreen extends StatelessWidget {
  const CreateMedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const CreateHeader(
              icon: Icon(
                Icons.medication,
                size: 65,
                color: Colors.white,
              ),
              title: "Adicione informações sobre o medicamentoaaaaaaaaaa",
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
                  Column(
                    spacing: 36,
                    children: [
                      const FormInput(
                        key: Key('medication_name'),
                        icon: Icon(
                          Icons.search,
                          color: Colors.black87,
                        ),
                        label: 'Nome',
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownMenu(
                          width: double.infinity,
                          label: const Text(
                            'Tipo',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          initialSelection: MedicationType.comprimido,
                          inputDecorationTheme: InputDecorationTheme(
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black26, width: 2.0),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black12, width: 2.0),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          dropdownMenuEntries: const <DropdownMenuEntry<
                              MedicationType>>[
                            DropdownMenuEntry(
                              value: MedicationType.comprimido,
                              label: 'Comprimido',
                            ),
                            DropdownMenuEntry(
                              value: MedicationType.injecao,
                              label: 'Injeção',
                            ),
                            DropdownMenuEntry(
                              value: MedicationType.gotas,
                              label: 'Gotas',
                            ),
                            DropdownMenuEntry(
                              value: MedicationType.pomada,
                              label: 'Pomada',
                            ),
                            DropdownMenuEntry(
                              value: MedicationType.inalador,
                              label: 'Inalador',
                            ),
                            DropdownMenuEntry(
                              value: MedicationType.liquido,
                              label: 'Líquido',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Proxima tela de cadastro');
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
