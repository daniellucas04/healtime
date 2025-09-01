import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app/dao/user_dao.dart';
import 'package:app/models/user.dart';

import '../../helpers/memory_database.dart';

void main() {
  late Database db;
  late UserDao userDao;

  setUp(() async {
    db = await createTestDb();
    userDao = UserDao(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('User DAO should return a list of users', () async {
    await userDao.insert(User(name: 'Alice', nascimento: DateTime(1990, 1, 1)));
    await userDao.insert(User(name: 'Bob', nascimento: DateTime(1985, 6, 15)));

    final results = await userDao.getAll();

    expect(results, isA<List<User>>());
    expect(results.length, 2);
    expect(results[0].name, 'Alice');
    expect(results[1].name, 'Bob');
    expect(results[0].nascimento, DateTime(1990, 1, 1));
    expect(results[1].nascimento, DateTime(1985, 6, 15));
  });

  test('User DAO should insert a new user', () async {
    final result = await userDao
        .insert(User(name: 'Charlie', nascimento: DateTime(1995, 3, 20)));

    expect(result, isA<int>());
    expect(result, greaterThan(0));
  });

  test('User DAO should update a user', () async {
    final insertedId = await userDao
        .insert(User(name: 'David', nascimento: DateTime(1980, 7, 10)));

    var user =
        User(id: insertedId, name: 'Eve', nascimento: DateTime(1982, 9, 12));
    final result = await userDao.update(user);

    expect(result, 1);

    final updatedUser = await userDao.getById(insertedId);
    expect(updatedUser!.name, 'Eve');
    expect(updatedUser.nascimento, DateTime(1982, 9, 12));
  });

  test('User DAO should delete a user', () async {
    final insertedId = await userDao
        .insert(User(name: 'Frank', nascimento: DateTime(1975, 11, 5)));

    var userBeforeDelete = await userDao.getById(insertedId);
    expect(userBeforeDelete, isNotNull);

    final result = await userDao.delete(userBeforeDelete!);
    expect(result, 1);

    var userAfterDelete = await userDao.getById(insertedId);
    expect(userAfterDelete, isNull);
  });
}
