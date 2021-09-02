import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:wawamko/src/Models/Support/QuestionsModel.dart';
import 'package:wawamko/src/Models/Support/TermsConditionsModel.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class SupportProvider with ChangeNotifier {
  final prefs = SharePreference();

  bool _isLoading = false;
  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  List<Question> _lstQuestion = List();
  List<Question> get lstQuestion => this._lstQuestion;
  set lstQuestion(List<Question> value) {
    this._lstQuestion.addAll(value);
    notifyListeners();
  }

  List<TermsAndConditions> _lstTermsAndConditions = List();
  List<TermsAndConditions> get lstTermsAndConditions => this._lstTermsAndConditions;
  set lstTermsAndConditions(List<TermsAndConditions> value) {
    this._lstTermsAndConditions.addAll(value);
    notifyListeners();
  }

  Future betSellerNotLogin(
    String name,
    String email,
  ) async {
    this.isLoading = true;
    Map params = {"fullname": name, "email": email};
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Access-Token": prefs.accessToken.toString(),
    };
    var body = jsonEncode(params);
    final response = await http
        .post(Constants.baseURL + 'profile/become-seller',
            headers: header, body: body)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 201) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }
  }

  Future betSeller() async {
    this.isLoading = true;
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    final response = await http
        .get(Constants.baseURL + 'profile/become-seller', headers: header)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 201) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }
  }

  Future getTermsAndConditions() async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
    };
    Map jsonData = {
      "filter": "",
      "offset": 0,
      "limit": 10,
      "status": "active",
      "moduleType": "client",
      "countryId": prefs.countryIdUser
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Constants.baseURL + "system/get-conditions", headers: header, body: body).timeout(Duration(seconds: 25)).catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });

    final List<TermsAndConditions> listTerms = List();
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final term = TermsAndConditions.fromJson(item);
          listTerms.add(term);
        }
        this.isLoading = false;
        this.lstTermsAndConditions = listTerms;
        return listTerms;
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }

  }

  Future<dynamic> getQuestions(String page) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
    };

    Map jsonData = {
      "filter": "",
      "offset":page,
      "limit": 20,
      "status": "active",
      "moduleType": "client",
      "countryId": prefs.countryIdUser
    };

    var body = jsonEncode(jsonData);

    final response = await http.post(Constants.baseURL + "system/get-frequent-questions", headers: header, body: body)
        .timeout(Duration(seconds: 25)).catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });

    final List<Question> listQuestions = List();
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final question = Question.fromJson(item);
          listQuestions.add(question);
        }
        this.isLoading = false;
        this.lstQuestion = listQuestions;
        return listQuestions;
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
