import 'package:app/controllers/user_controller.dart';
import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/user.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/people/edit_people_view.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class HomePeople extends StatefulWidget {
  const HomePeople({super.key});

  @override
  State<HomePeople> createState() => _HomePeopleState();
}

class _HomePeopleState extends State<HomePeople> {
  late Future<List<User>> _userList;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    _userList = _getUsersWithDefault();
  }

  Future<List<User>> _getUsersWithDefault() async {
    var users = await UserDao(database: await DatabaseHelper.instance.database)
        .getAll();

    if (users.isEmpty) {
      UserDao(database: await DatabaseHelper.instance.database).insert(User(
          name: 'Você', birthDate: DateTime(2000, 1, 1).toString(), active: 1));
    }

    users = await UserDao(database: await DatabaseHelper.instance.database)
        .getAll();

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(title: 'Seja bem-vindo!'),
      body: FutureBuilder<List<User>>(
        future: _userList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final users = snapshot.data ?? [];

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
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
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.blue.withAlpha(100),
                      onTap: () async {},
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor: Colors.blue.withAlpha(100),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditPeople(
                                      people: user, userLenght: users.length))),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    dense: true,
                                    textColor: Colors.white,
                                    title: Text(
                                      user.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(user.birthDate)),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const NavBar(pageIndex: 2),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 35,
          color: backgroundDarkTheme50,
        ),
        onPressed: () async {
          // Aguarda o cadastro e recarrega a lista
          await Navigator.pushNamed(context, '/create_people');
          setState(() {
            _loadUsers(); // Recarrega a lista ao voltar
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
