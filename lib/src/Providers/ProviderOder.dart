import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Order.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:http/http.dart' as http;

class ProviderOrder with ChangeNotifier {
  final prefs = SharePreference();

  bool _isLoading = false;
  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  List<Order> _lstOrders = List();
  List<Order> get lstOrders => this._lstOrders;
  set lstOrders(List<Order> value) {
    this._lstOrders.addAll(value);
    notifyListeners();
  }

  Future<dynamic> getOrders(String offset) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      'filter': "",
      'offset': offset,
      'limit': 20,
      "actives": true
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Constants.baseURL + "order/get-orders",
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Order> listOrders = List();
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final order = Order.fromJson(item);
          listOrders.add(order);
        }
        this.isLoading = false;
        this.lstOrders = listOrders;
        return listOrders;
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