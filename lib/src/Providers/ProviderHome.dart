import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:http/http.dart' as http;



class ProviderHome with ChangeNotifier {
  final prefs = SharePreference();


  String _version = "";
  String  get version => this._version;
  set version(String  value) {
    this._version = value;
    notifyListeners();
  }

  bool _isLoadingHome = false;
  bool get isLoadingHome => this._isLoadingHome;
  set isLoadingHome(bool value) {
    this._isLoadingHome = value;
    notifyListeners();
  }




  List<Product> _ltsMostSelledProducts = [];
  List<Product> get ltsMostSelledProducts => this._ltsMostSelledProducts;
  set ltsMostSelledProducts(List<Product> value) {
    this._ltsMostSelledProducts = value;
    notifyListeners();
  }



  Future getProductsMostSelled() async {
    this.isLoadingHome = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    final response = await http.get(Uri.parse(Constants.baseURL + "home/get-most-selled-products"), headers: header, )
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingHome = false;
      throw Strings.errorServeTimeOut;
    });
    final List<Product> listProducts = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final product = Product.fromJson(item['product']);
          listProducts.add(product);
        }
        this.isLoadingHome = false;
        this.ltsMostSelledProducts = listProducts;
        return listProducts;
      } else {
        this.isLoadingHome = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingHome = false;
      throw decodeJson!['message'];
    }

  }

  clearProviderHome(){
    this._ltsMostSelledProducts = [];
    this._isLoadingHome = false;
  }
}