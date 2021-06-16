import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Brand.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:http/http.dart' as http;

class ProviderHome with ChangeNotifier {
  final prefs = SharePreference();

  bool _isLoadingHome = false;
  bool get isLoadingHome => this._isLoadingHome;
  set isLoadingHome(bool value) {
    this._isLoadingHome = value;
    notifyListeners();
  }

  int _indexBannerHeader = 0;
  int get indexBannerHeader => this._indexBannerHeader;
  set indexBannerHeader(int value) {
    this._indexBannerHeader= value;
    notifyListeners();
  }

  int _indexBannerFooter = 0;
  int get indexBannerFooter => this._indexBannerFooter;
  set indexBannerFooter(int value) {
    this._indexBannerFooter= value;
    notifyListeners();
  }

  List<Brand> _ltsBrands = List();
  List<Brand> get ltsBrands => this._ltsBrands;
  set ltsBrands(List<Brand> value) {
    this._ltsBrands.addAll(value);
    notifyListeners();
  }

  Future<dynamic> getBrands(String offset) async {
    this.isLoadingHome = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
    };
    Map jsonData = {
      'filter': "",
      'offset': offset,
      'limit': 20,
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Constants.baseURL + "home/get-brands",
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingHome = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Brand> listBrand = List();
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final brand = Brand.fromJson(item);
          listBrand.add(brand);
        }
        this.isLoadingHome = false;
        this.ltsBrands = listBrand;
        return listBrand;
      } else {
        this.isLoadingHome = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingHome = false;
      throw decodeJson['message'];
    }

  }
}