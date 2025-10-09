import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../../lib/models/usermedication.dart';
import '../../../lib/dao/usermedication_dao.dart';
import '../../helpers/memory_database.dart';

void main() {
  late Database db;
  late UsuarioMedicamentoDao dao;

  setUp(() async {
    db = await createTestDb();
    dao = UsuarioMedicamentoDao(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('insert and getAll', () async {
    final vinculo = UserMedication(usuarioId: 1, medicamentoId: 2);
    await dao.insert(vinculo);

    final result = await dao.getAll();
    expect(result.length, 1);
    expect(result.first.usuarioId, 1);
    expect(result.first.medicamentoId, 2);
  });

  test('delete vinculo', () async {
    final vinculo = UserMedication(usuarioId: 1, medicamentoId: 2);
    await dao.insert(vinculo);

    await dao.delete(vinculo);
    final result = await dao.getAll();
    expect(result.isEmpty, true);
  });
}
