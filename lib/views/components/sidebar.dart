import 'package:app/providers/theme_provider.dart';
import 'package:app/views/theme/theme.dart';
import 'package:app/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/user.dart';
import 'package:app/dao/user_dao.dart';

class Sidebar extends StatefulWidget {
  final Function(int? userId) onUserSelected;
  final int userId; // Callback para passar o userId

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

  Future<void> _getUserName() async {
    var users = await UserDao(database: await DatabaseHelper.instance.database)
        .getById(widget.userId);
    setState(() {
      userName = users!.name;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    isSwitched = (provider.isSystemThemeActive)
        ? true
        : provider.themeMode == ThemeMode.dark;
    hasSystemTheme = provider.isSystemThemeActive;
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
                Text(userName),
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
                    onChanged: (!hasSystemTheme)
                        ? (value) {
                            setState(() {
                              isSwitched = value;
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .toggleTheme();
                            });
                          }
                        : null,
                    value: !isSwitched,
                  ),
                ],
              ),
            ),
          ),
          const Divider(),

          // FutureBuilder para carregar os usuários do banco de dados
          FutureBuilder<List<User>>(
            future: _getUsersWithDefault(), // método para obter usuários
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

              // ListView para exibir os usuários
              var users = snapshot.data!;
              return Column(
                children: users.map((user) {
                  return ListTile(
                    title: Text(user.name),
                    onTap: () {
                      widget.onUserSelected(user.id);
                      //Navigator.pop(context);
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
                Center(
                  child: TextButton(
                    style: ButtonStyle(
                      iconColor:
                          const WidgetStatePropertyAll(Colors.greenAccent),
                      iconSize: const WidgetStatePropertyAll(20),
                      backgroundColor: WidgetStatePropertyAll(
                          currentTheme.brightness == Brightness.dark
                              ? secondaryDarkTheme
                              : accentLightTheme),
                      textStyle: const WidgetStatePropertyAll(
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Text('Definir usuário padrão'),
                        Icon(
                          Icons.check_circle,
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
