import 'package:sqflite/sqflite.dart';
import '../models/usermedication.dart';

class UsuarioMedicamentoDao {
  final Database database;
  String table = 'user_medication';

  UsuarioMedicamentoDao({required this.database});

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
}
