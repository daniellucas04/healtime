import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app/models/usermedication.dart';
import 'package:app/dao/usermedication_dao.dart';

void main() {
  late Database db;
  late UsuarioMedicamentoDao dao;

  setUp(() async {
    db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuario_medicamento (
            usuario_id INTEGER NOT NULL,
            medicamento_id INTEGER NOT NULL,
            PRIMARY KEY (usuario_id, medicamento_id)
          )
        ''');
      },
    );
    dao = UsuarioMedicamentoDao(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('insert and getAll', () async {
    final vinculo = UsuarioMedicamento(usuarioId: 1, medicamentoId: 2);
    await dao.insert(vinculo);

    final result = await dao.getAll();
    expect(result.length, 1);
    expect(result.first.usuarioId, 1);
    expect(result.first.medicamentoId, 2);
  });

  test('delete vinculo', () async {
    final vinculo = UsuarioMedicamento(usuarioId: 1, medicamentoId: 2);
    await dao.insert(vinculo);

    await dao.delete(vinculo);
    final result = await dao.getAll();
    expect(result.isEmpty, true);
  });
}
