import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('https://shy-cherry-5704.fly.dev');

class AuthResult {
  final String? token;
  final bool isValid;

  AuthResult(this.token, this.isValid);
}

class Auth {
  static String? authToken;
  static Future<AuthResult> authenticate(String username, String password) async {
    try {
      final authData = await pb.collection('users').authWithPassword(
        username,
        password,
      );

      if (pb.authStore.isValid) {
        authToken = pb.authStore.token;
        return AuthResult(pb.authStore.token, true);
      } else {
        return AuthResult(null, false);
      }
    } catch (e) {
      return AuthResult(null, false);
    }
  }
}

