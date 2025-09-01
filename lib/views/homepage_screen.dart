import 'package:app/dao/medication_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/medication.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:flutter/material.dart';

Future<List<Medication>> getAll () async {
  return MedicationDao(database: await DatabaseHelper.instance.database).getAll();
}

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Listagem'),
      ),
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
            return const Center(child: Text('Nenhum registro encontrado'));
          }
          return Scaffold(
            body: ListView.builder(
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
                            leading: const Icon(Icons.medication,size: 35,),
                            title: Text(medication.name),
                            subtitle: Text('${medication.type}: ${medication.quantity}'),
                          ),
                        ),
                        Text(timeFormat(DateTime.parse(medication.firstMedication))),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const NavBar(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 35),
        onPressed: () =>
            {Navigator.pushNamed(context, '/medicine_registration')},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
