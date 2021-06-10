
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:http/http.dart' as http;

class ProviderAddress with ChangeNotifier {

  final prefsUser = SharePreference();

  bool _isLoading = false;
  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  Future getLtsMyAddress(String page) async {
    this.isLoading = true;
    Map params = {
      "limit":"20",
      "offset":page,
      'filter':"",
      'status':"active",
    };
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefsUser.authToken.toString()
    };
    var body = jsonEncode(params);
    final response = await http.post(Constants.baseURL  + 'profile/get-addresses',
        headers: header,body: body)
        .timeout(Duration(seconds: 10)).catchError((value) {this.isLoading = false;throw Strings.errorServeTimeOut;});
/*    final List<Address> listAddress = List();
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final card = CreditCard.fromJson(item);
          listCards.add(card);
        }
        this.isLoading = false;
        this.ltsCreditCards = listCards;
        return listCards;
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }*/

  }


}