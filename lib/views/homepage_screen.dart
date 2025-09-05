import 'package:app/dao/medication_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/medication.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<List<Medication>> getAll() async {
  return MedicationDao(database: await DatabaseHelper.instance.database)
      .getAll();
}

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(title: 'Seja bem-vindo!'),
      body: FutureBuilder<List<Medication>>(
        future: getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final dados = snapshot.data ?? [];
          if (dados.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      DateFormat('dd/MM').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Center(
                    child: Card(
                      elevation: 0,
                      color: backgroundDarkTheme100,
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
              body: Column(
            children: [
              Text(''),
              ListView.builder(
                itemCount: dados.length,
                itemBuilder: (context, index) {
                  final medication = dados[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: const Icon(
                                Icons.medication,
                                size: 35,
                              ),
                              title: Text(medication.name),
                              subtitle: Text(
                                  '${medication.type}: ${medication.quantity}'),
                            ),
                          ),
                          Text(
                            timeFormat(
                              DateTime.parse(medication.firstMedication),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ));
        },
      ),
      bottomNavigationBar: const NavBar(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 35),
        onPressed: () => {
          Navigator.pushNamed(context, '/medicine_registration'),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
