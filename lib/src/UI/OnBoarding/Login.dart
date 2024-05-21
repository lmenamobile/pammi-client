import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/VariablesNotifyProvider.dart';
import 'package:wawamko/src/Providers/AppleSingInProvider.dart';
import 'package:wawamko/src/Providers/GoogleSingInProvider.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/InterestCategoriesUser.dart';
import 'package:wawamko/src/UI/OnBoarding/LoginSocialNetwork/RegisterSocialNetwork.dart';
import 'package:wawamko/src/UI/Onboarding/ForgotPasswordEmail.dart';
import 'package:wawamko/src/UI/Home/HomePage.dart';
import 'package:wawamko/src/UI/Onboarding/Register.dart';
import 'package:wawamko/src/UI/Onboarding/VerificationCode.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'Widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late OnboardingProvider providerOnBoarding;
  ProviderSettings? providerSettings;
  late VariablesNotifyProvider notifyVariables;

  SharePreference prefs = SharePreference();
  GlobalVariables globalVariables = GlobalVariables();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var obscureTextPass = true;
  String msgError = '';

  @override
  Widget build(BuildContext context) {
    notifyVariables = Provider.of<VariablesNotifyProvider>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    providerOnBoarding = Provider.of<OnboardingProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: CustomColors.white,
        body: SafeArea(
          child:  _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        Image(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
            image: AssetImage('Assets/images/img_bg_onboarding.png')),
        Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 80, left: 30,right: 30),
                child: Column(
                  children: [
                    Image(width: 220, image: AssetImage("Assets/images/ic_logo_login.png"),),

                    SizedBox(height: 54,),

                    Text(Strings.welcome, style: TextStyle(fontFamily: Strings.fontBold, fontSize: 36, color: CustomColors.blueTitle),),
                    SizedBox(height: 17),
                    Text(Strings.titleLogin, style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 18, color: Colors.black),),
                    FadeInUp(
                      delay: Duration(milliseconds: 1200),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            //email
                            customBoxEmailLogin(emailController, notifyVariables, () {setState(() {});}),
                            //password
                            Padding(
                              padding: const EdgeInsets.only(top:20,bottom:13),
                              child: customBoxPassword(
                                  notifyVariables.intLogin.validatePassword??false ? CustomColors.blueSplash : CustomColors.gray.withOpacity(.3),
                                  Strings.password,
                                  notifyVariables.intLogin.validatePassword??false,
                                  "Assets/images/ic_padlock_blue.png",
                                  "Assets/images/ic_padlock.png",
                                  passwordController,
                                  providerOnBoarding.obscureTextPass,
                                  validatePwdLogin,showPassword),
                            ),
                            //recover password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(child: Container(),),
                                GestureDetector(
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      padding: EdgeInsets.only(right: 10, top: 5),
                                      child: Text(Strings.forgotPass, style: TextStyle(fontFamily: Strings.fontMedium, color: CustomColors.blueTitle),),
                                    ),
                                    onTap: () => Navigator.of(context).push(customPageTransition(ForgotPasswordEmailPage())))
                              ],
                            ),
                            SizedBox(height: 30),
                            btnCustomRounded(CustomColors.blueSplash, CustomColors.white, Strings.login, () => callServiceLogin(), context),
                            SizedBox(height: 20),
                            btnCustomRounded(CustomColors.redTour, CustomColors.white, Strings.createAccount, () => Navigator.of(context).push(customPageTransition(RegisterPage())), context),
                            SizedBox(height: 55),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(width: double.infinity, height: 1, color: CustomColors.grayDot,),
                                ),
                                Text(Strings.optionInput, style: TextStyle(fontSize: 14, fontFamily: Strings.fontRegular, color: CustomColors.blueTitle),),
                                Expanded(
                                  child: Container(width: double.infinity, height: 1, color: CustomColors.grayDot,),
                                )
                              ],
                            ),
                            SizedBox(height: 36),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Visibility(
                                  visible: platformIsAndroid(),
                                  child: itemConnectTo("Assets/images/ic_google.png", () => validateUserGoogle()),
                                ),
                                SizedBox(width: 13),
                                itemConnectTo("Assets/images/ic_facebook.png", requestLoginFacebook),
                                Visibility(
                                    visible: !platformIsAndroid(),
                                    child: Container(
                                        margin: EdgeInsets.only(left: 13),
                                        child: itemConnectTo("Assets/images/ic_mac.png", ()=>validateUserApple()))
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                  ),
              ),
            ),
          ],
        ),
        Visibility(visible: providerOnBoarding.isLoading, child: LoadingProgress()),
      ],
    );
  }



  validatePwdLogin(value){
    if (validatePwd(value)) {
      notifyVariables.intLogin.validatePassword = true;
      setState(() {});
    } else {
      notifyVariables.intLogin.validatePassword = false;
      setState(() {});
    }
  }

  showPassword(){
    providerOnBoarding.obscureTextPass = !providerOnBoarding.obscureTextPass;
  }

  bool validateFormLogin() {
    bool validateForm = true;
    if (emailController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.emailEmpty;
    } else if (!validateEmail(emailController.text.trim())) {
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
        Future callUser = providerOnBoarding.loginUser(emailController.text.trim(), passwordController.text);
        await callUser.then((user) {
          print("USUARIO $user");
          if(user == null){
            utils.showSnackBar(context, Strings.accountCloseLogin);
          }
          if(user.interestsConfigured){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage()), (Route<dynamic> route) => false);
          } else{
            Navigator.push(context, customPageTransition(InterestCategoriesUser()));
          }
        }, onError: (error) {
          providerOnBoarding.isLoading = false;
          if(error.toString()==Constants.codeAccountNotValidate){
            Navigator.of(context)
                .push(customPageTransition(VerificationCodePage(
              email: emailController.text.trim(),typeView: Constants.isViewLogin,
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

  void validateUserApple() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser =   AppleSingInProvider.singIn();
        await callUser.then((token) {
         validateTokenApple(token);
        }, onError: (error) {
          print("error APPLE $error");
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  void validateTokenApple(String token) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser =   providerOnBoarding.validateTokenApple(token);

        await callUser.then((dataUser) {
          print("callUser $callUser");
          if(dataUser==100){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage()), (Route<dynamic> route) => false);
          }else{
            Navigator.push(context, customPageTransition(RegisterSocialNetworkPage(name: dataUser['name'],email:dataUser['email'],typeRegister: "lc",)));
          }
          print("callUser $callUser");
        }, onError: (error) {
          print("error user $error");
          if(error.toString() == "El usuario se encuentra inactivo"){
            utils.showSnackBar(context, Strings.accountCloseLogin);
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
         // GoogleSingInProvider.googleSingOut();
          loginSocialNetwork(user, Constants.loginGMAIL);
        }, onError: (error) {
          if(error.toString() == "El usuario se encuentra inactivo"){
            utils.showSnackBar(context, Strings.accountCloseLogin);
          }else{
            utils.showSnackBar(context, error.toString());
          }
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  loginSocialNetwork(dynamic dataUser, String typeLogin) async {

    if(dataUser == null){
      utils.showSnackBar(context, 'No se encontró la data del usuario');
      return;
    }

    print("DATA $dataUser");
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerOnBoarding.loginUserSocialNetWork(typeLogin == Constants.loginGMAIL ? dataUser.email : dataUser["email"], typeLogin);
        await callUser.then((data) {
       //  print("DATA $dataUser");
          if(data==Constants.isRegisterRS){
          Navigator.push(context, customPageTransition(RegisterSocialNetworkPage(name: typeLogin == Constants.loginGMAIL ? dataUser.displayName : dataUser["name"],email: typeLogin == Constants.loginGMAIL ? dataUser.email : dataUser["email"],typeRegister:typeLogin == Constants.loginGMAIL ? Constants.loginGMAIL:Constants.loginFacebook,)));
          }else {
            print("home");
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage()), (Route<dynamic> route) => false);
          }
        }, onError: (error) {

          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  Future<void> requestLoginFacebook() async{

    try {
      final fb = FacebookLogin();
      print("FACEBOOK1");
      print("INFORMACION FACEBOOK ${fb.accessToken} ${fb.isLoggedIn} ${fb.sdkVersion}");

    /*  fb.getUserEmail().then((isLoggedIn) {
        print("IgetUserEmail: $isLoggedIn");
      });
      fb.isLoggedIn.then((isLoggedIn) {
        print("Is Logged In: $isLoggedIn");
      });

      fb.accessToken.then((value) {
        print("Access Token: $value");
      });

      fb.sdkVersion.then((version) {
        print("SDK Version: $version");
      });*/



      final result = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
        FacebookPermission.userFriends
      ]);

      final FacebookAccessToken accessToken = result.accessToken!;

      print("TOKEEEEN $accessToken");


      await fb.logOut();
      switch (result.status) {
        case FacebookLoginStatus.success:
          getUserInfoFB(result.accessToken!.token,fb);
          break;
        case FacebookLoginStatus.cancel:
          utils.showSnackBar(context, Strings.errorFacebook);
          break;
        case FacebookLoginStatus.error:
          utils.showSnackBar(context, Strings.errorFacebook);
          break;
      }
    } catch (e) {
      print("Error durante el inicio de sesión de Facebook: $e");
    }

  }

  void getUserInfoFB(String token,FacebookLogin fb) async {

    final response = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
    final profile = json.decode(response.body);

   // print(profile.toString());
    if (profile['email'] != null && profile['name'] != null) {
      loginSocialNetwork(profile, Constants.loginFacebook);
    } else {
      utils.showSnackBar(context, Strings.errorFacebook);
    }
  }

}
