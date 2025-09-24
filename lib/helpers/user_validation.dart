import 'package:app/models/user.dart';

class UserValidation {
  final User user;

  UserValidation({required this.user});

  bool validate() {
    if (user.name == '') {
      return false;
    }

    if (user.birthDate == '') {
      return false;
    }

    return true;
  }
}
