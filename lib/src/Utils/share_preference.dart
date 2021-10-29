import 'package:shared_preferences/shared_preferences.dart';

class SharePreference {

  static final SharePreference _instancia = new SharePreference._internal();

  factory SharePreference() {
    return _instancia;
  }

  SharePreference._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  clearPrefs()async{
    await this._prefs.clear();
  }

  String get userID {
    return _prefs.getString('userID') ?? "";
  }

  set userID(String value) {
    _prefs.setString('userID', value);
  }

  String get referredCode {
    return _prefs.getString('referredCode') ?? "";
  }

  set referredCode(String value) {
    _prefs.setString('referredCode', value);
  }

  String get codeShare {
    return _prefs.getString('code') ?? "";
  }

  set codeShare(String value) {
    _prefs.setString('code', value);
  }

  String get countryIdUser {
    return _prefs.getString('countryIdUser') ?? "0";
  }

  set countryIdUser(String value) {
    _prefs.setString('countryIdUser', value);
  }

  String get nameUser {
    return _prefs.getString('nameUser') ?? "0";
  }

  set nameUser(String value) {
    _prefs.setString('nameUser', value);
  }

  String get token {
    return _prefs.getString('token') ?? "0";
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  String get pushToken {
    return _prefs.getString('pushToken') ??'';
  }

  set pushToken(String value) {
    _prefs.setString('pushToken', value);
  }

  String get photoUser {
    return _prefs.getString('photoUser') ??'';
  }

  set photoUser(String value) {
    _prefs.setString('photoUser', value);
  }

  String get dataUser {
    return _prefs.getString('dataUser') ?? "0";
  }

  set dataUser (String value) {
    _prefs.setString('dataUser', value);
  }




 bool get enableTour {
    return _prefs.getBool('enableTour') ?? true;
  }

  set enableTour (bool value) {
    _prefs.setBool('enableTour', value);
  }

  String get authToken {
    return _prefs.getString('authToken') ?? "0";
  }

  set authToken(String value) {
    _prefs.setString('authToken', value);
  }

  String get accessToken {
    return _prefs.getString('accessToken') ?? "0";
  }

  set accessToken(String value) {
    _prefs.setString('accessToken', value);
  }


}


