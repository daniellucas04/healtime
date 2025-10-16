import 'dart:io';

import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/medicationschedule.dart';
import 'package:app/services/notifications.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

enum NotificationsType {
  off,
  inHour,
  advance,
  delayed,
}

class CreateMedicationStep9Notifications extends StatefulWidget {
  CreateMedicationStep9Notifications({super.key, required this.medicationList});

  final List<Future<int>> medicationList;
  final List<int> medicationsIds = [];

  @override
  State<CreateMedicationStep9Notifications> createState() =>
      _CreateMedicationStep9NotificationsState();
}

class _CreateMedicationStep9NotificationsState
    extends State<CreateMedicationStep9Notifications> {
  Future<List<int>> _getMedicationIds(List<Future<int>> medicationList) async {
    for (var medication in medicationList) {
      widget.medicationsIds.add(await medication);
    }

    return widget.medicationsIds;
  }

  _finishNotifications(NotificationsType type) async {
    final notifications = NotificationService();

    if (type != NotificationsType.off) {
      final hasPermission = await notifications.hasPermission();

      if (!context.mounted) {
        return;
      }

      if (!hasPermission) {
        await showDialog<void>(
          context: context,
          builder: (context) => Alert(
            title: 'Notificações',
            message:
                'É necessário conceder permissão de notificação para receber os alertas.',
            actions: [
              TextButton(
                onPressed: () async {
                  await notifications.requestPermissions();
                  Navigator.of(context).pop();
                },
                child: const Text('Conceder'),
              ),
            ],
          ),
        );
      }
    }

    final database = await DatabaseHelper.instance.database;

    List<MedicationSchedule?> medications = [];
    for (var id in widget.medicationsIds) {
      final MedicationSchedule? med =
          await MedicationScheduleDao(database: database)
              .getByIdForScheduling(id);
      medications.add(med);
    }

    medications.removeWhere((med) => med == null);
    for (final med in medications) {
      await notifications.scheduleMedicationNotifications(med!, type);
    }
  }

  @override
  void initState() {
    _getMedicationIds(widget.medicationList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(
          title: 'Notificações',
          subtitle: 'Quando deseja receber a notificação?',
        ),
        body: Column(
          children: [
            SizedBox(
              height: (context.heightPercentage(0.05)),
            ),
            Container(
              height: (context.heightPercentage(0.95) - 200),
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        await _finishNotifications(NotificationsType.off);
                        if (!context.mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (_) => false);
                      },
                      child: const Text('Não notificar'),
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        await _finishNotifications(NotificationsType.inHour);
                        if (!context.mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (_) => false);
                      },
                      child: const Text('Notificar no horário'),
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        await _finishNotifications(NotificationsType.advance);
                        if (!context.mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (_) => false);
                      },
                      child: const Text('Notificar com adiantamento'),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ],
        ));
  }
}
