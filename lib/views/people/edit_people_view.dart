import 'package:app/controllers/user_controller.dart';
import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/helpers/user_validation.dart';
import 'package:app/models/user.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/form_input.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class EditPeople extends StatefulWidget {
  const EditPeople({super.key, required this.people, required this.userLenght});

  final User people;
  final int userLenght;
  @override
  State<StatefulWidget> createState() => _EditPeopleState();
}

class _EditPeopleState extends State<EditPeople> {
  late int? peopleId;
  late String peopleName;
  late DateTime? peopleBirthDate;
  late int peopleActive;
  late TextEditingController nameInputController;
  late TextEditingController birthDateController;

  final LocalAuthentication _localAuth = LocalAuthentication();

  late bool peopleDefault;

  Future<bool> _deleteUser(context) async {
    var deletedUser = UserController().delete(User(
        name: peopleName,
        birthDate: peopleBirthDate.toString(),
        id: peopleId,
        active: peopleActive));

    if (await deletedUser != 0) {
      return true;
    }

    return false;
  }

  Future<bool> _authenticate() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;

      if (!canCheckBiometrics) {
        return false;
      }

      bool authenticated = await _localAuth.authenticate(
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            biometricSuccess: 'Autenticação realizada com sucesso!',
            signInTitle: 'Autenticação',
            biometricHint: '',
          ),
          IOSAuthMessages(),
        ],
        localizedReason: 'Realize a autenticação para liberar este recurso',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      return authenticated;
    } catch (e) {
      print('Erro na autenticação: $e');
      return false;
    }
  }

  Future<void> updatePeople(context) async {
    if (!context.mounted) return;

    final navigator = Navigator.of(context);

    User user = User(
      id: peopleId,
      name: nameInputController.text,
      birthDate: peopleBirthDate.toString(),
      active: peopleDefault ? 1 : 0,
    );

    UserValidation validations = UserValidation(user: user);

    if (validations.validate()) {
      if (peopleDefault) {
        var users =
            await UserDao(database: await DatabaseHelper.instance.database)
                .getAll();
        for (var user in users) {
          if (user.active == 1) {
            UserController().update(User(
                id: user.id,
                name: user.name,
                birthDate: user.birthDate,
                active: 0));
          }
        }
      }
      var updatePeople = UserController().update(user);

      if (await updatePeople != 0) {
        Navigator.pushNamedAndRemoveUntil(context, '/people', (route) => false);
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Alert(
          title: 'Erro ao Atualizar',
          message: 'Ocorreu um erro ao atualizar o usuário',
          actions: [
            TextButton(
              onPressed: () {
                navigator.pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Alert(
          message: 'Dados inválidos',
          title: 'Preencha os dados corretamente',
          actions: [
            TextButton(
              onPressed: () {
                navigator.pop();
              },
              child: const Text('OK'),
            )
          ]),
    );
  }

  @override
  void initState() {
    super.initState();
    peopleId = widget.people.id;
    peopleName = widget.people.name;
    peopleBirthDate = DateTime.tryParse(widget.people.birthDate);
    peopleActive = widget.people.active;

    nameInputController = TextEditingController(text: peopleName);
    birthDateController =
        TextEditingController(text: dateFormat(peopleBirthDate!));

    peopleDefault = peopleActive == 1;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    return Scaffold(
      appBar: Header(
        title: peopleName.toUpperCase(),
        subtitle: 'Edite as informações do usuário',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              spacing: context.heightPercentage(0.03),
              children: [
                const SizedBox(
                  height: 2.0,
                ),
                FormInput(
                    label: 'Nome do usuário', controller: nameInputController),
                TextField(
                  controller: birthDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Data Nascimento',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async => {
                    peopleBirthDate = await datePicker(
                        context: context,
                        initialDate: peopleBirthDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now()),
                    if (peopleBirthDate != null)
                      {
                        birthDateController.text = dateFormat(peopleBirthDate!),
                      }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Usuário Padrão',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Switch(
                      activeThumbColor:
                          currentTheme.brightness == Brightness.dark
                              ? secondaryDarkTheme
                              : accentLightTheme,
                      onChanged: peopleActive == 1
                          ? null
                          : (value) {
                              setState(() {
                                peopleDefault = value;
                              });
                            },
                      value: peopleDefault,
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      updatePeople(context);
                    },
                    child: const Text('Editar'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      var authenticate = await _authenticate();

                      if (!context.mounted) return;

                      if (widget.userLenght < 2) {
                        showDialog(
                            context: context,
                            builder: (context) => Alert(
                                    title: 'Último Usuário',
                                    message:
                                        'Deve haver pelo menos um usuário criado',
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          navigator.pop();
                                        },
                                        child: const Text('OK'),
                                      )
                                    ]));
                        return;
                      }

                      if (peopleActive == 1) {
                        showDialog(
                            context: context,
                            builder: (context) => Alert(
                                    title: 'Usuário Padrão',
                                    message:
                                        'O usuário padrão não pode ser excluído',
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          navigator.pop();
                                        },
                                        child: const Text('OK'),
                                      )
                                    ]));
                        return;
                      }

                      if (authenticate) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Alert(
                            title: 'O Usuario $peopleName será removido!',
                            message:
                                'Tem certeza que deseja realizar esta ação?',
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  navigator.pop();
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (await _deleteUser(context)) {
                                    navigator.pushNamed('/people');
                                  }
                                },
                                child: const Text('Confirmar'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Falha na Autenticação')));
                      }
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.redAccent)),
                    child: const Text('Excluir'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
