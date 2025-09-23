import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/user.dart';

class UserController {
  String? name;
  DateTime? dataNasc;

  UserController({
    required this.name,
    required this.dataNasc,
  });

  Future<int> save() async {
    final user = User(id: null, name: name!, birthDate: dataNasc!);
    final userDao =
        UserDao(database: await DatabaseHelper.instance.database);
    return await userDao.insert(user);
  }
}