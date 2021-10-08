import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:encrypt/encrypt.dart' as cript;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/confirmationSlide.dart';

class _Utils {
  final prefs = SharePreference();

  Map encryptPwdIv(String value) {
    var key = cript.Key.fromUtf8(Constants.key_encrypt);
    var iv = cript.IV.fromSecureRandom(16);
    var encrypter =
        cript.Encrypter(cript.AES(key, mode: cript.AESMode.ctr, padding: null));
    var iv16 = iv.base16;
    var encrypted = encrypter.encrypt(value, iv: iv);
    var encrypted16 = encrypted.base16;
    Map jsonEncrypted = {
      'iv': iv16,
      'encrypted': encrypted16,
    };
    print(iv16);
    print(encrypted16);
    return jsonEncrypted;
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  String getPlatform() {
    if (Platform.isAndroid) {
      return "a";
    } else if (Platform.isIOS) {
      return "i";
    }
    return "a";
  }

  double? getLatitude() {
    var singleton = GlobalVariables();
    if (singleton.latitude == 0.0 && singleton.longitude == 0.0) {
      return 4.6287835;
    }
    return singleton.latitude;
  }

  double? getLongitude() {
    var singleton = GlobalVariables();
    if (singleton.longitude == 0.0 && singleton.longitude == 0.0) {
      return -74.0695618;
    }
    return singleton.longitude;
  }

  Widget showSnackBar(BuildContext context, String message) {
    return Flushbar(
      animationDuration: Duration(milliseconds: 500),
      margin: EdgeInsets.only(left: 60, right: 60, bottom: 60),
      borderRadius: BorderRadius.all(Radius.circular(15)),
      backgroundColor: CustomColors.splashColor,
      icon: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Image(
          width: 40,
          height: 40,
          image: AssetImage("Assets/images/ic_error.png"),
        ),
      ),
      messageText: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            message,
            style:
                TextStyle(color: Colors.white, fontFamily: Strings.fontRegular),
          ),
        ),
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  Widget showSnackBarGood(BuildContext context, String message) {
    return Flushbar(
      animationDuration: Duration(milliseconds: 500),
      margin: EdgeInsets.only(left: 60, right: 60, bottom: 60),
      borderRadius: BorderRadius.all(Radius.circular(15)),
      backgroundColor: CustomColors.greenValid,
      icon: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Image(
          width: 40,
          height: 40,
          image: AssetImage("Assets/images/ic_correct.png"),
        ),
      ),
      messageText: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            message,
            style:
                TextStyle(color: Colors.white, fontFamily: Strings.fontRegular),
          ),
        ),
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  Widget showSnackBarError(BuildContext context, String? message) {
    return IgnorePointer(
      child: Flushbar(
        animationDuration: Duration(milliseconds: 500),
        margin: EdgeInsets.only(left: 17, right: 17),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        backgroundColor: CustomColors.red,
        icon: Image(
          image: AssetImage("assets/images/ic_whiteclose.png"),
        ),
        message: message,
        duration: Duration(seconds: 3),
      )..show(context),
    );
  }


  Future<bool?> startCustomAlertMessage(BuildContext context, String titleAlert, String image,
      String textAlert, Function action, Function actionNegative) async{
   return   await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => alertCustomMessage(
            titleAlert, image, textAlert, action, actionNegative));
  }

  startProgress(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => LoadingProgress());
  }

  startOpenSlideUp(BuildContext context, String? email, String? name) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ConfirmationSlidePage(
              email: email,
              name: name,
            ));
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  dynamic checkInternet2(Function func, BuildContext? context) {
    check().then((internet) {
      if (internet != null && internet) {
        func(true, context);
      } else {
        func(false, context);
      }
    });
  }

  Widget alertCustomMessage(String titleAlert, String image, String textAlert,
      Function action, Function actionNegative) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(19)),
                  color: CustomColors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Center(
                      child: Image.asset(
                        image,
                        fit: BoxFit.fill,
                        height: 50,
                        width: 50,
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        titleAlert,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: Strings.fontBold,
                            color: CustomColors.blackLetter,
                            fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        textAlert,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: CustomColors.gray7,
                            fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: btnCustomSize(
                                35,
                                Strings.btnNot,
                                CustomColors.gray2,
                                CustomColors.blackLetter,
                                actionNegative),
                            width: 100,
                          ),
                          Container(
                            child: btnCustomSize(
                                35,
                                Strings.btnYes,
                                CustomColors.blueSplash,
                                CustomColors.white,
                                action),
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> listMonths() {
    List<String> lts = [];
    for (int i = 1; i <= 12; i++) {
      if (i <= 9) {
        lts.add("0$i");
      } else {
        lts.add('$i');
      }
    }
    return lts;
  }

  List<String> listYears() {
    List<String> lts = [];
    var aux = DateTime.now();
    for (int i = aux.year; i <= aux.year + 10; i++) {
      lts.add('$i');
    }
    return lts;
  }
}

final utils = _Utils();
