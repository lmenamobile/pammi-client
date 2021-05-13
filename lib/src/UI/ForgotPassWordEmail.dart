import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/HomePage.dart';
import 'package:wawamko/src/UI/UpdatePassword.dart';
import 'package:wawamko/src/UI/VerificationCode.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class ForgotPasswordEmailPage extends StatefulWidget {
  @override
  _ForgotPasswordEmailPageState createState() => _ForgotPasswordEmailPageState();
}

class _ForgotPasswordEmailPageState extends State<ForgotPasswordEmailPage> {

  final emailController = TextEditingController();
  NotifyVariablesBloc notifyVariables;

  @override
  Widget build(BuildContext context) {

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
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 20,top: 10,),
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
            margin: EdgeInsets.only(top: 165),
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
            padding: const EdgeInsets.only(top: 120,left: 29,right: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Strings.recoverPass,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: Strings.fontArialBold,
                      fontSize: 22,
                      color: CustomColors.blackLetter
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  Strings.textRecoverPass,
                  style: TextStyle(
                      fontFamily: Strings.fontArial,
                      fontSize:14,
                      color: CustomColors.blackLetter
                  ),
                ),



              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 320,left: 35,right: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                customBoxEmailForgotPass(emailController,notifyVariables,(){setState(() {

                });}),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 75,right: 75),
                  child: btnCustomRounded(CustomColors.blueSplash, CustomColors.white,Strings.send,(){
                    _servicePasswordRecovery();
                  }, context),
                ),
                SizedBox(height: 20),

              ],
            ),
          ),


        ],
      ),
    );
  }



  bool _validateEmptyFields(){

    if(emailController.text == "" || emailController.text == null){
      utils.showSnackBar(context, Strings.emptyEmail);
      return true;
    }

    if(!validateEmail(emailController.text)){
      utils.showSnackBar(context,Strings.emailInvalid);
      return true;
    }


    return false;

  }

  _servicePasswordRecovery() async {
    FocusScope.of(context).unfocus();

    if (_validateEmptyFields()) {

      return;
    }

    UserModel userModel = UserModel();
    userModel.email = emailController.text;


    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser = OnboardingProvider.instance.passwordRecovery(context, emailController.text);
        await callUser.then((user) {

          var decodeJSON = jsonDecode(user);
          ForgetPassResponse data = ForgetPassResponse.fromJsonMap(decodeJSON);

          if(data.code.toString() == "100") {
            Navigator.pop(context);

            Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child: VerificationCodePage(userModel: userModel,flag: "p"), duration: Duration(milliseconds: 700)));
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
