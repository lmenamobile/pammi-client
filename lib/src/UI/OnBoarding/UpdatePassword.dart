
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/VariablesNotifyProvider.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/config/theme/colors.dart';
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
  late VariablesNotifyProvider notifyVariables;
  late OnboardingProvider providerOnBoarding;

  bool obscureTextPass = true;
  bool obscureTextConfirmPass = true;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String msgError = '';

  @override
  Widget build(BuildContext context) {
    providerOnBoarding = Provider.of<OnboardingProvider>(context);
    notifyVariables = Provider.of<VariablesNotifyProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        Column(
            children: <Widget>[
              headerView( Strings.resetPass, ()=> Navigator.pop(context)),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(Strings.patternPass, style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 18, color: AppColors.black1),),
                      const SizedBox(height: 24),
                      customBoxPassword(passwordController),
                      SizedBox(height: 31),
                      customBoxConfirmPass(confirmPasswordController),
                    ],
                  ),
                ),
              )
        ]
        ),
        Positioned(
          bottom: 30,
          left: 30,
          right: 30,
          child: btnCustomRounded(AppColors.blueSplash, AppColors.white, Strings.save, callServiceUpdatePassword, context),),
        Visibility(
          visible: providerOnBoarding.isLoading,
            child: LoadingProgress())
      ],
    );
  }

  Widget customBoxPassword(TextEditingController passwordController) {
    notifyVariables = Provider.of<VariablesNotifyProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(26)),
              border: Border.all(
                  color: notifyVariables.intUpdatePass.validPass!
                      ? AppColors.blueSplash
                      : AppColors.gray.withOpacity(.3),
                  width: 1),
              color: AppColors.white),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 20,
                    height: 20,
                    image: notifyVariables.intUpdatePass.validPass!
                        ? AssetImage("Assets/images/ic_padlock_blue.png")
                        : AssetImage("Assets/images/ic_padlock.png"),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 1,
                    height: 20,
                    color: AppColors.gray7.withOpacity(.2),
                  ),
                  Expanded(
                    child: Container(
                      child: TextField(
                        obscureText: obscureTextPass,
                        controller: passwordController,
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: AppColors.blackLetter),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: AppColors.gray7.withOpacity(.5),
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
                      width: 30,
                      height: 30,
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
    notifyVariables = Provider.of<VariablesNotifyProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(26)),
              border: Border.all(
                  color: notifyVariables.intUpdatePass.validConfirmPass!
                      ? AppColors.blueSplash
                      : AppColors.gray.withOpacity(.3),
                  width: 1),
              color: AppColors.white),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 20,
                    height: 20,
                    image: notifyVariables.intUpdatePass.validConfirmPass!
                        ? AssetImage("Assets/images/ic_padlock_blue.png")
                        : AssetImage("Assets/images/ic_padlock.png"),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 1,
                    height: 25,
                    color: AppColors.gray7.withOpacity(.2),
                  ),
                  Expanded(
                    child: Container(
                      width: 200,
                      child: TextField(
                        obscureText: obscureTextConfirmPass,
                        controller: passwordController,
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: AppColors.blackLetter),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: AppColors.gray7.withOpacity(.5),
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
                      width: 30,
                      height: 30,
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
        providerOnBoarding.updatePassword(passwordController.text.trim());
        await callUser.then((value) {
          utils.showSnackBarGood(context, value.toString());
          Navigator.pushAndRemoveUntil(
              context, customPageTransition(LoginPage(),PageTransitionType.fade), (route) => false);
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
