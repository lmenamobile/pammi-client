import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Models/City.dart';
import 'package:wawamko/src/Models/CountryUser.dart';
import 'package:wawamko/src/Models/StatesCountry.dart';

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

  CountryUser _countrySelected;
  CountryUser get countrySelected => this._countrySelected;
  set countrySelected(CountryUser value) {
    this._countrySelected = value;
    this.ltsStatesCountries.clear();
    if(value!=null)getStates("", 0, this.countrySelected);
    notifyListeners();
  }

  List<CountryUser> _ltsCountries = List();
  List<CountryUser> get ltsCountries => this._ltsCountries;
  set ltsCountries(List<CountryUser> value) {
    this._ltsCountries.addAll(value);
    notifyListeners();
  }

  StatesCountry _stateCountrySelected;
  StatesCountry get stateCountrySelected => this._stateCountrySelected;
  set stateCountrySelected(StatesCountry value) {
    this._stateCountrySelected = value;
    this.ltsCities.clear();
    if(value!=null)getCities("", 0, this.stateCountrySelected);
    notifyListeners();
  }

  List<StatesCountry> _ltsStatesCountries = List();
  List<StatesCountry> get ltsStatesCountries => this._ltsStatesCountries;
  set ltsStatesCountries(List<StatesCountry> value) {
    this._ltsStatesCountries.addAll(value);
    notifyListeners();
  }

  City _citySelected;
  City get citySelected => this._citySelected;
  set citySelected(City value) {
    this._citySelected = value;
    notifyListeners();
  }

  List<City> _ltsCities = List();
  List<City> get ltsCities => this._ltsCities;
  set ltsCities(List<City> value) {
    this._ltsCities.addAll(value);
    notifyListeners();
  }

  List<Category> _ltsCategories = List();
  List<Category> get ltsCategories => this._ltsCategories;
  set ltsCategories(List<Category> value) {
    this._ltsCategories.addAll(value);
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
    final response = await http.post(Constants.baseURL + "location/get-countries",
        headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
          this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });

    final List<CountryUser> listCountry = List();
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
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
      throw decodeJson['message'];
    }

  }

  Future<dynamic> getStates(String filter, int offset, CountryUser country) async {
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
      "countryId": country.id
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Constants.baseURL + "location/get-states",
        headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    final List<StatesCountry> listStates = List();
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final state = StatesCountry.fromJson(item);
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
      throw decodeJson['message'];
    }


  }

  Future<dynamic> getCities(String filter, int offset, StatesCountry state) async {
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
        .post(Constants.baseURL + "location/get-cities",
        headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    final List<City> listCities = List();
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
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
      throw decodeJson['message'];
    }
  }

  Future<dynamic> getCategoriesInterest(String filter,int page,String countryCode) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token":prefs.accessToken.toString(),
    };
    Map jsonData = {
      "filter": filter,
      "offset" : page,
      "limit" : 20,
      "status": "active",
      "countryId": countryCode
    };
    var body = jsonEncode(jsonData);

    final response = await http.post(Constants.baseURL+"category/get-categories", headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    final List<Category> listCategories = List();
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final category = Category.fromJson(item);
          listCategories.add(category);
        }
        this.isLoadingSettings = false;
        this.ltsCategories= listCategories;
        return listCategories;
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson['message'];
    }
  }

  Future<dynamic> saveCategories(List<Category> myCategories) async {
    List<int> idCats = List();
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
    final response = await http.post(Constants.baseURL+"profile/save-interests",headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoadingSettings = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 201) {
      if (decodeJson['code'] == 100) {
        return decodeJson['message'];
      } else {
        this.isLoadingSettings = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoadingSettings = false;
      throw decodeJson['message'];
    }
  }




}