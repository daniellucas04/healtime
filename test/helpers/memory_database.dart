import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> createTestDb() async {
  sqfliteFfiInit();

  final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

  await db.execute('''
    CREATE TABLE medications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )
  ''');

  return db;
}
