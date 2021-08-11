import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/InterestCategoriesUser.dart';
import 'package:wawamko/src/UI/Onboarding/Login.dart';
import 'package:wawamko/src/UI/Onboarding/UpdatePassword.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../Home/HomePage.dart';

class VerificationCodePage extends StatefulWidget {
  final String email;
  final int typeView;

  VerificationCodePage({this.email, @required this.typeView});

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  SharePreference prefs = SharePreference();
  OnboardingProvider providerOnboarding;
  String code = '';

  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async =>false,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                child: _body(context),
              ),
              Visibility(
                  visible: providerOnboarding.isLoading,
                  child: LoadingProgress()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 145),
                child: Image(
                  image: AssetImage("Assets/images/ic_shape.png"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 65, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Image(
                        width: 120,
                        image: AssetImage("Assets/images/ic_logo_login.png"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      Strings.verification,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: Strings.fontBold,
                          fontSize: 22,
                          color: CustomColors.blackLetter),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      child: Text(
                        Strings.verificationMsg,
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            fontSize: 14,
                            color: CustomColors.blackLetter),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20,top: 15
                  ),
                  alignment: Alignment.topLeft,
                  child: Image(
                    width: 50,
                    height: 50,
                    image: AssetImage("Assets/images/ic_back.png"),
                  ),
                ),
                onTap: () {
                  if(Constants.isViewRegister==widget.typeView) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (Route<dynamic> route) => false);
                  }else{
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: PinCodeTextField(
                    appContext: context,
                    backgroundColor: Colors.transparent,
                    cursorColor: CustomColors.blueSplash,
                    animationType: AnimationType.slide,
                    enableActiveFill: true,
                    keyboardType: TextInputType.number,
                    length: 4,
                    onChanged: (String text) {
                      code = text;
                    },
                    obscureText: false,
                    textStyle: TextStyle(
                        color: CustomColors.blackLetter,
                        fontFamily: Strings.fontBold,
                        fontSize: 22),
                    enablePinAutofill: false,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 50,
                        selectedColor: CustomColors.grayOne,
                        disabledColor: Colors.white,
                        activeFillColor: Colors.white,
                        activeColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        inactiveColor: CustomColors.grayOne,
                        selectedFillColor: Colors.white),
                  ),
                ),
                SizedBox(height: 24),
                GestureDetector(
                  child: Container(
                    child: Text(
                      Strings.sendAgain,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: Strings.fontRegular,
                          color: CustomColors.redTour,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  onTap: () => _serviceSendAgainCode(),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.only(left: 85, right: 85),
                  child: btnCustomRounded(
                      CustomColors.blueSplash,
                      CustomColors.white,
                      Strings.send,
                      callServiceCode,
                      context),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  callServiceCode() {
    if (_validateEmptyFields()) {
      _serviceVerifyCode();
    }
  }

  bool _validateEmptyFields() {
    if (code.isEmpty) {
      utils.showSnackBar(context, Strings.emptyFields);
      return false;
    }
    return true;
  }

  _serviceVerifyCode() async {
    FocusScope.of(context).unfocus();
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser =
            providerOnboarding.verificationCode(code, widget.email);
        await callUser.then((value) {
          switch (widget.typeView) {
            case Constants.isViewRegister:
              Navigator.pushAndRemoveUntil(
                  context,
                  customPageTransition(InterestCategoriesUser()),
                  (route) => false);
              break;
            case Constants.isViewPassword:
              Navigator.of(context)
                  .pushReplacement(customPageTransition(UpdatePasswordPage()));
              break;
            case Constants.isViewLogin:
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                      (Route<dynamic> route) => false);
              break;
            default:
          }
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  _serviceSendAgainCode() async {
    FocusScope.of(context).unfocus();
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerOnboarding.sendAgainCode(widget.email);
        await callUser.then((msg) {
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
