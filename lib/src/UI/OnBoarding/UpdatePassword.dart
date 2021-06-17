import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import 'Login.dart';

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
  String msgError = '';

  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    return Scaffold(
      body: SafeArea(
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
    );
  }

  Widget _body(BuildContext context) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 130),
            child: Image(
              image: AssetImage("Assets/images/ic_shape.png"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50, left: 30),
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
                  Strings.newPassword,
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
                    Strings.textNewPassword,
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
                left: 20,
              ),
              alignment: Alignment.topLeft,
              child: Image(
                width: 50,
                height: 50,
                image: AssetImage("Assets/images/ic_back.png"),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            customBoxPassword(passwordController),
            SizedBox(height: 31),
            customBoxConfirmPass(confirmPasswordController),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 35),
              child: btnCustomRounded(
                  CustomColors.blueSplash,
                  CustomColors.white,
                  Strings.save,
                  callServiceUpdatePassword,
                  context),
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
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                  color: notifyVariables.intUpdatePass.validPass
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
                    image: notifyVariables.intUpdatePass.validPass
                        ? AssetImage("Assets/images/ic_padlock_blue.png")
                        : AssetImage("Assets/images/ic_padlock.png"),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 1,
                    height: 25,
                    color: CustomColors.grayLetter.withOpacity(.4),
                  ),
                  Expanded(
                    child: Container(
                      child: TextField(
                        obscureText: obscureTextPass,
                        controller: passwordController,
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: CustomColors.blackLetter),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: CustomColors.grayLetter.withOpacity(.4),
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
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                  color: notifyVariables.intUpdatePass.validConfirmPass
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
                    image: notifyVariables.intUpdatePass.validConfirmPass
                        ? AssetImage("Assets/images/ic_padlock_blue.png")
                        : AssetImage("Assets/images/ic_padlock.png"),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 1,
                    height: 25,
                    color: CustomColors.grayLetter.withOpacity(.4),
                  ),
                  Expanded(
                    child: Container(
                      width: 200,
                      child: TextField(
                        obscureText: obscureTextConfirmPass,
                        controller: passwordController,
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: CustomColors.blackLetter),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: CustomColors.grayLetter.withOpacity(.4),
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

  callServiceUpdatePassword() {
    if (_validateEmptyFields()) {
      _serviceUpdatePass();
    } else {
      utils.showSnackBar(context, msgError);
    }
  }

  bool _validateEmptyFields() {
    FocusScope.of(context).unfocus();
    if (passwordController.text.isEmpty) {
      msgError = Strings.emptyPassword;
      return false;
    } else if (!validatePwd(passwordController.text)) {
      msgError = Strings.passwordChallenge;
      return false;
    } else if (confirmPasswordController.text.isEmpty) {
      msgError = Strings.emptyConfirmPassword;
      return false;
    } else if (confirmPasswordController.text != passwordController.text) {
      msgError = Strings.dontSamePass;
      return false;
    }
    return true;
  }

  _serviceUpdatePass() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser =
            providerOnboarding.updatePassword(passwordController.text.trim());
        await callUser.then((value) {
          utils.showSnackBarGood(context, value.toString());
          Navigator.pushAndRemoveUntil(
              context, customPageTransition(LoginPage()), (route) => false);
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
