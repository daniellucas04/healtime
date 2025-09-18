import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<List<Map<String, dynamic>>> getAll(DateTime searchDate) async {
  return MedicationScheduleDao(database: await DatabaseHelper.instance.database)
      .getAll(searchDate);
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  DateTime searchDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(title: 'Seja bem-vindo!'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAll(searchDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () async {
                            setState(() {
                              searchDate =
                                  searchDate.add(const Duration(days: -1));
                            });
                          },
                          icon: const Icon(
                              Icons.keyboard_double_arrow_left_outlined)),
                      TextButton(
                        onPressed: () async {
                          DateTime? selectedDate = await datePicker(
                              context: context, initialDate: searchDate);
                          setState(() {
                            if (selectedDate != null) {
                              searchDate = selectedDate;
                            }
                          });
                        },
                        child: Text(
                          DateFormat('dd/MM').format(searchDate),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            setState(() {
                              searchDate =
                                  searchDate.add(const Duration(days: 1));
                            });
                          },
                          icon: const Icon(
                              Icons.keyboard_double_arrow_right_outlined))
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Center(
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 50,
                          right: 50,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          'Nenhum registro encontrado',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final medication = items[index];
              return Column(
                children: [
                  index == 0
                      ? Container(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      searchDate = searchDate
                                          .add(const Duration(days: -1));
                                    });
                                  },
                                  icon: const Icon(Icons
                                      .keyboard_double_arrow_left_outlined)),
                              TextButton(
                                onPressed: () async {
                                  DateTime? selectedDate = await datePicker(
                                      context: context,
                                      initialDate: searchDate);
                                  setState(() {
                                    if (selectedDate != null) {
                                      searchDate = selectedDate;
                                    }
                                  });
                                },
                                child: Text(
                                  DateFormat('dd/MM').format(searchDate),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      searchDate = searchDate
                                          .add(const Duration(days: 1));
                                    });
                                  },
                                  icon: const Icon(Icons
                                      .keyboard_double_arrow_right_outlined))
                            ],
                          ))
                      : SizedBox(
                          height: 1,
                          width: 1,
                        ),
                  Card(
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
                          begin: AlignmentGeometry.bottomLeft,
                          end: AlignmentGeometry.topRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                dense: true,
                                textColor: Colors.white,
                                title: Text(
                                  medication['name'].toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  '${medication['type']}: ${medication['quantity']}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              timeFormat(
                                DateTime.parse(medication['date']),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: const NavBar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 35,
          color: backgroundDarkTheme50,
        ),
        onPressed: () => {
          Navigator.pushNamed(context, '/medicine_registration'),
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
