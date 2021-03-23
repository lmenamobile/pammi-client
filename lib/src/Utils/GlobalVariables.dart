
import 'dart:async';
import 'package:event/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:nacional_licores/src/models/OnboardongModels.dart';
//import 'package:nacional_licores/src/models/shopCarModel.dart';

class GlobalVariables {

  static final GlobalVariables _instance = GlobalVariables._internal();
  factory GlobalVariables() => _instance;

  GlobalVariables._internal()  {

  }
  String countrySelected = "";
  bool bandLoadingAutocomplete = false;
  double latitude = 0.0;
  double longitude = 0.0;
  String email = "";
  String typeDocument = "";
  bool getOrder = false;
  BuildContext contextAutocomplete;
  BuildContext contextGlobal;
  bool edit = false;
  String addressSelected = "";
  String tokenVerify = "";
  Map<String,dynamic> userModel;
  String emailRecoverPass = "";
  var eventRefreshRegister = Event();
  int cityId;


  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
 
  var sc = StreamController();

  //Socket

Map<String, bool> isProbablyConnected = {};
  
   

}