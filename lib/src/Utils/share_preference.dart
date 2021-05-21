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

  get cityIdUser {
    return _prefs.getString('cityIdUser') ?? "0";
  }

  set cityIdUser(String value) {
    _prefs.setString('cityIdUser', value);
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

  get stateOrder {
    return _prefs.getInt('stateOrder') ?? 1;
  }

  set stateOrder(int value) {
    _prefs.setInt('stateOrder', value);
  }

  get shopCar {
    return _prefs.getString('shopCar') ?? "0";
  }

  set shopCar(String value) {
    _prefs.setString('shopCar', value);
  }

  get dataUser {
    return _prefs.getString('dataUser') ?? "0";
  }

  set dataUser (String value) {
    _prefs.setString('dataUser', value);
  }

  get dataShopCar {
    return _prefs.getString('dataShopCar') ?? "0";
  }

  set dataShopCar (String value) {
    _prefs.setString('dataShopCar', value);
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


