import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/user.dart';
import 'package:sqflite/sqlite_api.dart';

class UserController {
  String? name;
  String? dataNasc;

  Future<int> save(User user) async {
    final userDao = UserDao(database: await DatabaseHelper.instance.database);
    return await userDao.insert(user);
  }

  Future<int> update(User user) async {
    final userDao = UserDao(database: await DatabaseHelper.instance.database);

    return userDao.update(user);
  }

  Future<int> delete(User user) async {
    final userDao = UserDao(database: await DatabaseHelper.instance.database);

    return userDao.delete(user);
  }

  Future<User?> getById(int id) async {
    final userDao = UserDao(database: await DatabaseHelper.instance.database);
    return userDao.getById(id);
  }
}
