import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> createTestDb() async {
  sqfliteFfiInit();

  final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

  // Remove tabelas se existirem para evitar erros de "tabela já existe"
  await db.execute('DROP TABLE IF EXISTS medications');
  await db.execute('DROP TABLE IF EXISTS users');
  await db.execute('DROP TABLE IF EXISTS usuario_medicamento');

  // Cria a tabela medications
  await db.execute('''
    CREATE TABLE medications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )
  ''');

  // Cria a tabela users com o tipo INTEGER corrigido
  await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      nascimento INTEGER
    )
  ''');

  await db.execute('''
  CREATE TABLE usuario_medicamento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER NOT NULL,
    medicamento_id INTEGER NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES users(id),
    FOREIGN KEY (medicamento_id) REFERENCES medicamentos(id)
  )
''');

  return db;
}
