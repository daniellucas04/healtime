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

  Future<List<Map<String, dynamic>>> getAll(DateTime searchDate,
      {int? userId}) async {
    var date = searchDate.toIso8601String().substring(0, 10);

    String query = '''
    SELECT 
      medication_schedule.id AS id, 
      medication_schedule.date AS date, 
      medication_schedule.medication_id AS medication_id, 
      medication_schedule.status AS status,
      medications.name AS name, 
      medications.type AS type, 
      medications.quantity AS quantity
    FROM medication_schedule
    INNER JOIN medications ON medications.id = medication_schedule.medication_id
    INNER JOIN user_medication ON user_medication.medication_id = medications.id
    WHERE date(medication_schedule.date) = date(?)
  ''';

    List<dynamic> args = [date];

    if (userId != null) {
      query += ' AND user_medication.user_id = ?';
      args.add(userId);
    }

    query += ' ORDER BY medication_schedule.date ASC;';

    final List<Map<String, dynamic>> result =
        await database.rawQuery(query, args);

    return result;
  }

  Future<MedicationSchedule?> getById(int id) async {
    final medicationSchedule =
        await database.query(table, where: 'id = ?', whereArgs: [id]);

    if (medicationSchedule.isNotEmpty) {
      return MedicationSchedule.fromMap(medicationSchedule.first);
    }

    return null;
  }

  Future<MedicationSchedule?> getByIdForScheduling(int id) async {
    final List<Map<String, dynamic>> results = await database.rawQuery('''
      SELECT ms.id as schedule_id, ms.date, ms.status, ms.medication_id,
            m.name, m.type, m.frequency_type, m.frequency_value, m.duration, m.quantity, m.first_medication
      FROM medication_schedule ms
      JOIN medications m ON ms.medication_id = m.id
      WHERE ms.id = ?
    ''', [id]);

    if (results.isNotEmpty) {
      final row = results.first;

      return MedicationSchedule.fromMapWithMedication(row);
    }

    return null;
  }
}
