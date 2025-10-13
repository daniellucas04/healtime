import 'package:app/dao/usermedication_dao.dart';
import 'package:app/models/usermedication.dart';
import 'package:app/database/database_helper.dart';

class UserMedicationController {
  Future<void> linkUserToMedication(UsuarioMedicamento userMedication) async {
    final db = await DatabaseHelper.instance.database;
    final dao = UsuarioMedicamentoDao(database: db);
    await dao.insert(userMedication);
  }

  Future<void> unlinkUserFromMedication(
      UsuarioMedicamento userMedication) async {
    final db = await DatabaseHelper.instance.database;
    final dao = UsuarioMedicamentoDao(database: db);
    await dao.delete(userMedication);
  }
}
