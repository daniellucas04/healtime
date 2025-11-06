import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class Authenticate {
  static requestAuth() async {
    final LocalAuthentication _localAuth = LocalAuthentication();

    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;

      if (!canCheckBiometrics) {
        return false;
      }

      bool authenticated = await _localAuth.authenticate(
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            biometricSuccess: 'Autenticação realizada com sucesso!',
            signInTitle: 'Autenticação',
            biometricHint: '',
          ),
          IOSAuthMessages(),
        ],
        localizedReason: 'Realize a autenticação para liberar este recurso',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      return authenticated;
    } catch (e) {
      return false;
    }
  }
}
