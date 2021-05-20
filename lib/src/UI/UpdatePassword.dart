import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'file:///C:/Users/Asus/Documents/KUBO/AppsFlutter/Pamii/AppUser/lib/src/UI/Onboarding/login.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class UpdatePasswordPage extends StatefulWidget {
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  bool obscureTextPass = true;
  bool obscureTextConfirmPass = true;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  NotifyVariablesBloc notifyVariables;
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

  Widget _body(BuildContext context) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return SingleChildScrollView(
        child: Stack(children: <Widget>[
      GestureDetector(
        child: Container(
          margin: EdgeInsets.only(top: 8, left: 8),
          alignment: Alignment.topLeft,
          child: Image(
            width: 50,
            height: 50,
            image: AssetImage("Assets/images/ic_back.png"),
          ),
        ),
        onTap: () {
          var vc = Navigator.pop(context);
        },
      ),
      Container(
        margin: EdgeInsets.only(top: 175),
        child: Image(
          image: AssetImage("Assets/images/ic_shape.png"),
          //fit: BoxFit.fill,
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 29, top: 50),
        child: Image(
          width: 110,
          height: 110,
          image: AssetImage("Assets/images/ic_logo_login.png"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 140, left: 29),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Strings.login,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: Strings.fontBold,
                  fontSize: 22,
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
      Padding(
        padding: EdgeInsets.only(left: 35, right: 35, top: 330, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            customBoxPassword(passwordController),
            SizedBox(height: 31),
            customBoxConfirmPass(confirmPasswordController),
            Padding(
              padding: const EdgeInsets.only(left: 70, right: 70, top: 35),
              child: btnCustomRounded(
                  CustomColors.blueSplash, CustomColors.white, Strings.send,
                  () {
                _serviceUpdatePass();
              }, context),
            ),
          ],
        ),
      ),
    ]));
  }

  Widget customBoxPassword(TextEditingController passwordController) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          //  width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
              border: Border.all(
                  color: notifyVariables.intUpdatePass.validPass
                      ? CustomColors.blueSplash
                      : CustomColors.gray.withOpacity(.3),
                  width: 1.3),
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
                    image: notifyVariables.intUpdatePass.validPass
                        ? AssetImage("Assets/images/ic_padlock_blue.png")
                        : AssetImage("Assets/images/ic_padlock.png"),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Container(
                      width: 200,
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
                            notifyVariables.intUpdatePass.validPass = true;
                            setState(() {});
                          } else {
                            notifyVariables.intUpdatePass.validPass = false;
                            setState(() {});
                          }
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

  Widget customBoxConfirmPass(TextEditingController passwordController) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          //  width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
              border: Border.all(
                  color: notifyVariables.intUpdatePass.validConfirmPass
                      ? CustomColors.blueSplash
                      : CustomColors.gray.withOpacity(.3),
                  width: 1.3),
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
                    image: notifyVariables.intUpdatePass.validConfirmPass
                        ? AssetImage("Assets/images/ic_padlock_blue.png")
                        : AssetImage("Assets/images/ic_padlock.png"),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Container(
                      width: 200,
                      child: TextField(
                        obscureText: obscureTextConfirmPass,
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
                          hintText: Strings.confirmPassword,
                        ),
                        onChanged: (value) {
                          if (validatePwd(value)) {
                            notifyVariables.intUpdatePass.validConfirmPass =
                                true;
                            setState(() {});
                          } else {
                            notifyVariables.intUpdatePass.validConfirmPass =
                                false;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Image(
                      width: 35,
                      height: 35,
                      image: obscureTextConfirmPass
                          ? AssetImage("Assets/images/ic_showed.png")
                          : AssetImage("Assets/images/ic_show.png"),
                    ),
                    onTap: () {
                      this.obscureTextConfirmPass
                          ? this.obscureTextConfirmPass = false
                          : this.obscureTextConfirmPass = true;
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

  bool _validateEmptyFields() {
    if (passwordController.text == "") {
      utils.showSnackBar(context, Strings.emptyPassword);
      return true;
    }

    if (!validatePwd(passwordController.text)) {
      utils.showSnackBar(context, Strings.passwordChallenge);
      return true;
    }

    if (confirmPasswordController.text == "") {
      utils.showSnackBar(context, Strings.emptyConfirmPassword);
      return true;
    }

    if (confirmPasswordController.text != passwordController.text) {
      utils.showSnackBar(context, Strings.dontSamePass);
      return true;
    }

    return false;
  }

  _serviceUpdatePass() async {
    FocusScope.of(context).unfocus();

    if (_validateEmptyFields()) {
      return;
    }

    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser = providerOnboarding
            .updatePassword(context, passwordController.text);
        await callUser.then((value) {
          var decodeJSON = jsonDecode(value);
          ForgetPassResponse data = ForgetPassResponse.fromJsonMap(decodeJSON);

          if (data.code.toString() == "100") {
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(PageTransition(
                type: PageTransitionType.slideInLeft,
                child: LoginPage(),
                duration: Duration(milliseconds: 700)));
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
