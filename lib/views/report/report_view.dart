import 'package:app/controllers/user_medication_controller.dart';
import 'package:app/helpers/session.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/components/sidebar.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> getByUserMedication(int userId) async {
  List<Map<String, dynamic>> result =
      await UserMedicationController().getUserFromMedication(userId);
  return result;
}

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  bool isSwitched = false;
  int? selectedUserId;

  Future<void> loadUser() async {
    int activeUserId = await Session.getActiveUser();
    setState(() {
      selectedUserId = activeUserId;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUser();
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
      appBar: Header(title: 'Relátorio'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 25,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  minRadius: 20,
                  maxRadius: 40,
                  backgroundColor: currentTheme.brightness == Brightness.dark
                      ? secondaryDarkTheme
                      : secondaryLightTheme,
                  child: const Icon(
                    Icons.people,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Usuário", style: TextStyle(fontSize: 20)),
                )
              ],
            ),
            const Text("Medicamentos Tomados", style: TextStyle(fontSize: 25)),
            FutureBuilder(
                future: getByUserMedication(selectedUserId ?? 1),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }

                  final items = snapshot.data ?? [];

                  return SizedBox(
                    height: 100,
                    child: Expanded(
                      child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final medication = items[index];
                            return SingleChildScrollView(
                              child: Column(
                                children: [Text(medication['name'])],
                              ),
                            );
                          }),
                    ),
                  );
                }),
            const Text("Medicamentos Tomados no Horário",
                style: TextStyle(fontSize: 25)),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(pageIndex: 1),
    );
  }
}
