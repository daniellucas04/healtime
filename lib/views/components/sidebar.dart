import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/user.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
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
                  const Center(
                    child: Text(
                      'Nome do usuário',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        wordSpacing: 1,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsGeometry.all(16),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tema escuro',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Switch(
                      activeThumbColor:
                          currentTheme.brightness == Brightness.dark
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
                    )
                  ],
                ),
              ),
            ),
            const Divider(),
            FutureBuilder<List<User>>(
              future: _getUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                final users = snapshot.data ?? [];

                return SizedBox(
                  height: context.heightPercentage(0.52),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: users.map((user) {
                        return Padding(
                          padding: const EdgeInsetsGeometry.all(2),
                          child: ListTile(
                            onTap: () {},
                            title: Text(user.name),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
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

  @override
  Size get preferredSize => const Size.fromHeight(140);
}
