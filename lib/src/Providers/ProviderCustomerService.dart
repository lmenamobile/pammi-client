import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Support/Themes.dart';
import 'package:http/http.dart' as http;
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';

class ProviderCustomerService extends ChangeNotifier {
  final prefs = SharePreference();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _shedule = "";
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Themes> _ltsThemes = [];
  List<Themes> get ltsThemes => _ltsThemes;
  set ltsThemes(List<Themes> value) {
    _ltsThemes.addAll(value);
    notifyListeners();
  }


  String get shedule => _shedule;

  set shedule(String value) {
    _shedule = value;
    notifyListeners();
  }

  Future<dynamic> getThemes(int offset, bool scrolling) async {
    !scrolling?isLoading = true: false;

    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty
          ? "CO"
          : prefs.countryIdUser.toString(),
    };

    Map body = {"filter": "", "offset": offset, "limit": 10};

    final response = await http
        .post(Uri.parse(Constants.baseURL + "system-client-service/get-themes"),
            headers: header, body: jsonEncode(body))
        .timeout(Duration(seconds: 25))
        .catchError((error) {
      isLoading = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic> decodedJson = json.decode(response.body);
    List<Themes> themesTempList = [];

    if (response.statusCode == 200) {
      if (decodedJson['code'] == 100) {
        for (var item in decodedJson['data']['items']) {
          final theme = Themes.fromJson(item);
          themesTempList.add(theme);
        }
        ltsThemes.addAll(themesTempList);
        isLoading = false;
      } else {
        isLoading = false;
        return decodedJson['message'];
      }
    } else {
      isLoading = false;
      return decodedJson['message'];
    }
    notifyListeners();
  }


  Future<dynamic> getSchedules() async {

    isLoading = true;

    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
    };


    final response = await http.get(Uri.parse("${Constants.baseURL}system/get-schedule"),
        headers: header)
        .timeout(Duration(seconds: 25))
        .catchError((error) {
      isLoading = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic> decodedJson = json.decode(response.body);

    if (response.statusCode == 200) {
      if (decodedJson['code'] == 100) {
        shedule = decodedJson["data"]["schedule"];
        isLoading = false;
      } else {
        isLoading = false;
        throw decodedJson['message'];
      }
    } else {
      isLoading = false;
      throw decodedJson['message'];
    }
    notifyListeners();
  }
}
