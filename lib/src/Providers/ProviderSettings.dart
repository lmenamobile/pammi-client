import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wawamko/src/Models/CountryUser.dart';

import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/Strings.dart';

class ProviderSettings with ChangeNotifier{
  final prefs = SharePreference();

  bool _isLoadingSettings = false;
  bool get isLoading => this._isLoadingSettings;
  set isLoadingSettings(bool value) {
    this._isLoadingSettings = value;
    notifyListeners();
  }

  List<CountryUser> _ltsCountries = List();
  List<CountryUser> get ltsCountries => this._ltsCountries;
  set ltsCountries(List<CountryUser> value) {
    this._ltsCountries.addAll(value);
    notifyListeners();
  }

  Future<dynamic> getCountries(String filter, int offset) async {
    this.isLoadingSettings = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
    };
    Map jsonData = {
      'filter': filter,
      'offset': offset,
      'limit': 20,
      "status": "active"
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Constants.baseURL + "location/get-countries",
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
          this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });

    final List<CountryUser> listCountry = List();
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final country = CountryUser.fromJson(item);
          listCountry.add(country);
        }
        this.isLoadingSettings = false;
        this.ltsCountries= listCountry;
        return listCountry;
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson['message'];
    }

  }

}