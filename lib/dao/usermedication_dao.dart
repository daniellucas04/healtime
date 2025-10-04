import 'package:sqflite/sqflite.dart';
import '../models/usermedication.dart';

class UsuarioMedicamentoDao {
  final Database database;
  String table = 'user_medication';

  UsuarioMedicamentoDao({required this.database});

  Future<int> insert(UsuarioMedicamento vinculo) async {
    return await database.insert(table, vinculo.toMap());
  }

  Future<int> delete(UsuarioMedicamento vinculo) async {
    return await database.delete(
      table,
      where: 'usuario_id = ? AND medicamento_id = ?',
      whereArgs: [vinculo.usuarioId, vinculo.medicamentoId],
    );
  }

  Future<List<UsuarioMedicamento>> getAll() async {
    final result = await database.query(table);
    return result.map((json) => UsuarioMedicamento.fromMap(json)).toList();
  }
}
