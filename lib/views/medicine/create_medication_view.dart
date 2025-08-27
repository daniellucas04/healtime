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
                  const Column(
                    spacing: 36,
                    children: [
                      FormInput(
                        key: Key('medication_name'),
                        icon: Icon(
                          Icons.search,
                        ),
                        label: 'Nome',
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownMenu(
                          width: double.infinity,
                          label: Text(
                            'Tipo',
                          ),
                          initialSelection: MedicationType.comprimido,
                          dropdownMenuEntries: <DropdownMenuEntry<
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
