import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> createTestDb() async {
  sqfliteFfiInit();

  final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

  // Remove tabelas se existirem para evitar erros de "tabela já existe"
  await db.execute('DROP TABLE IF EXISTS medications');
  await db.execute('DROP TABLE IF EXISTS users');

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

  return db;
}
