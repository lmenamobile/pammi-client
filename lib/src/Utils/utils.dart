import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as cript;
import 'package:connectivity/connectivity.dart';
import 'package:credit_card/credit_card_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Utils/ConstansApi.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Widgets/DialogLoading.dart';
import 'package:wawamko/src/Widgets/confirmationSlide.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class _Utils {

  final prefs = SharePreference();


  Map encryptPwdIv(String value) {
    var key = cript.Key.fromUtf8(ConstantsApi.key_encrypt);
    var iv = cript.IV.fromSecureRandom(16);
    var encrypter = cript.Encrypter(cript.AES(key, mode: cript.AESMode.ctr, padding: null));
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

  String getPlatform(){
    if (Platform.isAndroid) {
      return "a";
    } else if (Platform.isIOS) {
      return "i";
    }
    return "a";
  }

  double getLatitude() {
    var singleton = GlobalVariables();
    if(singleton.latitude == 0.0 && singleton.longitude == 0.0){
      return 4.6287835;
    }
    return singleton.latitude;
  }

  double getLongitude() {
    var singleton = GlobalVariables();
    if(singleton.longitude == 0.0 && singleton.longitude == 0.0){
      return -74.0695618;
    }
    return singleton.longitude;
  }

  Widget showSnackBar(BuildContext context,String message){
    return Flushbar(
      animationDuration: Duration(milliseconds: 500),
      margin: EdgeInsets.only(left: 60,right: 60,bottom: 60),
      borderRadius: 15.0,
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
        child:Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontFamily: Strings.fontRegular
            ),
          ),
        ),
      ),
      duration:  Duration(seconds: 3),
    )..show(context);
  }


  Widget showSnackBarGood(BuildContext context,String message){
    return Flushbar(
      animationDuration: Duration(milliseconds: 500),
      margin: EdgeInsets.only(left: 60,right: 60,bottom: 60),
      borderRadius: 15.0,
      backgroundColor: CustomColors.greenValid,
      icon: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Image(
          width: 40,
          height: 40,
          image: AssetImage("Assets/images/ic_correct.png"),
        ),
      ),
      message:  message,
      duration:  Duration(seconds: 3),
    )..show(context);
  }

  Widget showSnackBarError(BuildContext context,String message){
    return IgnorePointer(
      child: Flushbar(

        animationDuration: Duration(milliseconds: 500),
        margin: EdgeInsets.only(left: 17,right: 17),
        borderRadius: 15.0,
        backgroundColor: CustomColors.red,
        icon:  Image(


          image: AssetImage("assets/images/ic_whiteclose.png"),

        ),
        message: message,
        duration:  Duration(seconds: 3),
      )..show(context),
    );
  }

  List<String>getbtnPromos(String btnPromos){

    var s1 = btnPromos.replaceAll("[", "");
    var s2 = s1.replaceAll("]", "");
    var listPromosImages = s2.split(",");
    return listPromosImages;

  }


  String getSessionId(Map<String,dynamic> header){

    var cad = header['set-cookie'].split("3A");
    var cad2 = cad[1].split(".");

    var sesionId = cad2[0];
    //&print("Session ID ${seesionId}");
    //this._prefs.token = seesionId;
    return sesionId;
  }

  Map<CardType, Set<List<String>>> cardNumPatterns =
  <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
    CardType.americanExpress: <List<String>>{
      <String>['34'],
      <String>['37'],
    },
    CardType.discover: <List<String>>{
      <String>['6011'],
      <String>['622126', '622925'],
      <String>['644', '649'],
      <String>['65']
    },
    CardType.mastercard: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2229'],
      <String>['223', '229'],
      <String>['23', '26'],
      <String>['270', '271'],
      <String>['2720'],
    },
  };



  CardType detectCCType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;

    if (cardNumber.isEmpty) {
      return cardType;
    }

    cardNumPatterns.forEach(
          (CardType type, Set<List<String>> patterns) {
        for (List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
          cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }


  String decimalFormat(int number){
    var f = new NumberFormat("###,###.###", "es_CO");
    //print("________"+f.format(number));
    return f.format(number);

  }

  int priceToInt (String price){
    int price2 = 0;
    if(price.contains(".")){
      var priceArray = price.split(".");
      if(priceArray.length == 2){
        price2 = int.parse(priceArray[0]);
      }
    }else{
      price2 = int.parse(price);
    }
    return price2;
  }

  startCustomAlertMessage(BuildContext context,String titleAlert,String image,String textAlert,Function action,Function actionNegative){
    showDialog(

        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => alertCustomMessage(context,titleAlert,image,textAlert, action, actionNegative)
    );
  }

  startProgress(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => DialogLoadingAnimated()
    );
  }

   startOpenSlideUp(BuildContext context,String email,String name) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ConfirmationSlidePage(email: email,name: name,)
    );
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

  dynamic checkInternet2(Function func, BuildContext context) {
    check().then((internet) {
      if (internet != null && internet) {
        func(true, context);
      }
      else{
        func(false, context);
      }
    });
  }


  Widget alertCustomMessage(BuildContext context,String titleAlert,String image,String textAlert,Function action,Function actionNegative){
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration:BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(19)),
                  color: CustomColors.white,
                  //border: Border.all(color: CustomColors.redBorderError,width: 1)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Center(
                      child: Image.asset(image,
                        fit: BoxFit.fill,
                        height:70,
                        width: 70,
                      ),
                    ),
                    SizedBox(height: 10),


                   Center(
                      child: Text(titleAlert,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: Strings.fontBold,color: CustomColors.blackLetter,fontSize: 18),),

                    ),
                    SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.only(left: 26,right: 26),
                      child: Text(textAlert,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: Strings.fontRegular,color: CustomColors.grayLetter,fontSize: 15),),

                    ),
                    SizedBox(height: 22.5),
                    Padding(
                      padding: EdgeInsets.only(left: 30,right: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container( child: btnCustomRounded(CustomColors.blueSplash, CustomColors.white, "Si", action, context),width: 100,),
                          Container(child: btnCustomRounded(CustomColors.gray2, CustomColors.blackLetter, "No", actionNegative, context),width: 100,)
                        ],
                      ),
                    ),
                    SizedBox(height: 24.5),


                    //btnAccept(CustomColors.greenButton, Strings.accept, TextStyle(fontSize: 11,color: CustomColors.darkBlue,fontFamily: Strings.fontAvantGarGotItcTEEDemRegular),context,action)

                  ],
                ),


              ),




            ],
          ),
        ),
      ),
    );
  }





}

final utils = _Utils();
