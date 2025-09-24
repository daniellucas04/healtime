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

  Future<List<Map<String, dynamic>>> getAll(DateTime searchDate) async {
    var date = searchDate.toIso8601String().substring(0, 10);
    final List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT medication_schedule.id AS id, medication_schedule.date AS date, medication_schedule.medication_id as medication_id, medication_schedule.status as status ,medications.name AS name, medications.type AS type, medications.quantity AS quantity
    FROM medication_schedule
    INNER JOIN medications ON medications.id = medication_schedule.medication_id
    WHERE date(medication_schedule.date) = date('$date') AND status IN ('Pendente', 'Esquecido');
  ''');

    return result;
  }

  Future<List<MedicationSchedule?>> getById(int id) async {
    final medicationSchedule =
        await database.query(table, where: 'medication_id = ?', whereArgs: [id]);
    return medicationSchedule.map((json) => MedicationSchedule.fromMap(json)).toList();
  }
}
