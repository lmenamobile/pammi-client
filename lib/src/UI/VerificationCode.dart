import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/InterestCategoriesUser.dart';
import 'package:wawamko/src/UI/UpdatePassword.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class VerificationCodePage extends StatefulWidget {

  final String email;
  String flag;
  VerificationCodePage({Key key,this.email,this.flag}) : super(key: key);
  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {

  final codeController1  = TextEditingController();
  final codeController2  = TextEditingController();
  final codeController3  = TextEditingController();
  final codeController4 = TextEditingController();
  SharePreference prefs = SharePreference();
  OnboardingProvider providerOnboarding;

  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context){
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 20,top: 10),
              alignment: Alignment.topLeft,
              child: Image(
                width: 50,
                height: 50,
                image: AssetImage("Assets/images/ic_back.png"),
              ),
            ),
            onTap: (){
              Navigator.pop(context);

            },
          ),
          Container(
            margin: EdgeInsets.only(top: 185),
            child: Image(

              image: AssetImage("Assets/images/ic_shape.png"),
              //fit: BoxFit.fill,

            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 29,top: 40),
            child: Image(
              width: 110,
              height: 110,
              image: AssetImage("Assets/images/ic_logo_login.png"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 130,left: 29,right: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Strings.verification,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: Strings.fontBold,
                      fontSize: 22,
                      color: CustomColors.blackLetter
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  Strings.verificationMsg,
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize:14,
                      color: CustomColors.blackLetter
                  ),
                ),



              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 350),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,

                  margin: EdgeInsets.only(right: 20,left: 23),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      textFieldCode(codeController1, '',context),
                      SizedBox(
                        width: 8,
                      ),
                      textFieldCode(codeController2, '',context),
                      SizedBox(
                        width: 8,
                      ),
                      textFieldCode(codeController3, '',context),
                      SizedBox(
                        width: 8,
                      ),
                      textFieldCode(codeController4, '',context),
                    ],
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
                        decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                  onTap: (){
                    _serviceSendAgainCode();
                  },
                ),
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.only(left: 85,right: 85),
                  child: btnCustomRounded(CustomColors.blueSplash, CustomColors.white, Strings.send,(){_serviceVerifyCode();}, context),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),


        ],
      ),
    );
  }

  bool _validateEmptyFields(){

    if(codeController1.text == "" || codeController2.text == "" || codeController3.text == "" || codeController4.text == ""){
      utils.showSnackBar(context, Strings.emptyFields);
      return true;
    }

    return false;

  }


  _serviceVerifyCode() async {
    FocusScope.of(context).unfocus();

    if (_validateEmptyFields()) {

      return;
    }

    var code = codeController1.text+codeController2.text+codeController3.text+codeController4.text;

    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser = providerOnboarding.verificationCode(context, code, widget.email);
        await callUser.then((value) {

          var decodeJSON = jsonDecode(value);
          VerifyCodeResponse data = VerifyCodeResponse.fromJsonMap(decodeJSON);

          if(data.code.toString() == "100") {
            prefs.authToken = data.data.authToken;

            Navigator.pop(context);
            switch (widget.flag){
              case 'r':
                Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:InterestCategoriesUser(), duration: Duration(milliseconds: 700)));
                //Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInLeft, child: MyHomePage(), duration: Duration(milliseconds: 700)));
                break;
              case 'p':
                Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInLeft, child: UpdatePasswordPage(), duration: Duration(milliseconds: 700)));
                break;
              case '':
                utils.showSnackBar(context, "Destiny don't defination");
            }



            //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BaseNavigationPage()), (Route<dynamic> route) => false);
          } else {

            Navigator.pop(context);
            utils.showSnackBar(context, data.message);

          }
        }, onError: (error) {

          Navigator.pop(context);
          utils.showSnackBar(context, Strings.serviceError);


        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
        print("you has not internet");

      }
    });
  }
  
  _serviceSendAgainCode() async {
    FocusScope.of(context).unfocus();



    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser = providerOnboarding.sendAgainCode(context, widget.email);
        await callUser.then((value) {

          var decodeJSON = jsonDecode(value);
          ForgetPassResponse data = ForgetPassResponse.fromJsonMap(decodeJSON);

          if(data.code.toString() == "100") {
            Navigator.pop(context);
            utils.showSnackBarGood(context, data.message);

            //Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInLeft, child: MyHomePage(), duration: Duration(milliseconds: 700)));
            //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BaseNavigationPage()), (Route<dynamic> route) => false);
          } else {

            Navigator.pop(context);
            utils.showSnackBar(context, data.message);

          }
        }, onError: (error) {

          Navigator.pop(context);
          utils.showSnackBar(context, Strings.serviceError);


        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
        print("you has not internet");

      }
    });
  }

}
