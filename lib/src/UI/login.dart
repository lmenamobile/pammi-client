import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/ForgotPassWordEmail.dart';


import 'package:wawamko/src/UI/HomePage.dart';
import 'package:wawamko/src/UI/Register.dart';
import 'package:wawamko/src/UI/VerificationCode.dart';
import 'package:wawamko/src/UI/changePassword.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  SharePreference prefs = SharePreference();
  NotifyVariablesBloc notifyVariables;

  var obscureTextPass = true;

  @override
  void initState() {


    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: CustomColors.white,
        child: _body(context),
      ),
    );
  }


  Widget _body(BuildContext context){
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[

          Container(
            margin: EdgeInsets.only(top: 185),
            child: Image(

              image: AssetImage("Assets/images/ic_curves.png"),
              //fit: BoxFit.fill,

            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 29,top: 50),
            child: Image(
              width: 80,
              height: 80,
              image: AssetImage("Assets/images/ic_logo_l.png"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 140,left: 29),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Strings.login,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: Strings.fontArialBold,
                    fontSize: 22,
                    color: CustomColors.blackLetter
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  Strings.textLogin,
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
            padding: EdgeInsets.only(left: 35,right: 35,top: 330),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                customBoxEmailLogin(emailController,notifyVariables,(){setState(() {

                });}),
                SizedBox(height: 28),
                customBoxPassword( passwordController),
                SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    GestureDetector(
                      child: Container(



                        alignment: Alignment.topRight,
                        padding: EdgeInsets.only(right: 30,top: 5),

                        child: Text(
                            Strings.forgotPass,
                            style: TextStyle(
                              fontFamily: Strings.fontArial,
                              fontSize: 12,
                              color: CustomColors.blackLetter
                            ),
                        ),
                      ),
                      onTap: (){
                        Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:ForgotPasswordEmailPage(), duration: Duration(milliseconds: 700)));
                        print("Forgot Pass");

                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 50,right: 50),
                  child: btnCustomRounded(CustomColors.blueActiveDots, CustomColors.white, Strings.login,(){ _serviceLoginUser();},context),
                ),
                SizedBox(height: 22),
                Text(
                  Strings.connectTo,
                  style: TextStyle(
                    fontFamily: Strings.fontArial,
                    fontSize: 14,
                    color: CustomColors.grayLetter
                  ),
                ),
                SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    itemConnectTo("Assets/images/ic_google.png",(){}),
                    SizedBox(width: 13),
                    itemConnectTo("Assets/images/ic_facebook.png",(){}),
                    SizedBox(width: 13),
                    itemConnectTo("Assets/images/ic_mac.png",(){}),

                    
                  ],
                ),
                SizedBox(height: 30),


              ],
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(top: 670),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Strings.nonCount,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: Strings.fontArial,
                    color: CustomColors.blueActiveDots,

                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  child: Container(
                    child: Text(
                      Strings.register,
                      style: TextStyle(
                        fontFamily: Strings.fontArial,
                        fontSize: 14,
                        color: CustomColors.blueActiveDots,
                        decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                  onTap: (){
                    print("Register");
                    Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child: RegisterPage(), duration: Duration(milliseconds: 700)));

                  },
                )
              ],
            ),
          )


        ],
      ),
    );
  }




  Widget customBoxPassword(TextEditingController passwordController){
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //  width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                    border: Border.all(color: notifyVariables.intLogin.validatePassword ? CustomColors.blueProfile : CustomColors.gray.withOpacity(.3),width: 1.3),
                    color: CustomColors.white
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          width: 35,
                          height: 35,
                          fit: BoxFit.fill,
                          image: notifyVariables.intLogin.validatePassword ? AssetImage("Assets/images/ic_padlock_blue.png") : AssetImage("Assets/images/ic_padlock.png"),

                        ),
                        SizedBox(width: 6,),
                        Expanded(
                          child: Container(
                            width: 200,
                            child: TextField(

                              obscureText:obscureTextPass,
                              controller: passwordController,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Strings.fontArial,
                                  color:CustomColors.blackLetter
                              ),

                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color:  CustomColors.grayLetter.withOpacity(.4),
                                  fontSize: 16,
                                  fontFamily: Strings.fontArial,

                                ),
                                hintText: Strings.password,
                              ),
                              onChanged: (value){
                                if(validatePwd(value)){
                                  print("true");
                                  notifyVariables.intLogin.validatePassword = true;
                                  setState(() {

                                  });
                                }else{
                                  notifyVariables.intLogin.validatePassword = false;
                                  setState(() {

                                  });
                                }
                               // bloc.changePassword(value);
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Image(
                            width: 35,
                            height: 35,
                            image:!notifyVariables.intLogin.validatePassword ?  obscureTextPass ? AssetImage("Assets/images/ic_no_show_grey.png") : AssetImage("Assets/images/ic_show_grey.png") :  obscureTextPass ? AssetImage("Assets/images/ic_no_show_blue.png") : AssetImage("Assets/images/ic_show_blue.png"),
                          ),
                          onTap: (){
                            this.obscureTextPass ? this.obscureTextPass = false : this.obscureTextPass = true;
                            setState(() {

                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              //SizedBox(height: 20,),

            ],
          );



  }

  bool _validateEmptyFields(){

    if(emailController.text == "" || emailController.text == null){
      utils.showSnackBar(context, Strings.emptyFields);
      return true;
    }

    if(passwordController.text == "" || passwordController.text == null){
      utils.showSnackBar(context, Strings.emptyFields);
      return true;
    }

    if(!validateEmail(emailController.text)){
      utils.showSnackBar(context,Strings.emailInvalid);
      return true;
    }

    if(!validatePwd(passwordController.text)){
      utils.showSnackBar(context,Strings.passwordChallenge);
      return true;
    }

    return false;

  }

  _serviceLoginUser() async {

    FocusScope.of(context).unfocus();

    if (_validateEmptyFields()) {

      return;
    }


    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser = OnboardingProvider.instance.loginUser(context, emailController.text, passwordController.text);
        await callUser.then((user) {

          var decodeJSON = jsonDecode(user);
          ResponseUserinfo data = ResponseUserinfo.fromJsonMap(decodeJSON);

          if(data.code.toString() == "100") {
            Navigator.pop(context);


            var dataUser = data.data.user;
            UserModel userModel = UserModel();
            userModel.email = data.data.user.email;

            prefs.dataUser = jsonEncode(dataUser);
            //globalVariables.dataUser = dataUser;
            prefs.authToken = data.data.authToken;

            if(data.data.user.verifyedAccount){
              Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInLeft, child: MyHomePage(), duration: Duration(milliseconds: 700)));
            }else{
              Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child: VerificationCodePage(userModel: userModel,), duration: Duration(milliseconds: 700)));
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


}
