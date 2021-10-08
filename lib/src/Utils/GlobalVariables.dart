

import 'package:flutter/material.dart';


class GlobalVariables {

  static final GlobalVariables _instance = GlobalVariables._internal();
  factory GlobalVariables() => _instance;

  GlobalVariables._internal()  {

  }
  String countrySelected = "";
  bool bandLoadingAutocomplete = false;
  double? latitude = 0.0;
  double? longitude = 0.0;
  String email = "";
  String typeDocument = "";
  bool getOrder = false;
  BuildContext? contextAutocomplete;
  BuildContext? contextGlobal;
  bool edit = false;
  String addressSelected = "";
  String tokenVerify = "";
  Map<String,dynamic>? userModel;
  String emailRecoverPass = "";
  int? cityId;



   

}