import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:app/controllers/user_medication_controller.dart';
import 'package:app/helpers/session.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/navigation_bar.dart';
import 'package:app/views/components/sidebar.dart';

Future<List<Map<String, dynamic>>> getByUserMedication(int userId) async {
  List<Map<String, dynamic>> result =
      await UserMedicationController().getUserFromMedication(userId);
  return result;
}

Future<List<Map<String, dynamic>>> getAllById(int medicationId) async {
  List<Map<String, dynamic>> result = await MedicationScheduleDao(
          database: await DatabaseHelper.instance.database)
      .getAllById(medicationId);
  return result;
}

Future<List<Map<String, dynamic>>> getAll(int userId) async {
  return MedicationScheduleDao(database: await DatabaseHelper.instance.database)
      .count(userId);
}

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  bool isSwitched = false;
  int? selectedUserId;
  String userName = "Usuario";

  Future<void> loadUser() async {
    int activeUserId = await Session.getActiveUser();
    setState(() {
      selectedUserId ??= activeUserId;
    });
    _getUserName(selectedUserId!);
  }

  Future<void> _getUserName(int userId) async {
    var users = await UserDao(database: await DatabaseHelper.instance.database)
        .getById(userId);
    setState(() {
      userName = users!.name;
    });
  }

  _medicationInformation(int id) async {
    List<Map<String, dynamic>> medicationDetails = await getAllById(id);
    DateTime? next;
    int counter = 0;

    medicationDetails.forEach((med) {
      if (DateTime.parse(med['date']).isAfter(DateTime.now()) &&
          counter == 0 &&
          med['status'] == 'Pendente') {
        next = DateTime.parse(med['date']);
        counter++;
      }
    });
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.content_paste, size: 32),
                  SizedBox(width: 10),
                  Text(
                    'Detalhes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Início: ${dateFormat(DateTime.parse(medicationDetails.first['date']))}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Fim: ${dateFormat(DateTime.parse(medicationDetails.last['date']))}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              medicationDetails.last['status'] != 'Pendente'
                  ? const Text('Todas as doses já foram tomadas')
                  : Text('Próxima dose: ${dateHourFormat(next!)}'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Confirmar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) {
                          final ScrollController scrollController =
                              ScrollController();
                          int itemsToShow = 20;

                          DateTime? selectedDate;
                          List<Map<String, dynamic>> filteredList =
                              List.from(medicationDetails);

                          return StatefulBuilder(
                            builder: (context, setState) {
                              scrollController.addListener(() {
                                if (scrollController.position.pixels ==
                                    scrollController.position.maxScrollExtent) {
                                  if (itemsToShow < filteredList.length) {
                                    setState(() {
                                      itemsToShow += 20;
                                      if (itemsToShow > filteredList.length) {
                                        itemsToShow = filteredList.length;
                                      }
                                    });
                                  }
                                }
                              });

                              void applyFilter(DateTime? date) {
                                selectedDate = date;

                                if (date == null) {
                                  filteredList = List.from(medicationDetails);
                                } else {
                                  filteredList =
                                      medicationDetails.where((dose) {
                                    DateTime d = DateTime.parse(dose['date']);
                                    return d.year == date.year &&
                                        d.month == date.month &&
                                        d.day == date.day;
                                  }).toList();
                                }

                                itemsToShow = filteredList.length < 20
                                    ? filteredList.length
                                    : 20;

                                setState(() {});
                              }

                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Histórico de Doses',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedDate == null
                                              ? "Todas as datas"
                                              : "Filtrado: ${dateFormat(selectedDate!)}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Row(
                                          children: [
                                            TextButton.icon(
                                              onPressed: () async {
                                                final picked =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: selectedDate ??
                                                      DateTime.now(),
                                                  firstDate: DateTime(2020),
                                                  lastDate: DateTime(2100),
                                                );

                                                applyFilter(picked);
                                              },
                                              icon: const Icon(
                                                  Icons.calendar_today),
                                              label: const Text("Filtrar"),
                                            ),
                                            if (selectedDate != null)
                                              TextButton(
                                                onPressed: () {
                                                  applyFilter(null);
                                                },
                                                child: const Text("Limpar"),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: filteredList.isEmpty
                                          ? const Center(
                                              child: Text(
                                                  "Nenhum registro para esta data"),
                                            )
                                          : ListView.builder(
                                              controller: scrollController,
                                              itemCount: itemsToShow,
                                              itemBuilder: (context, index) {
                                                final dose =
                                                    filteredList[index];

                                                IconData icon;
                                                Color color;
                                                switch (dose['status']) {
                                                  case 'Tomado':
                                                    icon = Icons.check_circle;
                                                    color = Colors.green;
                                                    break;
                                                  case 'Pendente':
                                                    icon = Icons.schedule;
                                                    color = Colors.blue;
                                                    break;
                                                  case 'Atrasado':
                                                    icon = Icons.warning;
                                                    color = Colors.orange;
                                                    break;
                                                  case 'Esquecido':
                                                    icon = Icons.cancel;
                                                    color = Colors.redAccent;
                                                    break;
                                                  default:
                                                    icon = Icons.help_outline;
                                                    color = Colors.grey;
                                                }

                                                return ListTile(
                                                  leading:
                                                      Icon(icon, color: color),
                                                  title: Text(
                                                    dateHourFormat(
                                                      DateTime.parse(
                                                          dose['date']),
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    'Status: ${dose['status']}',
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Fechar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    child: const Text('Histórico'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Sidebar(
        onUserSelected: (userId) {
          setState(() {
            selectedUserId = userId;
            Session.setActiveUser(selectedUserId!);
            _getUserName(selectedUserId!);
          });
        },
        userId: selectedUserId ?? 1,
      ),
      resizeToAvoidBottomInset: false,
      appBar: Header(title: 'Relátorio'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor:
                              Colors.blueAccent.withValues(alpha: 0.2),
                          child: const Icon(Icons.person,
                              color: Colors.blueAccent),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          userName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Histórico de Medicamentos",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
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

                  if (items.isEmpty) {
                    return const Center(
                        child: Text(
                            'Nenhum medicamento registrado até o momento'));
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final medication = items[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade900,
                              Colors.blue.shade700,
                            ],
                          ),
                        ),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          shadowColor: Colors.black45,
                          child: InkWell(
                            onTap: () async {
                              _medicationInformation(
                                  medication['medication_id']);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              medication['name'].toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          spacing: 8,
                                          children: [
                                            Text(
                                              "${medication['type'].toString()[0].toUpperCase()}${medication['type'].toString().substring(1)}:",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              medication['quantity'].toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 15),
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Adesão ao Horário de Uso",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder(
                future: getAll(selectedUserId ?? 1),
                builder: (context, snapshot) {
                  var status = <String>[];
                  var quantidade = <int>[];

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }

                  final items = snapshot.data ?? [];

                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum medicamento encontrado.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  if (items.isNotEmpty) {
                    try {
                      for (var i in items) {
                        status.add(i['status']);
                        quantidade.add(i['status_count']);
                      }
                    } catch (e) {}
                  }

                  final int total = quantidade.fold(0, (sum, q) => sum + q);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          "Total de doses registradas: $total",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(status.length, (index) {
                            Color chipColor;
                            IconData chipIcon;
                            switch (status[index]) {
                              case "Atrasado":
                                chipColor = Colors.amber;
                                chipIcon = Icons.warning;
                                break;
                              case "Esquecido":
                                chipColor = Colors.redAccent;
                                chipIcon = Icons.cancel;
                                break;
                              case "Pendente":
                                chipColor = Colors.lightBlueAccent;
                                chipIcon = Icons.schedule;
                                break;
                              default:
                                chipColor = Colors.green;
                                chipIcon = Icons.check_circle;
                            }
                            return ActionChip(
                              onPressed: () async {
                                final chipStatus = status[index];
                                String title = "";
                                IconData icon;
                                Color color;

                                switch (chipStatus) {
                                  case 'Tomado':
                                    title = "Tomada(s)";
                                    icon = Icons.check_circle;
                                    color = Colors.green;
                                    break;
                                  case 'Pendente':
                                    title = "Pendente(s)";
                                    icon = Icons.schedule;
                                    color = Colors.blue;
                                    break;
                                  case 'Atrasado':
                                    title = "Atrasada(s)";
                                    icon = Icons.warning;
                                    color = Colors.orange;
                                    break;
                                  case 'Esquecido':
                                    title = "Esquecida(s)";
                                    icon = Icons.cancel;
                                    color = Colors.redAccent;
                                    break;
                                  default:
                                    title = "";
                                    icon = Icons.info;
                                    color = Colors.grey;
                                }

                                var medicationDetails =
                                    await MedicationScheduleDao(
                                            database: await DatabaseHelper
                                                .instance.database)
                                        .medicationStatus(status[index]);

                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  builder: (context) {
                                    final ScrollController scrollController =
                                        ScrollController();

                                    int itemsToShow = medicationDetails.length;
                                    DateTime? selectedDate;

                                    List<dynamic> filteredList =
                                        List.from(medicationDetails);

                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        scrollController.addListener(() {
                                          if (scrollController
                                                  .position.pixels ==
                                              scrollController
                                                  .position.maxScrollExtent) {
                                            if (itemsToShow <
                                                filteredList.length) {
                                              setState(() {
                                                if (itemsToShow >
                                                    filteredList.length) {
                                                  itemsToShow =
                                                      filteredList.length;
                                                }
                                              });
                                            }
                                          }
                                        });
                                        void applyFilter(DateTime? date) {
                                          selectedDate = date;
                                          if (date == null) {
                                            filteredList =
                                                List.from(medicationDetails);
                                          } else {
                                            filteredList =
                                                medicationDetails.where((dose) {
                                              DateTime d =
                                                  DateTime.parse(dose['date']);

                                              return d.year == date.year &&
                                                  d.month == date.month &&
                                                  d.day == date.day;
                                            }).toList();
                                          }
                                          itemsToShow = filteredList.length < 20
                                              ? filteredList.length
                                              : 20;

                                          setState(() {});
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Histórico das Doses $title',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    selectedDate == null
                                                        ? "Todas as datas"
                                                        : "Filtrado: ${dateFormat(selectedDate!)}",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  Row(
                                                    children: [
                                                      TextButton.icon(
                                                        onPressed: () async {
                                                          final picked =
                                                              await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                selectedDate ??
                                                                    DateTime
                                                                        .now(),
                                                            firstDate:
                                                                DateTime(2020),
                                                            lastDate:
                                                                DateTime(2100),
                                                          );

                                                          applyFilter(picked);
                                                        },
                                                        icon: const Icon(Icons
                                                            .calendar_today),
                                                        label: const Text(
                                                            "Filtrar"),
                                                      ),
                                                      if (selectedDate != null)
                                                        TextButton(
                                                          onPressed: () {
                                                            applyFilter(null);
                                                          },
                                                          child: const Text(
                                                              "Limpar"),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.6,
                                                child: filteredList.isEmpty
                                                    ? const Center(
                                                        child: Text(
                                                            "Nenhum resultado para esta data"),
                                                      )
                                                    : ListView.builder(
                                                        controller:
                                                            scrollController,
                                                        itemCount: itemsToShow,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final dose =
                                                              filteredList[
                                                                  index];
                                                          return ListTile(
                                                            leading: Icon(icon,
                                                                color: color),
                                                            title: Text(
                                                                '${dose['name'].toString().toUpperCase()}'),
                                                            subtitle: Text(
                                                              dateHourFormat(
                                                                  DateTime.parse(
                                                                      dose[
                                                                          'date'])),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                              ),
                                              const SizedBox(height: 10),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text('Fechar'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              label: Text(
                                  '${status[index]}: ${quantidade[index]}'),
                              backgroundColor:
                                  chipColor.withValues(alpha: 0.15),
                              labelStyle: TextStyle(
                                color: chipColor,
                                fontWeight: FontWeight.bold,
                              ),
                              avatar: Icon(chipIcon, color: chipColor),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(pageIndex: 1),
    );
  }
}
