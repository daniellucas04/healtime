import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/user.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/people/edit_people_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      appBar: const Header(
        title: 'Pessoas',
      ),
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
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Card(
                  shadowColor: Colors.black45,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(width: 1, color: Colors.blue.shade800),
                  ),
                  child: InkWell(
                    highlightColor: Colors.blue.withAlpha(100),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        highlightColor: Colors.blue.withAlpha(100),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPeople(
                              people: user,
                              userLenght: users.length,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  textColor: Colors.white,
                                  title: Text(
                                    user.name[0].toUpperCase() +
                                        user.name.substring(1),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Nascimento: ${DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(user.birthDate),
                                    )}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
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
        ),
        onPressed: () async {
          await Navigator.pushNamed(context, '/create_people');
          setState(() {
            _loadUsers();
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
