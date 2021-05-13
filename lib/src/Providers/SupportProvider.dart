import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:wawamko/src/Models/Country.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Utils/ConstansApi.dart';
import 'package:wawamko/src/Utils/share_preference.dart';

import 'package:http/http.dart' as http;
import 'package:wawamko/src/Utils/utils.dart';


class SupportProvider {

  final _prefs = SharePreference();
  static final instance = SupportProvider._internal();
  bool connected;

  factory SupportProvider() {
    return instance;
  }

  SupportProvider._internal();

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
      "countryId": "CO"
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
      "countryId": "CO"
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


