import 'package:app/dao/usermedication_dao.dart';
import 'package:app/models/usermedication.dart';
import 'package:app/database/database_helper.dart';

class UserMedicationController {
  Future<void> linkUserToMedication(UserMedication userMedication) async {
    final db = await DatabaseHelper.instance.database;
    final dao = UserMedicationDao(database: db);
    await dao.insert(userMedication);
  }

  Future<void> unlinkUserFromMedication(UserMedication userMedication) async {
    final db = await DatabaseHelper.instance.database;
    final dao = UserMedicationDao(database: db);
    await dao.delete(userMedication);
  }

  Future<List<Map<String, dynamic>>> getUserFromMedication(id) async {
    final db = await DatabaseHelper.instance.database;
    final dao = UserMedicationDao(database: db);
    return await dao.getByUserId(id);
  }

  Future<List<Map<String, dynamic>>> getMedicationFromUser(id) async {
    final db = await DatabaseHelper.instance.database;
    final dao = UserMedicationDao(database: db);
    return await dao.getByMedicationId(id);
  }
}
