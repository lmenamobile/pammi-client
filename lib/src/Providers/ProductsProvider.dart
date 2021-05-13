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


class ProductsProvider {

  final _prefs = SharePreference();
  static final instance = ProductsProvider._internal();
  bool connected;

  factory ProductsProvider() {
    return instance;
  }

  ProductsProvider._internal();

  Future<dynamic> getCategories(BuildContext context) async {


    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":_prefs.accessToken.toString(),
    };



    Map jsonData = {
      "filter": "",
      "offset" : 0,
      "limit" : 20,
      "status": "active",
      "countryId": "CO"

    };


    var body = jsonEncode(jsonData);

    print("Parameters getCategories ${jsonData}");

    final response = await http.post(ConstantsApi.baseURL+"category/get-categories",headers: header ,body: body).timeout(Duration(seconds: 25))
        .catchError((value){
      print("Ocurrio un errorTimeout"+value);
      throw Exception(value);
    });

    print("Json getCategories: ${response.body}");

    return response.body;
  }

  Future<dynamic> saveCategories(BuildContext context,List<int> arrayIdCategories) async {


    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":_prefs.accessToken.toString(),
      "X-WA-Auth-Token":_prefs.authToken.toString()
    };



    Map jsonData = {
      "categories": arrayIdCategories,

    };


    var body = jsonEncode(jsonData);

    print("Parameters getCategories ${jsonData}");

    final response = await http.post(ConstantsApi.baseURL+"profile/save-interests",headers: header ,body: body).timeout(Duration(seconds: 25))
        .catchError((value){
      print("Ocurrio un errorTimeout"+value);
      throw Exception(value);
    });

    print("Json saveCategories: ${response.body}");

    return response.body;
  }


}


