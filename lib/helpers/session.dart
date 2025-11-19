import 'package:app/dao/user_dao.dart';
import 'package:app/database/database_helper.dart';

class Session {
  static int? _activeUserId; // cache em memória

  static Future<int> getActiveUser() async {
    // se já temos em memória, retorna direto
    if (_activeUserId != null) {
      return _activeUserId!;
    }

    // senão, consulta no banco
    final db = await DatabaseHelper.instance.database;
    _activeUserId = await UserDao(database: db).getActiveUser();
    return _activeUserId!;
  }

  static Future<int> loadUser() async {
    return await getActiveUser();
  }

  static void setActiveUser(int id) {
    _activeUserId = id;
  }

  static void clearUser() {
    _activeUserId = null; // caso queira "deslogar"
  }
}
