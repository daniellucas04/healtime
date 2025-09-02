import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app/dao/medication_dao.dart';
import 'package:app/models/medication.dart';

import '../../helpers/memory_database.dart';

void main() {
  late Database db;
  late MedicationDao medicationDao;

  setUp(() async {
    db = await createTestDb();
    medicationDao = MedicationDao(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Medication DAO should return a list of medications', () async {
    await medicationDao.insert(Medication(
      name: 'Fenitoína',
      type: 'Comprimido',
      frequencyType: 'diária',
      frequencyValue: 1,
      duration: 10,
      quantity: 1,
      firstMedication: 'Sim',));
    await medicationDao.insert(Medication(
      name: 'Dipirona',
      type: 'Gota',
      frequencyType: 'diária',
      frequencyValue: 1,
      duration: 10,
      quantity: 1,
      firstMedication: 'Sim',));
    final results = await medicationDao.getAll();

    expect(results, isA<List<Medication>>());
    expect(results.length, 2);
    expect(results[0].name, 'Fenitoína');
    expect(results[1].name, 'Dipirona');
  });

  test('Medication DAO should insert a new medication', () async {
    final result = await medicationDao.insert(Medication(
      name: 'Paracetamol',
      type: 'Comprimido',
      frequencyType: 'diária',
      frequencyValue: 1,
      duration: 10,
      quantity: 1,
      firstMedication: 'Sim',
    ));

    expect(result, isA<int>());
    expect(result, greaterThan(0));
  });

  test('Medication DAO should update a medication', () async {
    final insertedId = await medicationDao.insert(Medication(
      name: 'Ibuprofeno',
      type: 'Comprimido',
      frequencyType: 'diária',
      frequencyValue: 1,
      duration: 10,
      quantity: 1,
      firstMedication: 'Sim',
      ));
    var medication = Medication(id: insertedId, name: 'Dipirona',
      type: 'Comprimido',
      frequencyType: 'diária',
      frequencyValue: 1,
      duration: 20,
      quantity: 10,
      firstMedication: 'Sim',
    );
    final result = await medicationDao.update(medication);

    expect(result, 1);

    final updatedMed = await medicationDao.getById(insertedId);
    expect(updatedMed!.name, 'Dipirona');
  });

  test('Medication DAO should delete a medication', () async {
    final insertedId = await medicationDao.insert(Medication(
      name: 'Vancomicina',
      type: 'Comprimido',
      frequencyType: 'diária',
      frequencyValue: 1,
      duration: 10,
      quantity: 1,
      firstMedication: 'Sim',
    ));
    var medicationBeforeDelete = await medicationDao.getById(insertedId);
    expect(medicationBeforeDelete, isNotNull);

    final result = await medicationDao.delete(medicationBeforeDelete!);
    expect(result, 1);

    var medicationAfterDelete = await medicationDao.getById(insertedId);
    expect(medicationAfterDelete, isNull);
  });
}
