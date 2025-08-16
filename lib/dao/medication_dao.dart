import 'package:app/database/database_helper.dart';
import 'package:app/models/medication.dart';

class MedicationDao {
  final dbHelper = DatabaseHelper.instance;
  final table = 'medications';

  Future<int> insert(Medication medication) async {
    final db = await dbHelper.database;

    return await db.insert(table, medication.toMap());
  }

  Future<int> update(Medication medication) async {
    final db = await dbHelper.database;

    return await db.update(table, medication.toMap(), where: 'id = ?', whereArgs: [medication.id]);
  }

  Future<int> delete(Medication medication) async {
    final db = await dbHelper.database;

    return await db.delete(table, where: 'id = ?', whereArgs: [medication.id]);
  }

  Future<List<Medication>> getAll() async {
    final db = await dbHelper.database;

    final medications = await db.query(table);
    return medications.map((json) => Medication.fromMap(json)).toList();
  }
}