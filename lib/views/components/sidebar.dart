import 'package:app/providers/theme_provider.dart';
import 'package:app/views/backup/backup_view.dart';
import 'package:app/views/theme/theme.dart';
import 'package:app/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/user.dart';
import 'package:app/dao/user_dao.dart';

class Sidebar extends StatefulWidget {
  final Function(int? userId) onUserSelected;
  final int userId;

  const Sidebar(
      {super.key, required this.onUserSelected, required this.userId});

  @override
  State<Sidebar> createState() => _SidebarState();
}

Future<List<User>> _getUsersWithDefault() async {
  var users =
      await UserDao(database: await DatabaseHelper.instance.database).getAll();

  if (users.isEmpty) {
    UserDao(database: await DatabaseHelper.instance.database).insert(User(
        name: 'Você', birthDate: DateTime(2000, 1, 1).toString(), active: 1));
  }

  users =
      await UserDao(database: await DatabaseHelper.instance.database).getAll();

  return users;
}

class _SidebarState extends State<Sidebar> {
  bool isSwitched = false;
  late bool hasSystemTheme;
  late String userName = '';

  Future<void> _getUserName(int? id) async {
    var users = await UserDao(database: await DatabaseHelper.instance.database)
        .getById(id ?? widget.userId);
    setState(() {
      userName = users!.name;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserName(null);
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    hasSystemTheme = provider.isSystemThemeActive;
    isSwitched = hasSystemTheme ? true : provider.themeMode == ThemeMode.dark;
  }

  @override
  Drawer build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryDarkTheme, secondaryDarkTheme],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  minRadius: 20,
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
                Text(
                  userName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tema escuro',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Switch(
                    activeThumbColor: currentTheme.brightness == Brightness.dark
                        ? secondaryDarkTheme
                        : accentLightTheme,
                    onChanged: (hasSystemTheme)
                        ? null
                        : (value) {
                            setState(() {
                              isSwitched = value;
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .toggleTheme();
                            });
                          },
                    value: isSwitched,
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          FutureBuilder<List<User>>(
            future: _getUsersWithDefault(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar usuários'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhum usuário encontrado'));
              }

              var users = snapshot.data!;
              return Column(
                children: users.map((user) {
                  return ListTile(
                    title: Text(
                        user.name[0].toUpperCase() + user.name.substring(1)),
                    onTap: () {
                      widget.onUserSelected(user.id);
                      _getUserName(user.id);
                    },
                  );
                }).toList(),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    style: ButtonStyle(
                      iconColor:
                          const WidgetStatePropertyAll(Colors.orangeAccent),
                      iconSize: const WidgetStatePropertyAll(20),
                      backgroundColor: WidgetStatePropertyAll(
                          currentTheme.brightness == Brightness.dark
                              ? secondaryDarkTheme
                              : accentLightTheme),
                      textStyle: const WidgetStatePropertyAll(
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/backup');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Text('Backup'),
                        Icon(
                          Icons.cloud_upload,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140);
}
