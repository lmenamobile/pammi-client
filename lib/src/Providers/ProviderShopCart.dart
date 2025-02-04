import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/GiftCard.dart';
import 'package:wawamko/src/Models/ShopCart/ProductShopCart.dart';
import 'package:wawamko/src/Models/ShopCart/ShopCart.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:http/http.dart' as http;

class ProviderShopCart with ChangeNotifier{
  final prefs = SharePreference();

  bool _isLoadingCart = false;
  bool _loading = true;
  bool get isLoadingCart => this._isLoadingCart;
  set isLoadingCart(bool value) {
    this._isLoadingCart = value;
    notifyListeners();
  }


  bool _hasPrincipalAddress = false;
  bool get hasPrincipalAddress => _hasPrincipalAddress;
  set hasPrincipalAddress(bool value) {
    _hasPrincipalAddress = value;
    notifyListeners();
  }





  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String _totalProductsCart = "0";
  String get totalProductsCart => this._totalProductsCart;
  set totalProductsCart(String value) {
    this._totalProductsCart = value;
    notifyListeners();
  }

  String _discountShipping = "0";
  String get discountShipping => this._discountShipping;

  set discountShipping(String value) {
    this._discountShipping = value;
    notifyListeners();
  }

  ShopCart? _shopCart;
  ShopCart? get shopCart => this._shopCart;
  set shopCart(ShopCart? value) {

    this._shopCart = value;
    if(shopCart!=null) {
      //value!.packagesProvider[
      totalProductsCart = value!.products!.length.toString();
    }
    notifyListeners();
  }

  List<GiftCard> _ltsGiftCard = [];
  List<GiftCard> get ltsGiftCard => this._ltsGiftCard;
  set ltsGiftCard(List<GiftCard> value) {
    this._ltsGiftCard.addAll(value);
    notifyListeners();
  }
  List<ProductShopCart> _ltsProductsSave = [];
  List<ProductShopCart> get ltsProductsSave => this._ltsProductsSave;


  set ltsProductsSave(List<ProductShopCart> value) {
    this._ltsProductsSave.addAll(value);
    notifyListeners();
  }

  Future getShopCart(int idPaymentmethod) async {
    this.isLoadingCart = true;
    loading = true;
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefs.authToken.toString()
    };

    Map jsonData = {
      "methodPaymentId": idPaymentmethod,
      "userId" : prefs.userID,
    };

    var body = jsonEncode(jsonData);

    final response = await http
        .post(Uri.parse(Constants.baseURL + 'cart/get-cart'), headers: header,body: body)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      this.isLoadingCart = false;
      loading = false;
      throw Strings.errorServeTimeOut;
    });


    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        this.shopCart = ShopCart.fromJson(decodeJson['data']['cart']);
        this.discountShipping = decodeJson['data']['cart']['cart']['discountShipping'].toString();
        this.isLoadingCart = false;
        loading = false;
        return this.shopCart;
      } else {
        this.shopCart = null;
        this.isLoadingCart = false;
        loading = false;
        throw decodeJson['message'];
      }
    } else {
      this.shopCart = null;
      loading = false;
      this.isLoadingCart = false;
      throw decodeJson['message'];
    }
  }

  Future getGiftCards(int page,String? categoryId, String? price) async {
    this.isLoadingCart = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      "filter": "",
      "offset" : page,
      "limit" : 20,
      "categoryId": categoryId??'',
      "price": price??''
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL+"giftcard/get-giftcards"), headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingCart = false;
      throw Strings.errorServeTimeOut;
    });
    final List<GiftCard> listGiftCard = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['giftcards']) {
          final gift = GiftCard.fromJson(item);
          listGiftCard.add(gift);
        }
        this.isLoadingCart = false;
        this._ltsGiftCard = listGiftCard;
        return listGiftCard;
      } else {
        this.isLoadingCart = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingCart = false;
      throw decodeJson!['message'];
    }
  }

  Future updateQuantityProductCart(String referenceId,String units) async {
    this.isLoadingCart = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      "referenceId": referenceId,
      "qty": units
    };

    print("ver jsonData del carrito $jsonData");
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "cart/add-product"), headers: header, body: body)
        .timeout(Duration(seconds: 15)).catchError((value) {
      this.isLoadingCart = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic>? decodeJson = json.decode(response.body);
    print("ver producto del carrito $decodeJson");

    if (response.statusCode == 200) {
      this.isLoadingCart = false;
      if (decodeJson!['code'] == 100) {
        //getShopCart();
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingCart = false;
      throw decodeJson!['message'];
    }
  }

  Future deleteProductCart(String referenceId) async {
    this.isLoadingCart = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    final response = await http
        .delete(Uri.parse(Constants.baseURL + "cart/delete-product/$referenceId"), headers: header)
        .timeout(Duration(seconds: 15)).catchError((value) {
      this.isLoadingCart = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoadingCart = false;
      if (decodeJson!['code'] == 100) {
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingCart = false;
      throw decodeJson!['message'];
    }
  }

  Future deleteCart() async {
    this.isLoadingCart = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    final response = await http
        .delete(Uri.parse(Constants.baseURL + "cart/delete-cart"), headers: header)
        .timeout(Duration(seconds: 15)).catchError((value) {
      this.isLoadingCart = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoadingCart = false;
      if (decodeJson!['code'] == 100) {
        this.totalProductsCart = "0";
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingCart = false;
      throw decodeJson!['message'];
    }
  }

  Future saveReference(String referenceId,String quantity) async {
    this.isLoadingCart = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      "referenceId": referenceId,
      "qty": quantity
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "product/save-reference"), headers: header,body: body )
        .timeout(Duration(seconds: 15)).catchError((value) {
      this.isLoadingCart = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 201) {
      this.isLoadingCart = false;
      if (decodeJson['code'] == 100) {
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingCart = false;
      throw decodeJson['message'];
    }
  }

  Future deleteReference(String referenceId) async {
    this.isLoadingCart = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    final response = await http
        .delete(Uri.parse(Constants.baseURL + "product/delete-saved-reference/$referenceId"), headers: header)
        .timeout(Duration(seconds: 15)).catchError((value) {
      this.isLoadingCart = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoadingCart = false;
      if (decodeJson!['code'] == 100) {
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingCart = false;
      throw decodeJson!['message'];
    }
  }

  Future getLtsReferencesSave(int page) async {
    this.isLoadingCart = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      "offset" : page,
      "limit" : 20,
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL+"product/get-saved-references"), headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingCart = false;
      throw Strings.errorServeTimeOut;
    });
     List<ProductShopCart> listProductsSave = [];
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final reference = ProductShopCart.fromJson(item);
          listProductsSave.add(reference);
        }
        this.isLoadingCart = false;
        this._ltsProductsSave = listProductsSave;
        return listProductsSave;
      } else {
        this.isLoadingCart = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingCart = false;
      //throw decodeJson['message'].toString();
    }
  }


  Future addOfferCart(String offerId,String units,int idPaymentMethod) async {
    this.isLoadingCart = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      "offerId": offerId,
      "qty": units
    };
    var body = jsonEncode(jsonData);
    print("ver valores de oferta ${jsonData}");
    final response = await http
        .post(Uri.parse(Constants.baseURL + "cart/add-offer"), headers: header, body: body)
        .timeout(Duration(seconds: 15)).catchError((value) {
      this.isLoadingCart = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoadingCart = false;
      if (decodeJson!['code'] == 100) {
        getShopCart(idPaymentMethod);
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingCart = false;
      throw decodeJson!['message'];
    }
  }

  Future addGiftCard(String giftCardId,String units) async {
    this.isLoadingCart = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      "giftcardId": giftCardId,
      "qty": units
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "cart/add-giftcard"), headers: header, body: body)
        .timeout(Duration(seconds: 15)).catchError((value) {
      this.isLoadingCart = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoadingCart = false;
      if (decodeJson!['code'] == 100) {
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingCart = false;
      throw decodeJson!['message'];
    }
  }


}