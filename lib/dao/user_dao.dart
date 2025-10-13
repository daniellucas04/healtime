import 'dart:ffi';

import 'package:app/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  final Database database;
  String table = 'users';

  UserDao({required this.database});

  Future<int> insert(User user) async {
    return await database.insert(table, user.toMap());
  }

  Future<User?> findById(int id) async {
  final result = await database.query(
    'users',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (result.isNotEmpty) {
    return User.fromMap(result.first);
  }

  return null;
}

  Future<int> update(User user) async {
    return await database
        .update(table, user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> delete(User user) async {
    return await database.delete(table, where: 'id = ?', whereArgs: [user.id]);
  }

  Future<List<User>> getAll() async {
    final users = await database.query(table);
    return users.map((json) => User.fromMap(json)).toList();
  }

  Future<int> getActiveUser() async {
    var user = await database.query(table, where: 'active = ?', whereArgs: [1]);
    if (user.isNotEmpty) {
      var u = User.fromMap((user.first));
      return u.id!;
    }

    return 1;
  }

  Future<User?> getById(int id) async {
    final user = await database.query(table, where: 'id = ?', whereArgs: [id]);
    if (user.isNotEmpty) {
      return User.fromMap((user.first));
    }

    return null;
  }
}
