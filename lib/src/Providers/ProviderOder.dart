import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Order.dart';
import 'package:wawamko/src/Models/Order/OrderDeatil.dart';
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

  OrderDetail? _orderDetail;

  OrderDetail? get orderDetail => this._orderDetail;

  set orderDetail(OrderDetail? value) {
    this._orderDetail = value;
    notifyListeners();
  }

  List<Order> _lstOrders = [];
  List<Order> get lstOrders => this._lstOrders;
  set lstOrders(List<Order> value) {
    this._lstOrders.addAll(value);
    notifyListeners();
  }

  List<String?> _lstImagesBrands= [];
  List<String?> get lstImagesBrands => this._lstImagesBrands;
  set setImageBrand(String? value) {
    this._lstImagesBrands.add(value);
  }

  List<Order> _lstOrdersFinish = [];

  List<Order> get lstOrdersFinish => this._lstOrdersFinish;

  set lstOrdersFinish(List<Order> value) {
    this._lstOrdersFinish.addAll(value);
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
    final response = await http
        .post(Uri.parse(Constants.baseURL + "order/get-orders"),
            headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Order> listOrders = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
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
      throw decodeJson!['message'];
    }
  }

  Future<dynamic> getOrdersByStatus(String offset, bool status) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      'filter': "",
      'offset': offset,
      'limit': 20,
      "actives": status
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "order/get-orders"),
            headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Order> listOrders = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final order = Order.fromJson(item);
          listOrders.add(order);
        }
        this.isLoading = false;
        return listOrders;
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future<dynamic> getOrderDetail(String idOrder) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    final response = await http
        .get(Uri.parse(Constants.baseURL + "order/get-order/$idOrder"), headers: header)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);

    print("DETALLE DE ORDEN $decodeJson");
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson!['code'] == 100) {
        this.orderDetail = OrderDetail.fromJson(decodeJson['data']['order']);
        return OrderDetail.fromJson(decodeJson['data']['order']);
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future<dynamic> qualificationProvider(
      String? providerId, String qualification, String? suborderId) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      "providerId": providerId,
      "qualification": qualification,
      "suborderId": suborderId
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "provider/rate-provider"),
            headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        return decodeJson['message'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future<dynamic> qualificationProduct(String? idReference, String qualification,
      String? suborderId, String comment) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      "referenceId": idReference,
      "comment": comment,
      "qualification": qualification,
      "suborderId": suborderId
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "product/rate-product"),
            headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        return decodeJson['message'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future<dynamic> qualificationSeller(
      String? sellerID, String qualification, String? orderId) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      "sellerId": sellerID,
      "qualification": qualification,
      "orderId": orderId
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "seller/rate-seller"),
            headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        return decodeJson['message'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }
}
