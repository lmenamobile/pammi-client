import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/ShopCart/ProductShopCart.dart';
import 'package:wawamko/src/Models/ShopCart/ShopCart.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:http/http.dart' as http;

class ProviderShopCart with ChangeNotifier{
  final prefs = SharePreference();

  bool _isLoadingCart = false;
  bool get isLoadingCart => this._isLoadingCart;
  set isLoadingCart(bool value) {
    this._isLoadingCart = value;
    notifyListeners();
  }

  ShopCart _shopCart;
  ShopCart get shopCart => this._shopCart;
  set shopCart(ShopCart value) {
    this._shopCart = value;
    notifyListeners();
  }

  Future getShopCart() async {
    this.isLoadingCart = true;
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    final response = await http
        .get(Constants.baseURL + 'cart/get-cart', headers: header)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      this.isLoadingCart = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        this.isLoadingCart = false;
        this.shopCart = ShopCart.fromJson(decodeJson['data']['cart']);
        return this.shopCart;
      } else {
        this.isLoadingCart = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingCart = false;
      throw decodeJson['message'];
    }
  }
}