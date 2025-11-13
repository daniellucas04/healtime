import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:app/controllers/user_medication_controller.dart';
import 'package:app/helpers/session.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/components/sidebar.dart';
import 'package:app/views/theme/theme.dart';
import 'package:quiver/iterables.dart';

Future<List<Map<String, dynamic>>> getByUserMedication(int userId) async {
  List<Map<String, dynamic>> result =
      await UserMedicationController().getUserFromMedication(userId);
  return result;
}

Future<List<Map<String, dynamic>>> getAllById(int medicationId) async {
  List<Map<String, dynamic>> result = await MedicationScheduleDao(
          database: await DatabaseHelper.instance.database)
      .getAllById(medicationId);
  return result;
}

Future<List<Map<String, dynamic>>> getAll(int userId) async {
  return MedicationScheduleDao(database: await DatabaseHelper.instance.database)
      .count(userId);
}

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  bool isSwitched = false;
  int? selectedUserId;

  Future<void> loadUser() async {
    int activeUserId = await Session.getActiveUser();
    setState(() {
      selectedUserId = activeUserId;
    });
  }

  _medicationInformation(int id) async {
    List<Map<String, dynamic>> medicationDetails = await getAllById(id);
    DateTime? next;
    int counter = 0;

    medicationDetails.forEach((med) {
      if (DateTime.parse(med['date']).isAfter(DateTime.now()) && counter == 0) {
        next = DateTime.parse(med['date']);
        counter++;
      }
    });
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Row(
          children: [
            Icon(Icons.content_paste, size: 32),
            SizedBox(width: 10),
            Text(
              'Detalhes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                'Inicio: ${dateFormat(DateTime.parse(medicationDetails.first['date']))}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Fim: ${dateFormat(DateTime.parse(medicationDetails.last['date']))}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              medicationDetails.last['status'] != 'Pendente'
                  ? const Text('Todas as doses já foram tomadas')
                  : Text('Próxima dose a ser tomada: ${dateHourFormat(next!)}')
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Confirmar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    return Scaffold(
      endDrawer: Sidebar(
        onUserSelected: (userId) {
          setState(() {
            selectedUserId = userId;
          });
        },
        userId: selectedUserId ?? 1,
      ),
      resizeToAvoidBottomInset: false,
      appBar: Header(title: 'Relátorio'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    minRadius: 30,
                    maxRadius: 50,
                    backgroundColor: currentTheme.brightness == Brightness.dark
                        ? secondaryDarkTheme
                        : secondaryLightTheme,
                    child: const Icon(
                      Icons.people,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Usuário",
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Medicamentos Tomados",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              FutureBuilder(
                future: getByUserMedication(selectedUserId ?? 1),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }

                  final items = snapshot.data ?? [];

                  if (items.isEmpty) {
                    return const Center(
                        child: Text('Nenhum medicamento encontrado.'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final medication = items[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                            leading: Icon(
                              Icons.medical_services,
                              color: currentTheme.primaryColor,
                              size: 40,
                            ),
                            title: Text(
                              medication['name'].toString().toUpperCase(),
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              "Dose consumida: ${medication['quantity'] ?? 'Indefinido'} ${medication['type'] ?? 'Indefinido'}",
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 20),
                            onTap: () => _medicationInformation(
                                medication['medication_id'])),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 15),
              Text(
                "Medicamentos Tomados no Horário",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              FutureBuilder(
                future: getAll(selectedUserId ?? 1),
                builder: (context, snapshot) {
                  var status = [];
                  var quantidade = [];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }

                  final items = snapshot.data ?? [];

                  if (items.isEmpty) {
                    return const Center(
                        child: Text('Nenhum medicamento encontrado.'));
                  }

                  if (items.isNotEmpty) {
                    try {
                      items.forEach((i) {
                        status.add(i['status']);
                        quantidade.add(i['status_count']);
                      });
                      print(status);
                      print(quantidade);
                    } catch (e) {}
                  }

                  List<Widget> combinedWidgets = [];
                  for (int i = 0; i < status.length; i++) {
                    combinedWidgets.add(
                      Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            '${status[i]}: ${quantidade[i]}', // Combine status and quantidade
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true, // Faz o ListView se ajustar ao conteúdo
                    itemCount: status.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        color: status[index] == "Atrasado"
                            ? Colors.amber
                            : status[index] == "Esquecido"
                                ? Colors.red
                                : status[index] == "Pendente"
                                    ? Colors.lightBlue
                                    : Colors.greenAccent,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            '${status[index]}: ${quantidade[index]}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(pageIndex: 1),
    );
  }
}
