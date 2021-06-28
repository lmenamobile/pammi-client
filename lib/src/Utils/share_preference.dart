import 'package:shared_preferences/shared_preferences.dart';

class SharePreference {

  static final SharePreference _instancia = new SharePreference._internal();

  factory SharePreference() {
    return _instancia;
  }

  SharePreference._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get userID {
    return _prefs.getString('userID') ?? "";
  }

  set userID(String value) {
    _prefs.setString('userID', value);
  }

  get referredCode {
    return _prefs.getString('referredCode') ?? "";
  }

  set referredCode(String value) {
    _prefs.setString('referredCode', value);
  }

  get countryIdUser {
    return _prefs.getString('countryIdUser') ?? "0";
  }

  set countryIdUser(String value) {
    _prefs.setString('countryIdUser', value);
  }

  get nameUser {
    return _prefs.getString('nameUser') ?? "0";
  }

  set nameUser(String value) {
    _prefs.setString('nameUser', value);
  }

  get token {
    return _prefs.getString('token') ?? "0";
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  get pushToken {
    return _prefs.getString('pushToken') ??'';
  }

  set pushToken(String value) {
    _prefs.setString('pushToken', value);
  }

  get dataUser {
    return _prefs.getString('dataUser') ?? "0";
  }

  set dataUser (String value) {
    _prefs.setString('dataUser', value);
  }




  get enableTour {
    return _prefs.getBool('enableTour') ?? true;
  }

  set enableTour (bool value) {
    _prefs.setBool('enableTour', value);
  }

  get authToken {
    return _prefs.getString('authToken') ?? "0";
  }

  set authToken(String value) {
    _prefs.setString('authToken', value);
  }

  get accessToken {
    return _prefs.getString('accessToken') ?? "0";
  }

  set accessToken(String value) {
    _prefs.setString('accessToken', value);
  }


}


