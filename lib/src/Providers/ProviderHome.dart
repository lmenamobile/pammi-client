import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Banner.dart';
import 'package:wawamko/src/Models/Brand.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
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

  List<Brand> _ltsBrands = [];
  List<Brand> get ltsBrands => this._ltsBrands;
  set ltsBrands(List<Brand> value) {
    this._ltsBrands.addAll(value);
    notifyListeners();
  }

  List<Banners> _ltsBanners = [];
  List<Banners> get ltsBanners => this._ltsBanners;
  set ltsBanners(List<Banners> value) {
    this._ltsBanners.addAll(value);
    notifyListeners();
  }

  List<Banners> _ltsBannersOffer = [];
  List<Banners> get ltsBannersOffer => this._ltsBannersOffer;
  set ltsBannersOffer(List<Banners> value) {
    this._ltsBannersOffer.addAll(value);
    notifyListeners();
  }

  List<Product> _ltsMostSelledProducts = [];
  List<Product> get ltsMostSelledProducts => this._ltsMostSelledProducts;
  set ltsMostSelledProducts(List<Product> value) {
    this._ltsMostSelledProducts = value;
    notifyListeners();
  }

  Future<dynamic> getBrands(String offset) async {
    this.isLoadingHome = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      'filter': "",
      'offset': offset,
      'limit': 20,
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "home/get-brands"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingHome = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Brand> listBrand = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
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
      throw decodeJson!['message'];
    }

  }

  Future<dynamic> getBannersGeneral(String offset) async {
    this.isLoadingHome = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      'filter': "",
      'offset': offset,
      'limit': 30,
      "countryId":prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser,
      "type": Constants.bannerGeneral
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "home/get-banners"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingHome = false;
      throw Strings.errorServeTimeOut;
    });
    final List<Banners> listBanner = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final banner = Banners.fromJson(item);
          listBanner.add(banner);
        }
        this.isLoadingHome = false;
        this.ltsBanners = listBanner;
        return listBanner;
      } else {
        this.isLoadingHome = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingHome = false;
      throw decodeJson!['message'];
    }

  }

  Future<dynamic> getBannersOffer(String offset) async {
    this.isLoadingHome = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      'filter': "",
      'offset': offset,
      'limit': 30,
      "countryId":prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser,
      "type": Constants.bannerOffer
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "home/get-banners"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingHome = false;
      throw Strings.errorServeTimeOut;
    });
    final List<Banners> listBanner = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final banner = Banners.fromJson(item);
          listBanner.add(banner);
        }
        this.isLoadingHome = false;
        this.ltsBannersOffer = listBanner;
        return listBanner;
      } else {
        this.isLoadingHome = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingHome = false;
      throw decodeJson!['message'];
    }

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
}