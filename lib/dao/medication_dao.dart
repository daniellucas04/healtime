import 'package:app/models/medication.dart';
import 'package:sqflite/sqflite.dart';

class MedicationDao {
  final Database database;
  String table = 'medications';

  MedicationDao({required this.database});

  Future<int> insert(Medication medication) async {
    return await database.insert(table, medication.toMap());
  }

  Future<int> update(Medication medication) async {
    return await database.update(table, medication.toMap(), where: 'id = ?', whereArgs: [medication.id]);
  }

  Future<int> delete(Medication medication) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [medication.id]);
  }

  Future<List<Medication>> getAll() async {
    final medications = await database.query(table);
    return medications.map((json) => Medication.fromMap(json)).toList();
  }
}