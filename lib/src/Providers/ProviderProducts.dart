import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Offer.dart';


import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';


/*

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

class ProviderProducts with ChangeNotifier{
  final prefs = SharePreference();


  bool _loading = false;


  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }



  bool _limitedQuantityError = false;
  bool get limitedQuantityError => this._limitedQuantityError;
  set limitedQuantityError(bool value) {
    this._limitedQuantityError = value;
    notifyListeners();
  }


  List<int> _unitsError = [];
  List<int> get unitsError => _unitsError;
  set unitsError(List<int> value) {
    for (final item in value) {
      if (!_unitsError.contains(item)) {
        _unitsError.add(item);
      }
    }
    notifyListeners();
  }


  removeUnit(int id){
    if(unitsError.contains(id))
    {
      unitsError.remove(id);
    }
    notifyListeners();
  }

  int _indexSliderImages = 0;
  int get indexSliderImages => this._indexSliderImages;
  set indexSliderImages(int value) {
    this._indexSliderImages = value;
    notifyListeners();
  }

  bool _isLoadingProducts = false;
  bool get isLoadingProducts => this._isLoadingProducts;
  set isLoadingProducts(bool value) {
    this._isLoadingProducts = value;
    notifyListeners();
  }

  int _unitsProduct = 1;
  int get unitsProduct => this._unitsProduct;
  set unitsProduct(int value) {
    this._unitsProduct = value;
    notifyListeners();
  }

  List<Product> _ltsProductsByCatalog = [];


  List<Product> get ltsProductsByCatalog => _ltsProductsByCatalog;

  set ltsProductsByCatalog(List<Product> value) {
    _ltsProductsByCatalog = value;
    notifyListeners();
  }

  List<Product> _ltsProductsByCategory = [];
  List<Product> get ltsProductsByCategory => this._ltsProductsByCategory;
  set ltsProductsByCategory(List<Product> value) {
    this._ltsProductsByCategory.addAll(value);
    notifyListeners();
  }

  List<Product> _ltsProductsRelationsByReference = [];
  List<Product> get ltsProductsRelationsByReference => this._ltsProductsRelationsByReference;
  set ltsProductsRelationsByReference(List<Product> value) {
    this._ltsProductsRelationsByReference.addAll(value);
    notifyListeners();
  }

  List<Reference>? _ltsReferencesProductSelected = [];
  List<Reference>? get ltsReferencesProductSelected => this._ltsReferencesProductSelected;
  set ltsReferencesProductSelected(List<Reference>? value) {
    this._ltsReferencesProductSelected = value;
    notifyListeners();
  }

  Product? _productDetail;
  Product? get productDetail => this._productDetail;
  set productDetail(Product? value) {
    this._productDetail = value;
    this.ltsReferencesProductSelected = this.productDetail!.references;
    notifyListeners();
  }

  Reference? _referenceProductSelected;
  Reference? get referenceProductSelected => this._referenceProductSelected;
  set referenceProductSelected(Reference? value) {
    this._referenceProductSelected = value;
    this.referenceProductSelected!.isSelected = !this.referenceProductSelected!.isSelected!;
    //updateListReferences(value);
   // this.imageReferenceProductSelected = this.productDetail?.images?.isNotEmpty == true ? this.productDetail!.images![0].url : "";
    this.imageReferenceProductSelected = value?.images?[0].url;
    notifyListeners();
  }


  int _idReference = 0;
  int get idReference => this._idReference;
  set idReference(int value) {
    this._idReference = value;
    notifyListeners();
  }


  String? _imageReferenceProductSelected = '';
  String? get imageReferenceProductSelected => this._imageReferenceProductSelected;
  set imageReferenceProductSelected(String? value) {
    this._imageReferenceProductSelected = value;
    notifyListeners();
  }

  //no actualiza la vista del bottomShett de referencias
  updateListReferences(Reference referenceSelected){
    var auxReference = this.ltsReferencesProductSelected!.firstWhereOrNull((reference) => reference == referenceSelected);
    if(auxReference!=null)this.ltsReferencesProductSelected!.firstWhereOrNull((reference) => reference == referenceSelected)?.isSelected = true;
    notifyListeners();
  }

  /*Seccion busqueda de productos home*/

  List<Product> _ltsProductsSearch = [];
  List<Product> get ltsProductsSearch => this._ltsProductsSearch;
  set ltsProductsSearch(List<Product> value) {
    this._ltsProductsSearch.addAll(value);
    notifyListeners();
  }
  /*-------------------------*/

  /*Seccion ofertas del dia*/

  List<Offer> _ltsOfferUnits = [];
  List<Offer> get ltsOfferUnits => this._ltsOfferUnits;
  set ltsOfferUnits(List<Offer> value) {
    this._ltsOfferUnits.addAll(value);
    notifyListeners();
  }

  List<Offer> _ltsOfferMix = [];
  List<Offer> get ltsOfferMix => this._ltsOfferMix;
  set ltsOfferMix(List<Offer> value) {
    this._ltsOfferMix.addAll(value);
    notifyListeners();
  }
  /*-------------------------*/

  int getRandomPosition(int lengthList){
    if(lengthList>0){
      Random random = new Random();
      return random.nextInt(lengthList);
    }else{
      return 0;
    }
  }


  Future<dynamic> getProductsSearch(
      String filter,
      int offset,
      String? idBrand,
      String? idCategory,
      String? idSubcategory,
      String? price,
      String? orderBy) async {
    this.isLoadingProducts = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      'filter': filter,
      'offset': offset,
      'limit': 20,
      "brandProviderId": idBrand??'',
      "subcategoryId": idSubcategory??'',
      "categoryId": idCategory??'',
      "price": price??'',
      "orderBy": orderBy??'',
      "userId": prefs.userID
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "product/get-products"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingProducts = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Product> listProducts = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['products']) {
          final product = Product.fromJson(item);
          listProducts.add(product);
        }
        this.isLoadingProducts = false;
        this.ltsProductsSearch = listProducts;
        return listProducts;
      } else {
        this.isLoadingProducts = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingProducts = false;
      throw decodeJson!['message'];
    }

  }

  Future<dynamic> getProductsByCatalogSeller(
      String idSeller,int page,String filter) async {
    this.isLoadingProducts = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      'sellerId': idSeller,
      'offset': page,
      'limit': 20,
      'filter': filter, //'brandId': brandSelectedCatalog == null ? "" : brandSelectedCatalog!.id
    };

    print("JSON DATA CATALOG $jsonData");

    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "seller/get-products"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingProducts = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Product> listProducts = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {

        for (var item in decodeJson['data']['items']) {
          final product = Product.fromJson(item);
          listProducts.add(product);
        }

        this.isLoadingProducts = false;
        ltsProductsByCatalog = listProducts;
        return listProducts;
      } else {
        if(page == 0){
          ltsProductsByCatalog = [];
        }
        this.isLoadingProducts = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingProducts = false;
      throw decodeJson!['message'];
    }

  }

  Future<dynamic> getProductsByCategory(
      String filter,
      int offset,
      String? brandId,
      String? idBrandProvider,
      String? idCategory,
      String? idSubcategory,
      String? price,
      String? orderBy) async {
    this.isLoadingProducts = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      'filter': filter,
      'offset': offset,
      'limit': 20,
      "brandId":brandId??'',
      "brandProviderId": idBrandProvider??'',
      "subcategoryId": idSubcategory??'',
      "categoryId": idCategory??'',
      "price": price??'',
      "orderBy": orderBy??'',
      "userId": prefs.userID
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "product/get-products"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingProducts = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Product> listProducts = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
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
      throw decodeJson!['message'];
    }

  }

  Future<dynamic> getProduct(String idProduct) async {
    this.isLoadingProducts = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };

    Map jsonData = {
      "brandProviderProductId":idProduct,
      "userId": prefs.userID
    };

    var body = jsonEncode(jsonData);

    final response = await http.post(Uri.parse(Constants.baseURL+"product/get-product"),headers: header,body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingProducts = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoadingProducts = false;
      if (decodeJson!['code'] == 100) {
        this.productDetail = Product.fromJson(decodeJson['data']['product']);
        return Product.fromJson(decodeJson['data']['product']);
      } else {
        this.isLoadingProducts = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingProducts = false;
      throw decodeJson!['message'];
    }
  }

  Future<dynamic> getProductsRelationByReference(
      int offset,
      String referenceId
   ) async {
    this.isLoadingProducts = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      'filter': '',
      'offset': offset,
      'limit': 20,
      "referenceId": referenceId,
      "userId": prefs.userID
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "product/get-relational-products"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingProducts = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Product> listProducts = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson?['code'] == 100) {
        for (var item in decodeJson?['data']['products']) {
          final product = Product.fromJson(item);
          listProducts.add(product);
        }
        this.isLoadingProducts = false;
        this.ltsProductsRelationsByReference = listProducts;
        return listProducts;
      } else {
        this.isLoadingProducts = false;
        throw decodeJson?['message'];
      }
    } else {
      this.isLoadingProducts = false;
      throw decodeJson?['message'];
    }

  }

  Future<dynamic> getOfferByType(
     String typeOffer,
      String brandId,
      int offset,
      ) async {
    this.isLoadingProducts = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      'filter': '',
      'offerType':typeOffer,
      "brandId": brandId,
      'offset': offset,
      'limit': 20,
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "offer/get-offers"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingProducts = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Offer> listOffers = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final offer = Offer.fromJson(item);
          listOffers.add(offer);
        }
        this.isLoadingProducts = false;
        return listOffers;
      } else {
        this.isLoadingProducts = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingProducts = false;
      throw decodeJson!['message'];
    }

  }



}*/