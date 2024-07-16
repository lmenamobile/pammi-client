import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/InterestCategoriesUser.dart';
import 'package:wawamko/src/UI/Onboarding/UpdatePassword.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import '../../features/feature_home/presentation/views/HomePage.dart';

class VerificationCodePage extends StatefulWidget {
  final String? email;
  final int typeView;

  VerificationCodePage({this.email, required this.typeView});

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  SharePreference prefs = SharePreference();
  late OnboardingProvider providerOnboarding;
  String code = '';

  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    return Scaffold(
     backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async =>false,
        child: SafeArea(
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            headerView(Strings.verification, ()=> Navigator.pop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    Text(Strings.verificationMsg, style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 18, color: CustomColorsAPP.blackLetter),),
                    SizedBox(height: 125,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: PinCodeTextField(
                        appContext: context,
                        backgroundColor: Colors.transparent,
                        cursorColor: CustomColorsAPP.blueSplash,
                        animationType: AnimationType.slide,
                        enableActiveFill: true,
                        keyboardType: TextInputType.number,
                        length: 4,
                        onChanged: (String text) {
                          code = text;
                        },
                        obscureText: false,
                        textStyle: TextStyle(color: CustomColorsAPP.blackLetter, fontFamily: Strings.fontBold, fontSize: 22),
                        //enablePinAutofill: false,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 63,
                            fieldWidth: 59,
                            selectedColor: CustomColorsAPP.grayOne,
                            disabledColor: Colors.white,
                            activeFillColor: Colors.white,
                            activeColor: Colors.white,
                            inactiveFillColor: CustomColorsAPP.gray13.withOpacity(.2),
                            inactiveColor: CustomColorsAPP.gray13.withOpacity(.9),
                            selectedFillColor: Colors.white),
                      ),
                    ),
                    SizedBox(height: 47),
                    GestureDetector(
                      child: Container(
                        child: Text(
                          Strings.sendAgain,
                          style: TextStyle(fontSize: 14, fontFamily: Strings.fontRegular, color: CustomColorsAPP.blueTitle,),
                        ),
                      ),
                      onTap: () => _serviceSendAgainCode(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 30,
            left: 30,
            right: 30,
            child: btnCustomRounded(CustomColorsAPP.blueSplash, CustomColorsAPP.white, Strings.sender, callServiceCode, context)),
        Visibility(visible: providerOnboarding.isLoading, child: LoadingProgress())
      ],
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
              Navigator.pushAndRemoveUntil(context, customPageTransition(InterestCategoriesUser(),PageTransitionType.fade), (route) => false);
              break;
            case Constants.isViewPassword:
              Navigator.of(context).pushReplacement(customPageTransition(UpdatePasswordPage(), PageTransitionType.fade));
              break;
            case Constants.isViewLogin:
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage()), (Route<dynamic> route) => false);
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
