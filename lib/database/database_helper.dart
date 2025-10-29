import 'package:app/database/tables/tables.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('healtime.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute(Tables.medications());
    await db.execute(Tables.users());
    await db.execute(Tables.medicationSchedule());
    await db.execute(Tables.usersMedication());
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('''ALTER TABLE users ADD COLUMN active INTEGER NOT NULL DEFAULT 0;''');
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
