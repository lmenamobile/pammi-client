

import 'package:google_sign_in/google_sign_in.dart';

class GoogleSingInProvider {

  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  static Future<dynamic> singInWithGoogle() async{
    try {
      googleSingOut();
      final account = await (_googleSignIn.signIn());
      final googleKey = await account?.authentication;
      print(account);
      print(googleKey?.idToken);
      //return googleKey.idToken
      return account;
    }catch(error){
      print('Error login google:$error');
      return error;
    }
  }

  static Future googleSingOut()async{
    await _googleSignIn.signOut();
  }

}