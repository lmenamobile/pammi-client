import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Providers/GoogleSingInProvider.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/Onboarding/ForgotPasswordEmail.dart';
import 'package:wawamko/src/UI/HomePage.dart';
import 'package:wawamko/src/UI/Onboarding/Register.dart';
import 'package:wawamko/src/UI/VerificationCode.dart';
import 'package:wawamko/src/Utils/ConstansApi.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import 'package:http/http.dart' as http;
import '../selectCountry.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  SharePreference prefs = SharePreference();
  NotifyVariablesBloc notifyVariables;
  GlobalVariables globalVariables = GlobalVariables();
  OnboardingProvider providerOnboarding;
  var obscureTextPass = true;
  String msgError = '';

  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    return Scaffold(
      body: SafeArea(
        child:  Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  color: CustomColors.white,
                  child: _body(context),
                ),
              ),
              Visibility(
                  visible: providerOnboarding.isLoading, child: LoadingProgress()),
            ],
          ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return Column(
      children: <Widget>[
        Stack(
          children: [
            FadeInUpBig(
              child: Container(
                margin: EdgeInsets.only(top: 130),
                child: Image(
                  image: AssetImage("Assets/images/ic_shape.png"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    width: 120,
                    image: AssetImage("Assets/images/ic_logo_login.png"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    Strings.login,
                    style: TextStyle(
                        fontFamily: Strings.fontBold,
                        fontSize: 25,
                        color: CustomColors.blackLetter),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    Strings.textLogin,
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 14,
                        color: CustomColors.blackLetter),
                  ),
                ],
              ),
            ),
          ],
        ),
        FadeInUp(
          delay: Duration(milliseconds: 1200),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                customBoxEmailLogin(emailController, notifyVariables, () {
                  setState(() {});
                }),
                SizedBox(height: 28),
                customBoxPassword(passwordController),
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
                          padding: EdgeInsets.only(right: 30, top: 5),
                          child: Text(
                            Strings.forgotPass,
                            style: TextStyle(
                                fontFamily: Strings.fontMedium,
                                color: CustomColors.blackLetter),
                          ),
                        ),
                        onTap: () => Navigator.of(context).push(
                            customPageTransition(ForgotPasswordEmailPage())))
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: btnCustomRounded(
                      CustomColors.redTour,
                      CustomColors.white,
                      Strings.login,
                      callServiceLogin,
                      context),
                ),
                SizedBox(height: 14),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: btnCustomRounded(
                      CustomColors.blueSplash,
                      CustomColors.white,
                      Strings.createAccount,
                      () => Navigator.of(context)
                          .push(customPageTransition(RegisterPage())),
                      context),
                ),
                SizedBox(height: 22),
                Text(
                  Strings.connectTo,
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 14,
                      color: CustomColors.grayLetter),
                ),
                SizedBox(height: 23),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    itemConnectTo("Assets/images/ic_google.png",
                        () => validateUserGoogle()),
                    SizedBox(width: 13),
                    itemConnectTo("Assets/images/ic_facebook.png",
                        () => requestLoginFacebook()),
                    Visibility(
                        visible: !platformIsAndroid(),
                        child: Container(
                            margin: EdgeInsets.only(left: 13),
                            child: itemConnectTo(
                                "Assets/images/ic_mac.png", () {}))),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget customBoxPassword(TextEditingController passwordController) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                  color: notifyVariables.intLogin.validatePassword
                      ? CustomColors.blueSplash
                      : CustomColors.gray.withOpacity(.3),
                  width: 1),
              color: CustomColors.white),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 35,
                    height: 35,
                    fit: BoxFit.fill,
                    image: notifyVariables.intLogin.validatePassword
                        ? AssetImage("Assets/images/ic_padlock_blue.png")
                        : AssetImage("Assets/images/ic_padlock.png"),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 1,
                    height: 25,
                    color: CustomColors.grayLetter.withOpacity(.4),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      child: TextField(
                        obscureText: obscureTextPass,
                        controller: passwordController,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Strings.fontRegular,
                            color: CustomColors.blackLetter),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: CustomColors.grayLetter.withOpacity(.4),
                            fontSize: 16,
                            fontFamily: Strings.fontRegular,
                          ),
                          hintText: Strings.password,
                        ),
                        onChanged: (value) {
                          if (validatePwd(value)) {
                            print("true");
                            notifyVariables.intLogin.validatePassword = true;
                            setState(() {});
                          } else {
                            notifyVariables.intLogin.validatePassword = false;
                            setState(() {});
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
                      image: obscureTextPass
                          ? AssetImage("Assets/images/ic_showed.png")
                          : AssetImage("Assets/images/ic_show.png"),
                    ),
                    onTap: () {
                      this.obscureTextPass
                          ? this.obscureTextPass = false
                          : this.obscureTextPass = true;
                      setState(() {});
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

  bool validateFormLogin() {
    bool validateForm = true;
    if (emailController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.emailEmpty;
    } else if (!validateEmail(emailController.text)) {
      validateForm = false;
      msgError = Strings.emailInvalidate;
    } else if (passwordController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.pwdEmpty;
    }
    return validateForm;
  }

  callServiceLogin() {
    if (validateFormLogin()) {
      _serviceLoginUser();
    } else {
      utils.showSnackBar(context, msgError);
    }
  }

  _serviceLoginUser() async {
    FocusScope.of(context).unfocus();
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerOnboarding.loginUser(emailController.text.trim(), passwordController.text);
        await callUser.then((user) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage()), (Route<dynamic> route) => false);
        }, onError: (error) {
          providerOnboarding.isLoading = false;
          if(error.toString()==ConstantsApi.codeAccountNotValidate){
            Navigator.of(context)
                .push(customPageTransition(VerificationCodePage(
              email: emailController.text.trim(),
            )));
          }else{
            utils.showSnackBar(context, error.toString());
          }
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  void validateUserGoogle() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = GoogleSingInProvider.singInWithGoogle();
        await callUser.then((user) {
          GoogleSingInProvider.googleSingOut();
          loginSocialNetwork(user, ConstantsApi.loginGMAIL);
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  void registerSocialNetwork(
      String name, String email, String typeRegister, String cityId) async {
    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser = providerOnboarding.registerUserSocialNetwork(
            name, email, typeRegister, cityId);
        await callUser.then((user) {
          Navigator.pop(context);
        }, onError: (error) {
          Navigator.pop(context);
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  void validateUserIsNotRegister(var user, String typeRegister) {
    globalVariables.cityId = null;
    Navigator.of(context)
        .push(customPageTransition(SelectCountryPage()))
        .then((value) {
      if (globalVariables.cityId != null) {
        if (typeRegister == ConstantsApi.loginGMAIL) {
          registerSocialNetwork(user.displayName, user.email, typeRegister,
              globalVariables.cityId.toString());
        } else if (typeRegister == ConstantsApi.loginFacebook) {}
        registerSocialNetwork(user['name'].toString(), user['email'].toString(),
            typeRegister, globalVariables.cityId.toString());
      } else {
        utils.showSnackBar(context, Strings.errorCreateAccountGmail);
      }
    });
  }

  loginSocialNetwork(var dataUser, String typeLogin) async {
    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser = providerOnboarding.loginUserSocialNetWork(
            typeLogin == ConstantsApi.loginGMAIL
                ? dataUser.email
                : dataUser["email"],
            typeLogin);
        await callUser.then((user) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyHomePage()),
              (Route<dynamic> route) => false);
        }, onError: (error) {
          Navigator.pop(context);
          validateUserIsNotRegister(dataUser, typeLogin);
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  void requestLoginFacebook() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await facebookLogin.logIn(['email']);
    facebookLogin.logOut();
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        getUserInfoFB(result.accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        utils.showSnackBar(context, Strings.errorFacebook);
        break;
      case FacebookLoginStatus.error:
        utils.showSnackBar(context, Strings.errorFacebook);
        break;
    }
  }

  void getUserInfoFB(String token) async {
    final response = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture,gender,birthday&access_token=$token');
    final profile = json.decode(response.body);
    if (profile['email'] != null && profile['name'] != null) {
      loginSocialNetwork(profile, ConstantsApi.loginFacebook);
    } else {
      utils.showSnackBar(context, Strings.errorFacebook);
    }
  }
}
