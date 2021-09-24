import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSingInProvider {

  static Future<dynamic> singIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ]);
      print("Este es el codigo ${credential.authorizationCode}");

      return credential.authorizationCode;
    } catch (e) {
      print('Error en login con apple ${e.toString()}');
      print(e.toString());
    }
  }
}
