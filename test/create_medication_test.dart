import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:app/dao/medication_dao.dart';
import 'package:app/models/medication.dart';

void main() {
  // Inicializa o sqflite_common_ffi
  sqfliteFfiInit();

  late final DatabaseFactory databaseFactory;
  late final MedicationDao dao;

  setUp(() async {
    databaseFactory = databaseFactoryFfi;

    // Abre banco em memória
    final db = await databaseFactory.openDatabase(inMemoryDatabasePath,
        options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) async {
              await db.execute('''
                CREATE TABLE medications (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  name TEXT
                );
              ''');
            }));

    dao = MedicationDao(database: db);
  });

  tearDown(() async {
    await dao.database.close();
  });

  test('DAO should return a list of medications', () async {
    await dao.insert(Medication(name: 'Paracetamol'));

    final results = await dao.getAll();

    expect(results, isA<List<Medication>>());
    expect(results.length, 1);
    expect(results[0].name, 'Paracetamol');
  });
}
