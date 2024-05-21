import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wawamko/src/Models/Product/ProductFavorite.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';

class ProviderUser with ChangeNotifier {
  final prefs = SharePreference();

  bool _isLoadingUser = false;
  bool get isLoadingProducts => this._isLoadingUser;
  set isLoadingUser(bool value) {
    this._isLoadingUser = value;
    notifyListeners();
  }

  List<ProductFavorite> _ltsProductsFavorite= [];
  List<ProductFavorite> get ltsProductsFavorite => this._ltsProductsFavorite;
  set ltsProductsFavorite(List<ProductFavorite> value) {
    this._ltsProductsFavorite.addAll(value);
    notifyListeners();
  }

  Future<dynamic> getProductsFavorites(int offset,) async {
    this.isLoadingUser = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token":prefs.authToken.toString(),
    };
    Map jsonData = {
      'offset': offset,
      'limit': 20,
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "favorite/get-favorite-references"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingUser = false;
      throw Strings.errorServeTimeOut;
    });
    final List<ProductFavorite> listProducts = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final product = ProductFavorite.fromJson(item);
          listProducts.add(product);
        }
        this.isLoadingUser = false;
        this.ltsProductsFavorite = listProducts;
        return listProducts;
      } else {
        this.isLoadingUser = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingUser = false;
      throw decodeJson!['message'];
    }

  }

  Future<dynamic> saveAsFavorite(String idReferenceProduct) async {
    this.isLoadingUser = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token":prefs.authToken.toString(),
    };
    Map jsonData = {
      "referenceId": idReferenceProduct
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL+"favorite/save-favorite-reference"),headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingUser = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 201) {
      this.isLoadingUser = false;
      if (decodeJson!['code'] == 100) {
        return decodeJson['message'];
      } else {
        this.isLoadingUser = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingUser = false;
      throw decodeJson!['message'];
    }
  }

  Future<dynamic> deleteFavorite(String idReferenceProduct) async {
    this.isLoadingUser = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token":prefs.authToken.toString(),
    };
    final response = await http.delete(Uri.parse(Constants.baseURL+"favorite/delete-favorite-reference/$idReferenceProduct"),headers: header)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingUser = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoadingUser = false;
      if (decodeJson!['code'] == 100) {
        return decodeJson['message'];
      } else {
        this.isLoadingUser = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingUser = false;
      throw decodeJson!['message'];
    }
  }

}