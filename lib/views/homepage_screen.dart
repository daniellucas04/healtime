import 'package:app/controllers/medication_controller.dart';
import 'package:app/dao/medication_dao.dart';
import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/medication.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/medicine/edit_medication_view.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

Future<List<Map<String, dynamic>>> getAll(DateTime searchDate) async {
  return MedicationScheduleDao(database: await DatabaseHelper.instance.database)
      .getAll(searchDate);
}

Future<Medication?> getById(int id) async {
  return MedicationDao(database: await DatabaseHelper.instance.database)
      .getById(id);
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> _deleteMedication(Medication medication) async {
    var deletedMedication = MedicationController().delete(medication);

    if (await deletedMedication != 0) {
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

  void _closeAlert(context) {
    if (!context.mounted) return;

    Navigator.pop(context);
  }

  DateTime searchDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(title: 'Seja bem-vindo!'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAll(searchDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            searchDate =
                                searchDate.add(const Duration(days: -1));
                          });
                        },
                        icon: const Icon(
                            Icons.keyboard_double_arrow_left_outlined)),
                    TextButton(
                      onPressed: () async {
                        DateTime? selectedDate = await datePicker(
                            context: context, initialDate: searchDate);
                        setState(() {
                          if (selectedDate != null) {
                            searchDate = selectedDate;
                          }
                        });
                      },
                      child: Text(
                        DateFormat('dd/MM').format(searchDate),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            searchDate =
                                searchDate.add(const Duration(days: 1));
                          });
                        },
                        icon: const Icon(
                            Icons.keyboard_double_arrow_right_outlined))
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                const Center(
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 50,
                        right: 50,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Text(
                        'Nenhum registro encontrado',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final medication = items[index];
              return Column(
                children: [
                  index == 0
                      ? Container(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      searchDate = searchDate
                                          .add(const Duration(days: -1));
                                    });
                                  },
                                  icon: const Icon(Icons
                                      .keyboard_double_arrow_left_outlined)),
                              TextButton(
                                onPressed: () async {
                                  DateTime? selectedDate = await datePicker(
                                      context: context,
                                      initialDate: searchDate);
                                  setState(() {
                                    if (selectedDate != null) {
                                      searchDate = selectedDate;
                                    }
                                  });
                                },
                                child: Text(
                                  DateFormat('dd/MM').format(searchDate),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      searchDate = searchDate
                                          .add(const Duration(days: 1));
                                    });
                                  },
                                  icon: const Icon(Icons
                                      .keyboard_double_arrow_right_outlined))
                            ],
                          ))
                      : const SizedBox(
                          height: 1,
                          width: 1,
                        ),
                  Card(
                    shadowColor: Colors.black87,
                    elevation: 8,
                    margin: const EdgeInsets.all(12),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [
                              accentLightTheme,
                              Color.fromARGB(255, 8, 50, 150),
                            ],
                            begin: AlignmentGeometry.bottomLeft,
                            end: AlignmentGeometry.topRight,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: Colors.blue.withAlpha(100),
                            onTap: () async {
                              int medicationId = medication['medication_id'];
                              Medication? editMedication =
                                  await getById(medicationId);
                              if (!context.mounted) return;

                              if (editMedication != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditMedication(
                                        medication: editMedication),
                                  ),
                                );
                              }
                            },
                            onLongPress: () async {
                              final navigator = Navigator.of(context);
                              var authenticated = await _authenticate();

                              if (!context.mounted) return;
                              if (authenticated) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) => Alert(
                                    title:
                                        'O medicamento ${medication['name']} será removido!',
                                    message:
                                        'Tem certeza que deseja realizar esta ação?',
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            navigator.pop();
                                          },
                                          child: const Text('Cancelar')),
                                      TextButton(
                                        onPressed: () async {
                                          int medicationId =
                                              medication['medication_id'];
                                          Medication? editMedication =
                                              await getById(medicationId);
                                          if (editMedication != null) {
                                            if (await _deleteMedication(
                                                editMedication)) {
                                              navigator.pushNamed('/');
                                            }
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
                                      content: Text('Falha na autenticação')),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      dense: true,
                                      textColor: Colors.white,
                                      title: Text(
                                        medication['name'].toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${medication['type']}: ${medication['quantity']}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    timeFormat(
                                      DateTime.parse(medication['date']),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: const NavBar(pageIndex: 0,),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 35,
          color: backgroundDarkTheme50,
        ),
        onPressed: () => {
          Navigator.pushNamed(context, '/medicine_registration'),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
