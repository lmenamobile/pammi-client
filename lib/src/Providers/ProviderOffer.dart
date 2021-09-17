import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Models/Offer.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:http/http.dart' as http;

class ProviderOffer with ChangeNotifier {
  final prefs = SharePreference();

  bool _isLoading = false;
  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  int _totalUnits = 1;
  int get totalUnits => this._totalUnits;
  set totalUnits(int value) {
    this._totalUnits = value;
    notifyListeners();
  }

  Offer _detailOffer = Offer();
  Offer get detailOffer => this._detailOffer;
  set detailOffer(Offer value) {
    this._detailOffer = value;
    this.imageSelected = value.baseProducts[0].reference.images[0].url;
    notifyListeners();
  }

  String _imageSelected = '';
  String get imageSelected => this._imageSelected;
  set imageSelected(String value) {
    this._imageSelected = value;
    notifyListeners();
  }

  Future<dynamic> getDetailOffer(String idOffer) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    final response = await http.get(Constants.baseURL + "offer/get-offer/$idOffer",
        headers: header)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        this.detailOffer = Offer.fromJson(decodeJson['data']['offer']);
        this.isLoading = false;
        return Offer.fromJson(decodeJson['data']['offer']);
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