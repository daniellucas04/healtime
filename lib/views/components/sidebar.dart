import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/main.dart';
import 'package:app/models/user.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:app/views/theme/theme.dart';
import 'package:app/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:app/models/user.dart';
import 'package:app/dao/user_dao.dart';

class Sidebar extends StatefulWidget {
  final Function(int? userId) onUserSelected; // Callback para passar o userId

  const Sidebar({super.key, required this.onUserSelected});

  @override
  State<Sidebar> createState() => _SidebarState();
}

Future<List<User>> _getUsersWithDefault() async {
  final dao = UserDao(database: await DatabaseHelper.instance.database);
  var users = await dao.getAll();

  if (users.isEmpty) {
    await dao.insert(User(
      name: 'Você',
      birthDate: DateTime(2000, 1, 1).toString(),
      active: 1,
    ));
    users = await dao.getAll();
  }

  return users;
}

class _SidebarState extends State<Sidebar> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    isSwitched = provider.themeMode == ThemeMode.dark;
  }

  Future<List<User>> _getUsers() async {
    var users = await UserDao(database: await DatabaseHelper.instance.database)
        .getAll();
    return users;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    return Drawer(
      child: SizedBox(
        child: ListView(
          shrinkWrap: false,
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryDarkTheme, secondaryDarkTheme],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                const Text('Nome do usuário'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    minRadius: 20,
                    maxRadius: 50,
                    backgroundColor: currentTheme.brightness == Brightness.dark
                        ? secondaryDarkTheme
                        : accentLightTheme,
                    onChanged: (value) {
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
                      Navigator.pop(context);
                      print(user.id);
                    },
                  );
                }).toList(),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    currentTheme.brightness == Brightness.dark
                        ? secondaryDarkTheme
                        : accentLightTheme,
                  ),
                  textStyle: WidgetStateProperty.all(
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Text('Definir usuário padrão'),
                    Icon(Icons.check_circle),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Teste Notification
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'medication',
      'Medicação próxima',
      channelDescription: 'Uma medicação está próxima do seu horário agendado',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      id++,
      'Atenção usuário!',
      'o medicamento DIPIRONA está próximo de ser ministrado',
      notificationDetails,
      payload: 'item x',
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140);
}
