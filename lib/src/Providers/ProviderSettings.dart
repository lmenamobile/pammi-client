import 'dart:convert';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wawamko/src/Models/Bank.dart';
import 'package:wawamko/src/Models/Banner.dart';
import 'package:wawamko/src/Models/Campaign.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Models/City.dart';
import 'package:wawamko/src/Models/CountryUser.dart';
import 'package:wawamko/src/Models/Notifications.dart';
import 'package:wawamko/src/Models/StatesCountry.dart';
import 'package:wawamko/src/Models/SubCategory.dart';
import 'package:wawamko/src/Models/Training.dart';

import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/Strings.dart';

class ProviderSettings with ChangeNotifier{
  final prefs = SharePreference();

  bool _isLoadingSettings = false;
  bool get isLoading => this._isLoadingSettings;
  set isLoadingSettings(bool value) {
    this._isLoadingSettings = value;
    notifyListeners();
  }

  bool _hasConnection = true;
  bool get hasConnection => this._hasConnection;
  set hasConnection(bool value) {
    this._hasConnection = value;
    notifyListeners();
  }

  CountryUser? _countrySelected;
  CountryUser? get countrySelected => this._countrySelected;
  set countrySelected(CountryUser? value) {
    this._countrySelected = value;
    notifyListeners();
  }

  List<CountryUser> _ltsCountries = [];
  List<CountryUser> get ltsCountries => this._ltsCountries;
  set ltsCountries(List<CountryUser> value) {
    this._ltsCountries.addAll(value);
    notifyListeners();
  }

  StatesCountry? _stateCountrySelected;
  StatesCountry? get stateCountrySelected => this._stateCountrySelected;
  set stateCountrySelected(StatesCountry? value) {
    this._stateCountrySelected = value;
    notifyListeners();
  }

  List<StatesCountry> _ltsStatesCountries = [];
  List<StatesCountry> get ltsStatesCountries => this._ltsStatesCountries;
  set ltsStatesCountries(List<StatesCountry> value) {
    this._ltsStatesCountries.addAll(value);
    notifyListeners();
  }

  List<Training> _ltsTraining = [];
  List<Training> get ltsTraining => this._ltsTraining;
  set ltsTraining(List<Training> value) {
    this._ltsTraining.addAll(value);
    notifyListeners();
  }

  City? _citySelected;
  City? get citySelected => this._citySelected;
  set citySelected(City? value) {
    this._citySelected = value;
    notifyListeners();
  }

  List<City> _ltsCities = [];
  List<City> get ltsCities => this._ltsCities;
  set ltsCities(List<City> value) {
    this._ltsCities.addAll(value);
    notifyListeners();
  }

 Category? _selectCategory;
  Category? get selectCategory => this._selectCategory;
  set selectCategory(Category? value) {
    this._selectCategory = value;
    _ltsCategories.firstWhereOrNull((element) => element==value?element.isSelected=true:element.isSelected=false);
     ltsCategories.forEach((category) {
       if(category!=value)
         category.isSelected = false;
     });
    notifyListeners();
  }

  List<Category> _ltsCategories = [];
  List<Category> get ltsCategories => this._ltsCategories;
  set ltsCategories(List<Category> value) {
    this._ltsCategories.addAll(value);
    notifyListeners();
  }

  List<SubCategory> _ltsSubCategories = [];
  List<SubCategory> get ltsSubCategories => this._ltsSubCategories;
  set ltsSubCategories(List<SubCategory> value) {
    this._ltsSubCategories.addAll(value);
    notifyListeners();
  }

  List<Banners> _ltsBannersHighlights = [];
  List<Banners> get ltsBannersHighlights => this._ltsBannersHighlights;
  set ltsBannersHighlights(List<Banners> value) {
    this._ltsBannersHighlights.addAll(value);
    notifyListeners();
  }

  List<Campaign> _ltsBannersCampaign = [];
  List<Campaign> get ltsBannersCampaign => this._ltsBannersCampaign;
  set ltsBannersCampaign(List<Campaign> value) {
    this._ltsBannersCampaign.addAll(value);
    notifyListeners();
  }

  List<Bank> _ltsBanks = [];
  List<Bank> get ltsBanks => this._ltsBanks;
  set ltsBanks(List<Bank> value) {
    this._ltsBanks = value;
    notifyListeners();
  }

  List<Notifications> _ltsNotifications = [];
  List<Notifications> get ltsNotifications => this._ltsNotifications;
  set ltsNotifications(List<Notifications> value) {
    this._ltsNotifications.addAll(value);
    notifyListeners();
  }

  //Check if I accept the policies

  bool _checkPolicies = false;
  bool get checkPolicies => this._checkPolicies;
  set checkPolicies(bool value) {
    this._checkPolicies = value;
    notifyListeners();
  }

  selectNotification(int idNotification){
    var notification = this.ltsNotifications.firstWhere((element) => element.id == idNotification);
    notification.isSelected==true? notification.isSelected=false: notification.isSelected=true;
    notifyListeners();
  }

  Future<dynamic> getCountries(String filter, int offset) async {
    this.isLoadingSettings = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
    };
    Map jsonData = {
      'filter': filter,
      'offset': offset,
      'limit': 20,
      "status": "active"
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "location/get-countries"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
          this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });

    final List<CountryUser> listCountry = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final country = CountryUser.fromJson(item);
          listCountry.add(country);
        }
        this.isLoadingSettings = false;
        this.ltsCountries= listCountry;
        return listCountry;
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }

  }

  Future<dynamic> getStates(String filter, int offset, String? countryId) async {

    print("getStates");
    this.isLoadingSettings = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
    };
    Map jsonData = {
      'filter': filter,
      'offset': offset,
      'limit': 20,
      "status": "active",
      "countryId": countryId
    };

    print("jsonData: ${jsonData}");
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "location/get-states"),
        headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    final List<StatesCountry> listStates = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {

          final state = StatesCountry.fromJson(item);
          print("estados: ${state.name}");
          print("totalCities: ${state.totalCities}");
          listStates.add(state);
        }
        this.isLoadingSettings = false;
        this.ltsStatesCountries = listStates;
        return listStates;
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }


  }

  Future<dynamic> getCities(String filter, int offset, StatesCountry state) async {

    print("getCities getCities");
    isLoadingSettings = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
    };
    Map jsonData = {
      'filter': filter,
      'offset': offset,
      'limit': 20,
      "status": "active",
      "stateId": state.id
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "location/get-cities"),
        headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    final List<City> listCities = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          print("ciudad: ${item}");
          final city = City.fromJson(item);
          listCities.add(city);
        }
        this.isLoadingSettings = false;
        this.ltsCities= listCities;
        return listCities;
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }
  }

  Future<dynamic> getCategoriesInterest(String filter,int page,String countryCode) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      "filter": filter,
      "offset" : page,
      "limit" : 20,
      "status": "active",
      "countryId": countryCode
    };
    var body = jsonEncode(jsonData);

    final response = await http.post(Uri.parse(Constants.baseURL+"category/get-categories"), headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    final List<Category> listCategories = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final category = Category.fromJson(item);
          listCategories.add(category);
        }
        this.isLoadingSettings = false;
        this.ltsCategories= addCategoryAll(listCategories);
        return listCategories;
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }
  }

  List<Category>  addCategoryAll(List<Category> listCategories){
    Category categoryAll = Category(
      id: 0,
      category: "Otras Categorias",
      color: "FFFFFF",
      image: "https://wawamko.com/assets/images/categories/all.png",
    );

    listCategories.add(categoryAll);
    return listCategories;
  }

  Future<dynamic> getSubCategories(int page,String idCategory) async {
    this.isLoadingSettings = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      "filter": "",
      "offset" : page,
      "limit" : 20,
      "status": "active",
      "categoryId":idCategory
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL+"category/get-subcategories"), headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    final List<SubCategory> listSubCategories = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final subcategory = SubCategory.fromJson(item);
          listSubCategories.add(subcategory);
        }
        this.isLoadingSettings = false;
        this._ltsSubCategories= listSubCategories;
        return listSubCategories;
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }
  }

  Future<dynamic> saveCategories(List<Category> myCategories) async {
    List<int?> idCats = [];
    myCategories.forEach((element) {
      idCats.add(element.id);
    });
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token":prefs.authToken.toString()
    };
    Map jsonData = {
      "categories": idCats,
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL+"profile/save-interests"),headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 201) {
      if (decodeJson!['code'] == 100) {
        return decodeJson['message'];
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }
  }

  Future<dynamic> sendCommentProductNoFound(String email,String comment) async {
    this.isLoadingSettings = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":prefs.accessToken.toString(),
    };
    Map jsonData = {
      "email": email,
      "description": comment
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL+"system/notify-product-not-found"),headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoadingSettings = false;
      if (decodeJson!['code'] == 100) {
        return decodeJson['message'];
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }
  }

  Future<dynamic> getBannersHighlights(String offset) async {
    this.isLoadingSettings = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      'filter': "",
      'offset': offset,
      'limit': 20,
      "countryId":prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser,
      "type": Constants.bannerOffer
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "home/get-banners"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingSettings = false;
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
        this.isLoadingSettings = false;
        this.ltsBannersHighlights = listBanner;
        return listBanner;
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }

  }

  Future<dynamic> getBannersCampaign(String offset) async {
    this.isLoadingSettings = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      'filter': "",
      'offset': offset,
      'limit': 20,
      "countryId":prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser,
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "campaign/get-campaigns"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    final List<Campaign> listBanner = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final banner = Campaign.fromJson(item);
          listBanner.add(banner);
        }
        this.isLoadingSettings = false;
        this.ltsBannersCampaign = listBanner;
        return listBanner;
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }

  }

  Future<dynamic> getTrainings(int page) async {
    this.isLoadingSettings = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      "filter": "",
      "offset" : page,
      "limit" : 20,
      "countryId": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL+"system/get-trainings"), headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    final List<Training> listTrainings = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final training = Training.fromJson(item);
          listTrainings.add(training);
        }
        this.isLoadingSettings = false;
        this._ltsTraining = listTrainings;
        return listTrainings;
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }
  }

  Future<dynamic> getBanks() async {
    this.isLoadingSettings = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty?"CO":prefs.countryIdUser.toString(),
    };
    final response = await http.get(Uri.parse(Constants.baseURL + "payment/get-banks"),
        headers: header)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Bank> listBanks = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']) {
          final bank = Bank.fromJson(item);
          if(bank.bankCode!="0")
          listBanks.add(bank);
        }
        this.isLoadingSettings = false;
        this.ltsBanks = listBanks;
        return listBanks;
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }

  }

  Future<dynamic> getNotifications(int offset) async {
    this.isLoadingSettings = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      'filter': "",
      'offset': offset,
      'limit': 20,
      "state": "send"
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "notification/get-notifications"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Notifications> listNotifications = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final notification = Notifications.fromJson(item);
          listNotifications.add(notification);
        }
        this.isLoadingSettings = false;
        this.ltsNotifications= listNotifications;
        return listNotifications;
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }

  }

  Future<dynamic> deleteNotifications(List<Notifications> idsNotifications) async {
    List dataIDS = [];
    idsNotifications.forEach((element) {
      if(element.isSelected==true)
        dataIDS.add(element.id);
    });
    this.isLoadingSettings = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      "notifications": dataIDS
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(Constants.baseURL + "notification/delete-notifications"),
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoadingSettings = false;
      if (decodeJson!['code'] == 100) {
        return decodeJson['message'];
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson!['message'];
    }

  }


}