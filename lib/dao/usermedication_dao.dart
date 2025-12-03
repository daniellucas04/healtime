import 'package:sqflite/sqflite.dart';
import '../models/usermedication.dart';

class UserMedicationDao {
  final Database database;
  String table = 'user_medication';

  UserMedicationDao({required this.database});

  Future<int> insert(UserMedication vinculo) async {
    return await database.insert(table, vinculo.toMap());
  }

  Future<int> delete(UserMedication vinculo) async {
    return await database.delete(
      table,
      where: 'user_id = ? AND medication_id = ?',
      whereArgs: [vinculo.userId, vinculo.medicationId],
    );
  }

  Future<List<UserMedication>> getAll() async {
    final result = await database.query(table);
    return result.map((json) => UserMedication.fromMap(json)).toList();
  }

  Future<List<Map<String, dynamic>>> getByMedicationId(int id) async {
    List<Map<String, dynamic>> result = await database.rawQuery(
        'SELECT * FROM user_medication inner join users on users.id = user_medication.user_id where medication_id = $id');

    return result;
  }

  Future<List<Map<String, dynamic>>> getByUserId(int id) async {
    List<Map<String, dynamic>> result = await database.rawQuery(
        'SELECT * FROM user_medication inner join medications on medications.id = user_medication.medication_id where user_id = $id order by name asc');
    print(result);
    return result;
  }
}
