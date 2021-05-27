import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wawamko/src/Utils/ConstansApi.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';

class ProfileProvider with ChangeNotifier{

  final prefsUser = SharePreference();

  bool _isLoading = false;
  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  bool _isEditProfile = false;
  bool get isEditProfile => this._isEditProfile;
  set isEditProfile(bool value) {
    this._isEditProfile = value;
    notifyListeners();
  }


  Future<dynamic> updateUser(
      String name,
      String typeIdentification,
      String numberIdentification,
      String phone,
      String cityId,
      ) async {
    this.isLoading = true;
    Map params = {
    };
    if(name.isNotEmpty){
      params.addAll({"fullname": name});
    }
    if(typeIdentification.isNotEmpty&&numberIdentification.isNotEmpty){
     // params.addAll({'documentType': typeIdentification}); ojo cambiar por los de servicio
      params.addAll({'documentType': 'cc'});
      params.addAll({'document': numberIdentification});
    }
    if(phone.isNotEmpty){
      params.addAll({"phone": phone});
    }
    if(cityId.isNotEmpty){
      params.addAll({'cityId': cityId});
    }
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token":prefsUser.authToken.toString()
    };
    var body = jsonEncode(params);
    final response = await http.post(ConstantsApi.baseURL +  'profile/update-profile',
        headers: header, body: body).timeout(Duration(seconds: 10))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 201) {
      if (decodeJson['code'] == 100) {
        this.isLoading = false;
        return decodeJson['message'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }
  }

}