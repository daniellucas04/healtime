import 'package:app/models/medicationschedule.dart';
import 'package:sqflite/sqflite.dart';

class MedicationScheduleDao {
  final Database database;
  String table = 'medication_schedule';

  MedicationScheduleDao({required this.database});

  Future<int> insert(MedicationSchedule medicationSchedule) async {
    return await database.insert(table, medicationSchedule.toMap());
  }

  Future<int> update(MedicationSchedule medicationSchedule) async {
    return await database.update(table, medicationSchedule.toMap(),
        where: 'id = ?', whereArgs: [medicationSchedule.id]);
  }

  Future<int> delete(MedicationSchedule medicationSchedule) async {
    return await database
        .delete(table, where: 'id = ?', whereArgs: [medicationSchedule.id]);
  }

  Future<List<MedicationSchedule>> getAll() async {
    final medicationSchedules = await database.query(table);
    return medicationSchedules
        .map((json) => MedicationSchedule.fromMap(json))
        .toList();
  }

  Future<MedicationSchedule?> getById(int id) async {
    final medicationSchedule =
        await database.query(table, where: 'id = ?', whereArgs: [id]);
    if (medicationSchedule.isNotEmpty) {
      return MedicationSchedule.fromMap((medicationSchedule.first));
    }

    return null;
  }
}
