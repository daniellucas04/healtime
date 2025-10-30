import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';

class Session {
  static Future<int> getActiveUser() async {
    return await UserDao(database: await DatabaseHelper.instance.database)
        .getActiveUser();
  }

  static Future<int> loadUser() async {
    return await getActiveUser();
  }
}
