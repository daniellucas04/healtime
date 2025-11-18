import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/form_input.dart';
import 'package:app/views/people/create_people_step2_date.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

class CreatePeopleStep1Name extends StatelessWidget {
  CreatePeopleStep1Name({
    super.key,
  });

  final TextEditingController peopleName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(
        title: "Nome",
        subtitle: 'Qual o nome da pessoa?',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    spacing: 36,
                    children: [
                      FormInput(
                        controller: peopleName,
                        key: const Key('people_name'),
                        label: 'Nome',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (peopleName.text != "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreatePeopleStep2Date(
                                peopleName: peopleName,
                                controlerDate: TextEditingController(),
                              ),
                            ),
                          );
                        } else {
                          final navigator = Navigator.of(context);
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Alert(
                              content: const Text('Digite o seu nome'),
                              title: 'Campo Inválido',
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    navigator.pop();
                                  },
                                  child: const Text('Cancelar'),
                                ),
                              ],
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
