import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:http/http.dart' as http;



class ProviderHome with ChangeNotifier {
  final prefs = SharePreference();


  String _version = "";
  String  get version => this._version;
  set version(String  value) {
    this._version = value;
    notifyListeners();
  }

  bool _isLoadingHome = false;
  bool get isLoadingHome => this._isLoadingHome;
  set isLoadingHome(bool value) {
    this._isLoadingHome = value;
    notifyListeners();
  }




  clearProviderHome(){
    this._isLoadingHome = false;
  }
}