import 'package:app/dao/medication_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/medication.dart';

class MedicationController {
  String? name;
  String? type;
  String? frequencyType;
  int? frequencyValue;
  int? duration;
  int? quantity;
  String? firstMedication;

  Future<int> save(Medication medication) async {
    final MedicationDao medicationDao =
        MedicationDao(database: await DatabaseHelper.instance.database);

    return await medicationDao.insert(medication);
  }

  Future<int> update(Medication medication) async {
    final medicationDao =
        MedicationDao(database: await DatabaseHelper.instance.database);

    return medicationDao.update(medication);
  }

  Future<int> delete(Medication medication) async {
    final medicationDao =
        MedicationDao(database: await DatabaseHelper.instance.database);

    return medicationDao.delete(medication);
  }
}
