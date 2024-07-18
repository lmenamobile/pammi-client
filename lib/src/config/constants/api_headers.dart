import 'package:wawamko/src/Utils/share_preference.dart';

class ApiHeaders{
  final _preferences = SharePreference();

  Map<String,String> getHeaderAuthToken() {
    return {"Content-Type": "application/json",
      'X-WA-Auth-Token': _preferences.authToken,
    'country': _preferences.countryIdUser};
  }

  Map<String,String> getHeaderAccessToken() {
    return  {"Content-Type": "application/json",
      'X-WA-Access-Token': _preferences.accessToken,
    'country': _preferences.countryIdUser};
  }

  Duration get timeOut => Duration(seconds: 45);
}