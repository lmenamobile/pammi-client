import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:wawamko/src/Models/Address.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:http/http.dart' as http;


class UserProvider {

  final _prefs = SharePreference();
  static final instance = UserProvider._internal();
  bool? connected;

  factory UserProvider() {
    return instance;
  }

  UserProvider._internal();

  Future<dynamic> addAddress(String address,String lat, String long,String complement,String nameAddress,String cityId) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":_prefs.accessToken.toString(),
      "X-WA-Auth-Token":_prefs.authToken.toString()
    };

    Map jsonData = {
      'address':address.toString(),
      'latitude':lat,
      'longitude':long,
      'complement':complement,
      'name':nameAddress,
      "principal" : true,
      'cityId':cityId
    };
    var body = jsonEncode(jsonData);

    final response = await http.post(Uri.parse(Constants.baseURL+"profile/create-address"),headers: header ,body: body).timeout(Duration(seconds: 25))
        .catchError((value){
      print("Ocurrio un errorTimeout"+value);
      throw Exception(value);
    });



    return response.body;
  }

  Future<dynamic> getAddress(BuildContext context,int page) async {


    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":_prefs.accessToken.toString(),
      "X-WA-Auth-Token":_prefs.authToken.toString()
    };



    Map jsonData = {
      'filter':"",
      'offset':page,
      'limit':20,
      'status':"active",

    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL+"profile/get-addresses"),headers: header ,body: body).timeout(Duration(seconds: 25))
        .catchError((value){
      print("Ocurrio un errorTimeout"+value);
      throw Exception(value);
    });
    return response.body;
  }

  Future<dynamic> changeStatusAddress(BuildContext context,Address address) async {


    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":_prefs.accessToken.toString(),
      "X-WA-Auth-Token":_prefs.authToken.toString()
    };

    final response = await http.put(Uri.parse(Constants.baseURL+"profile/change-status/${address.id}"),headers: header ).timeout(Duration(seconds: 25))
        .catchError((value){
      print("Ocurrio un errorTimeout"+value);
      throw Exception(value);
    });

    print("Json changeStatusAddress: ${response.body}");

    return response.body;
  }

  Future<dynamic> updateAddress(BuildContext context,String address,String lat, String long,String complement,String nameAddress, String cityId, Address addressModel ) async {


    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":_prefs.accessToken.toString(),
      "X-WA-Auth-Token":_prefs.authToken.toString()
    };



    Map jsonData = {
      'address':address,
      'name':nameAddress,
      'complement':complement,
      'latitude':lat,
      'longitude':long,
      "principal" : true,
      'cityId': cityId
    };


    var body = jsonEncode(jsonData);



    final response = await http.put(Uri.parse(Constants.baseURL+"profile/update-address/${addressModel.id}"),headers: header ,body: body).timeout(Duration(seconds: 25))
        .catchError((value){
      throw Exception(value);
    });
    return response.body;
  }
}


