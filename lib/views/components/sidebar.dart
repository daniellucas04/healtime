import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isSwitched = false;

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
                const Text('Nome do usuário'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsGeometry.all(16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  const Text(
                    'Tema escuro',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Switch(
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    value: isSwitched,
                  )
                ],
              ),
            ),
          ),
          const Divider(),
          ListTile(
            onTap: () {},
            title: const Text('Usuário 1'),
          ),
          ListTile(
            onTap: () {},
            title: const Text('Usuário 2'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: TextButton(
                style: ButtonStyle(
                  iconColor: const WidgetStatePropertyAll(Colors.greenAccent),
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
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140);
}
