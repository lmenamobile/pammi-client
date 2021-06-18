import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';

class ProviderProducts with ChangeNotifier{
  final prefs = SharePreference();

  bool _isLoadingProducts = false;
  bool get isLoadingProducts => this._isLoadingProducts;
  set isLoadingProducts(bool value) {
    this._isLoadingProducts = value;
    notifyListeners();
  }

  List<Product> _ltsProductsByCategory = List();
  List<Product> get ltsProductsByCategory => this._ltsProductsByCategory;
  set ltsProductsByCategory(List<Product> value) {
    this._ltsProductsByCategory.addAll(value);
    notifyListeners();
  }

  Future<dynamic> getProductsByCategory(
      String filter,
      int offset,
      String idBrand,
      String idCategory,
      String idSubcategory,
      String price,
      String orderBy) async {
    this.isLoadingProducts = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
    };
    Map jsonData = {
      'filter': filter,
      'offset': offset,
      'limit': 20,
      "brandProviderId": idBrand??'',
      "subcategoryId": idSubcategory,
      "categoryId": idCategory,
      "price": price??'',
      "orderBy": orderBy??''
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Constants.baseURL + "product/get-products",
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingProducts = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Product> listProducts = List();
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        for (var item in decodeJson['data']['products']) {
          final product = Product.fromJson(item);
          listProducts.add(product);
        }
        this.isLoadingProducts = false;
        this.ltsProductsByCategory = listProducts;
        return listProducts;
      } else {
        this.isLoadingProducts = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingProducts = false;
      throw decodeJson['message'];
    }

  }

}