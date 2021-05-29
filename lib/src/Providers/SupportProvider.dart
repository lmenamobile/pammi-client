import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:wawamko/src/Utils/ConstansApi.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:http/http.dart' as http;


class SupportProvider {

  final _prefs = SharePreference();
  static final instance = SupportProvider._internal();
  bool connected;

  factory SupportProvider() {
    return instance;
  }

  SupportProvider._internal();


  Future betSellerNotLogin(
      String name,
      String email,
      ) async {

    Map params = {
      "fullname": name,
      "email": email
    };
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Access-Token":_prefs.accessToken.toString(),
    };
    var body = jsonEncode(params);
    final response = await http
        .post(ConstantsApi.baseURL + 'profile/become-seller',
        headers: header, body: body)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 201) {
      if (decodeJson['code'] == 100) {
        return decodeJson['message'];
      } else {

        throw decodeJson['message'];
      }
    } else {
      throw decodeJson['message'];
    }
  }

  Future betSeller() async {

    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": _prefs.authToken.toString()
    };

    final response = await http
        .get(ConstantsApi.baseURL + 'profile/become-seller',
        headers: header)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 201) {
      if (decodeJson['code'] == 100) {
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      throw decodeJson['message'];
    }
  }

  Future<dynamic> getTermsAndConditions(BuildContext context) async {


    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":_prefs.accessToken.toString(),
    };



    Map jsonData = {
      "filter": "",
      "offset" : 0,
      "limit" : 10,
      "status": "active",
      "moduleType" : "client",
      "countryId": _prefs.cityIdUser
};


    var body = jsonEncode(jsonData);

    print("Parameters get Terms ${jsonData}");

    final response = await http.post(ConstantsApi.baseURL+"system/get-conditions",headers: header ,body: body).timeout(Duration(seconds: 25))
        .catchError((value){
      print("Ocurrio un errorTimeout"+value);
      throw Exception(value);
    });

    print("Json getConditions: ${response.body}");

    return response.body;
  }

  Future<dynamic> getQuestions(BuildContext context) async {


    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":_prefs.accessToken.toString(),
    };



    Map jsonData = {
      "filter": "",
      "offset" : 0,
      "limit" : 10,
      "status": "active",
      "moduleType" : "client",
      "countryId": _prefs.cityIdUser
    };


    var body = jsonEncode(jsonData);

    print("Parameters get questions ${jsonData}");

    final response = await http.post(ConstantsApi.baseURL+"system/get-frequent-questions",headers: header ,body: body).timeout(Duration(seconds: 25))
        .catchError((value){
      print("Ocurrio un errorTimeout"+value);
      throw Exception(value);
    });

    print("Json getQuestions: ${response.body}");

    return response.body;
  }





}


