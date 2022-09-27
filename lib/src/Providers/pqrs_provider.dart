import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:wawamko/src/Models/Pqrs/response_pqrs.dart';
import 'package:wawamko/src/Models/Themes/subtheme_response.dart';
import 'package:wawamko/src/Models/Themes/theme_response.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/share_preference.dart';

class PQRSProvider with ChangeNotifier {

  bool _isLoadingPqrs = false;
  bool get isLoadingPqrs => _isLoadingPqrs;
  bool _isLoading = false;
  bool _isLoadingQuestions = false;
  bool _isRevealIdentity = false;
  DataCreatePqrs _dataCreatePqrs = DataCreatePqrs();
  List<TypeSupport> _typesSupport = [];
  TypeSupport _typeSupportSelected = TypeSupport();
  int _totalPages = 0;
  List<ItemTheme> _themesList = [];
  List<ItemPqrs> _listPqrs = [];
  List<ItemQuestionsSubTheme> _questionsSubTheme = [];
  bool get isLoading => _isLoading;
  SharePreference _prefs = SharePreference();



  bool get isLoadingQuestions => _isLoadingQuestions;
  List<ItemTheme> get themesList => _themesList;

  set isLoadingQuestions(bool value) {
    _isLoadingQuestions = value;
    notifyListeners();
  }

  bool get isRevealIdentity => _isRevealIdentity;

  set isRevealIdentity(bool value) {
    _isRevealIdentity = value;
    notifyListeners();
  }

  DataCreatePqrs get dataCreatePqrs => _dataCreatePqrs;

  set dataCreatePqrs(DataCreatePqrs value) {
    _dataCreatePqrs = value;
    notifyListeners();
  }

  List<TypeSupport> get typesSupport => _typesSupport;

  set typesSupport(List<TypeSupport> value) {
    _typesSupport = value;
    notifyListeners();
  }

  TypeSupport get typeSupportSelected => _typeSupportSelected;

  set typeSupportSelected(TypeSupport value) {
    _typeSupportSelected = value;
    notifyListeners();
  }

  int get totalPages => _totalPages;

  set totalPages(int value) {
    _totalPages = value;
    notifyListeners();
  }

  List<ItemPqrs> get listPqrs => _listPqrs;

  set listPqrs(List<ItemPqrs> value) {
    _listPqrs = value;
    notifyListeners();
  }

  List<ItemQuestionsSubTheme> get questionsSubTheme => _questionsSubTheme;

  set questionsSubTheme(List<ItemQuestionsSubTheme> value) {
    _questionsSubTheme = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  selectedTypeSupport(TypeSupport typeSupport){
    typesSupport.forEach((element) {
      if(element.typeSupport == typeSupport.typeSupport){
        element.selected = true;
        typeSupportSelected = element;
      }else{
        element.selected = false;
      }
    });
    notifyListeners();
  }

  initTypesSupport(){
    List<TypeSupport> typesSupportTemp = [];
    typesSupportTemp.addAll([
      TypeSupport(sendTypeSupport: "petition",typeSupport: "Petición",selected: false),
      TypeSupport(sendTypeSupport: "complaint",typeSupport: "Quejas",selected: false),
      TypeSupport(sendTypeSupport: "claim",typeSupport: "Reclamos",selected: false),
      TypeSupport(sendTypeSupport: "suggestion",typeSupport: "Sugerencias",selected: false),
    ]);
    typesSupport = typesSupportTemp;
  }

  set isLoadingPqrs(bool value) {
    _isLoadingPqrs = value;
    notifyListeners();
  }

  set themesList(List<ItemTheme> value) {
    _themesList.addAll(value);
    notifyListeners();
  }

  Future<dynamic> getThemes(
      bool scrolling,
      int offset,
      ) async {
    !scrolling ? isLoading = true : isLoading = false;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken,
      "X-WA-Auth-Token": _prefs.authToken,
      "country": _prefs.countryIdUser
    };

    Map body = {
      "filter": "",
      "offset": offset,
      "limit": 10,
    };

    final response = await http
        .post(Uri.parse(Constants.baseURL+Constants.apiGetThemes),
        headers: header, body: jsonEncode(body))
        .timeout(Duration(seconds: 10)).catchError((value){
      print("Ocurrio un errorTimeout"+value);
      isLoading = false;
      throw Exception(value);
    });

    Map<String, dynamic> decodedJson = json.decode(response.body);

    List<ItemTheme> tempThemesList = [];
    if (response.statusCode == 200) {
      if (decodedJson['code'] == 100) {
        for (var item in decodedJson['data']['items']) {
          final theme = ItemTheme.fromJson(item);
          tempThemesList.add(theme);
        }

        themesList.addAll(tempThemesList);
        isLoading = false;
      } else if (decodedJson['code'] == 102) {
        isLoading = false;
        return decodedJson['message'];
      } else {
        isLoading = false;
        return decodedJson['message'];
      }
    } else {
      isLoading = false;
      return decodedJson['message'];
    }
    notifyListeners();
  }


  Future<dynamic> getPqrs(String status,int offset,) async {
    if(offset == 0){
      isLoadingPqrs = true;
    }

    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken,
      "X-WA-Auth-Token": _prefs.authToken,
      "country": _prefs.countryIdUser
    };

    Map body = {
      "filter": "",
      "offset": offset,
      "limit": 20,
      "status": status,
    };

    final response = await http.post(Uri.parse(Constants.baseURL+Constants.apiGetPqrs),headers: header, body: jsonEncode(body))
        .timeout(Duration(seconds: 10)).catchError((value){
      print("Ocurrio un errorTimeout"+value);
      if(offset == 0){
        listPqrs = [];
      }
      isLoadingPqrs = false;
      throw Exception(value);
    });

    Map<String, dynamic> decodedJson = json.decode(response.body);

    if (response.statusCode == 200) {
      if (decodedJson['code'] == 100) {
        ResponsePqrs data = ResponsePqrs.fromJson(decodedJson);
        totalPages = data.data?.totalPages ?? 0;
        if(offset == 0){
          listPqrs = data.data?.items ?? [];
        }else{
          data.data?.items?.forEach((element) {
            listPqrs.add(element);
          });
          notifyListeners();
        }
        isLoadingPqrs = false;
      } else {
        if(offset == 0){
          listPqrs = [];
        }
        isLoadingPqrs = false;
        return decodedJson['message'];
      }
    } else {
      if(offset == 0){
        listPqrs = [];
      }
      isLoadingPqrs = false;
      return decodedJson['message'];
    }

  }

  Future<dynamic> createPQRS(String supportType,String subject,String message,bool identity) async {
    isLoadingPqrs = true;

    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken,
      "X-WA-Auth-Token": _prefs.authToken,
      "country": _prefs.countryIdUser
    };

    Map body = {
      "supportType": supportType,
      "subject": subject,
      "message": message,
      "identity": identity,
    };

    final response = await http.post(Uri.parse(Constants.baseURL+Constants.apiCreatePqrs),headers: header, body: jsonEncode(body))
        .timeout(Duration(seconds: 10)).catchError((value){
      print("Ocurrio un errorTimeout"+value);
      dataCreatePqrs = DataCreatePqrs();
      isLoadingPqrs = false;
      throw Exception(value);
    });

    Map<String, dynamic> decodedJson = json.decode(response.body);

    if (response.statusCode == 200) {
      if (decodedJson['code'] == 100) {
        ResponseCreatePqrs data = ResponseCreatePqrs.fromJson(decodedJson);
        dataCreatePqrs = data.data!;
        isLoadingPqrs = false;
        return "OK";
      } else {
        dataCreatePqrs = DataCreatePqrs();
        isLoadingPqrs = false;
        return decodedJson['message'];
      }
    } else {
      dataCreatePqrs = DataCreatePqrs();
      isLoadingPqrs = false;
      return decodedJson['message'];
    }

  }

  Future<dynamic> getQuestionsBySubTheme(
      int id, int offset) async {

    isLoadingQuestions = true;

    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken,
      "X-WA-Auth-Token": _prefs.authToken,
      "country": _prefs.countryIdUser
    };
    Map body = {
      "offset": offset,
      "limit": 10,
      "subthemeId": id,
    };
    final response = await http
        .post(Uri.parse(   Constants.apiGetQuestionsBySubtheme),
        headers: header, body: jsonEncode(body))
        .timeout(Duration(seconds: 20)).catchError((value){
      print("Ocurrio un errorTimeout"+value);
      isLoadingQuestions = false;
      throw Exception(value);
    });

    Map<String, dynamic> decodedJson = json.decode(response.body);

    if(response.statusCode == 200){
      if(decodedJson['code'] == 100){
        ResponseSubThemes data = ResponseSubThemes.fromJson(decodedJson);
        totalPages = data.data!.totalPages!;
        if(offset == 0){
          questionsSubTheme = data.data!.itemsQuestions!;
        }else{
          data.data?.itemsQuestions?.forEach((element) {
            questionsSubTheme.add(element);
          });
          notifyListeners();
        }
        isLoadingQuestions = false;
      } else {
        questionsSubTheme = [];
        isLoadingQuestions = false;
        return decodedJson['message'];
      }
    } else {
      questionsSubTheme = [];
      isLoadingQuestions = false;
      return decodedJson['message'];
    }

  }

}