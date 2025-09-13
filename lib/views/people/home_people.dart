
import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/user.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<List<User>> getAll() async {
  return UserDao(database: await DatabaseHelper.instance.database)
      .getAll();
}

class HomePeople extends StatelessWidget {
  const HomePeople({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(title: 'Seja bem-vindo!'),
      body: FutureBuilder<List<User>>(
        future: getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
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
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 50,
                          right: 50,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          'Nenhum usuário cadastrado',
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
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final user = items[index];
              return Card(
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
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            dense: true,
                            textColor: Colors.white,
                            title: Text(
                              user.name.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const NavBar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 35,
          color: backgroundDarkTheme50,
        ),
        onPressed: () => {
          Navigator.pushNamed(context, '/create_people'),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
