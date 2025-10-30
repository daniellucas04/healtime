import 'package:app/helpers/session.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/components/sidebar.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  bool isSwitched = false;
  int? selectedUserId;

  loadUser() async {
    int activeUserId = await Session.getActiveUser();
    setState(() {
      selectedUserId = activeUserId;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    isSwitched = provider.isSystemThemeActive;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    return Scaffold(
      endDrawer: Sidebar(
        onUserSelected: (userId) {
          setState(() {
            selectedUserId = userId;
          });
        },
        userId: selectedUserId ?? 1,
      ),
      resizeToAvoidBottomInset: false,
      appBar: Header(title: 'Configurações'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Seguir o tema do sistema'),
                Switch(
                  activeThumbColor: currentTheme.brightness == Brightness.dark
                      ? secondaryDarkTheme
                      : accentLightTheme,
                  inactiveThumbColor: isSwitched ? Colors.grey : Colors.blue,
                  inactiveTrackColor:
                      isSwitched ? Colors.grey.withAlpha(50) : null,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                      Provider.of<ThemeProvider>(context, listen: false)
                          .setSystemThemeMode();
                    });
                  },
                  value: isSwitched,
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(pageIndex: 3),
    );
  }
}
