import 'package:app/database/database_helper.dart';
import 'package:app/helpers/authentication.dart';
import 'package:app/helpers/session.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:app/services/notifications.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/components/sidebar.dart';
import 'package:app/views/components/snackbar.dart';
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

  _restoreApplication() async {
    var authenticated = await Authenticate.requestAuth();

    if (!authenticated) {
      Snackbar.showSnackBar(
        context,
        message: 'Falha na autenticação',
        backgroundColor: Colors.redAccent,
        icon: Icons.error,
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 32),
            SizedBox(width: 10),
            Text(
              'Atenção!',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                'A restauração do aplicativo resulta na perda de todos os dados já registrados.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Recomenda-se realizar um backup antes de realizar esta ação. Tem certeza que deseja restaurar o aplicativo?',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              NotificationService notification = NotificationService();
              await DatabaseHelper.instance.resetDatabase();
              notification.cancelAllNotifications();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/tutorial_screen', (_) => false);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Confirmar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
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
          spacing: 32,
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FilledButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          currentTheme.brightness == Brightness.dark
                              ? const WidgetStatePropertyAll(
                                  Color.fromARGB(255, 10, 61, 175))
                              : const WidgetStatePropertyAll(
                                  Color.fromARGB(50, 10, 61, 255)),
                      foregroundColor:
                          currentTheme.brightness == Brightness.dark
                              ? const WidgetStatePropertyAll(Colors.white)
                              : const WidgetStatePropertyAll(Colors.black87),
                      shape: const WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          side: BorderSide(width: 2, color: Colors.blueAccent),
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () => _restoreApplication(),
                    icon: const Icon(
                      Icons.restore_outlined,
                      size: 24,
                    ),
                    label: const Text(
                      'Restaurar aplicativo',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(pageIndex: 3),
    );
  }
}
