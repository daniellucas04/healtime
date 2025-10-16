import 'package:app/controllers/user_controller.dart';
import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/user.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CreatePeopleStep2Date extends StatelessWidget {
  CreatePeopleStep2Date({
    super.key,
    required this.peopleName,
    this.peopleDate,
    required this.controlerDate,
  });

  final TextEditingController peopleName;
  final TextEditingController controlerDate;
  DateTime? peopleDate;

  Future<void> saveMedication(context) async {
    if (!context.mounted) return;

    var users = await UserDao(database: await DatabaseHelper.instance.database)
        .getAll();

    var insertedUser = UserController().save(User(
        name: peopleName.text,
        birthDate: peopleDate.toString(),
        active: users.isEmpty ? 1 : 0));

    if (await insertedUser != 0) {
      if (users.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/homepage', (route) => false);
        return;
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/people', (route) => false);
        return;
      }
    }

    final navigator = Navigator.of(context);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Alert(
        message: 'Ocorreu um erro ao cadastrar o usuário',
        title: 'Erro ao Cadastrar',
        actions: [
          TextButton(
              onPressed: () {
                navigator.pop();
              },
              child: const Text('ok'))
        ],
      ),
    );

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Alert(
        message: 'Adicione a data',
        title: 'Campo Inválido',
        actions: [
          TextButton(
              onPressed: () {
                navigator.pop();
              },
              child: const Text('ok'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(
        title: 'Data de nascimento',
        subtitle: 'Qual é a data de nascimento?',
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    children: [
                      TextField(
                        controller: controlerDate,
                        readOnly: true, // Impede digitação manual
                        decoration: const InputDecoration(
                          labelText: "Data de nascimento",
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (selectedDate != null) {
                            controlerDate.text =
                                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";

                            peopleDate = selectedDate;
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        saveMedication(context);
                      },
                      child: const Text('Finalizar'),
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
