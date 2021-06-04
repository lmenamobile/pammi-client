import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class RegisterStepTwoPage extends StatefulWidget {
  final UserModel user;

  RegisterStepTwoPage({Key key, this.user}) : super(key: key);

  @override
  _RegisterStepTwoPageState createState() => _RegisterStepTwoPageState();
}

class _RegisterStepTwoPageState extends State<RegisterStepTwoPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '###############', filter: {"#": RegExp(r'[0-9]')});
  NotifyVariablesBloc notifyVariables;
  OnboardingProvider providerOnboarding;
  bool checkTerms = false;
  bool checkDates = false;
  bool obscureTextPass = true;
  bool obscureTextConfirmPass = true;
  String msgError = '';

  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    return Scaffold(
      backgroundColor: CustomColors.blueSplash,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              color: CustomColors.white,
              child: _body(context),
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
        Container(
          width: double.infinity,
          height: 100,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Image(
                  fit: BoxFit.fill,
                  height: 100,
                  image: AssetImage("Assets/images/ic_header_signup.png"),
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: GestureDetector(
                  child: Image(
                    image: AssetImage("Assets/images/ic_back_w.png"),
                    width: 40,
                    height: 40,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 25),
                child: Text(
                  Strings.register,
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 18,
                      color: CustomColors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        Strings.createAccount,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: Strings.fontBold,
                            fontSize: 24,
                            color: CustomColors.blackLetter),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        Strings.registerMsg,
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: CustomColors.grayLetter),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                          children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 600),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: <Widget>[
                          SizedBox(height: 21),
                          customBoxEmailRegister(
                              emailController, notifyVariables, () {
                            setState(() {});
                          }),
                          SizedBox(height: 21),
                          customBoxPassword(passwordController),
                          SizedBox(height: 21),
                          customBoxConfirmPassword(confirmPassController)
                        ],
                      )),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 6, right: 6),
                        child: Text(
                          Strings.challengePassword,
                          style: TextStyle(
                              fontFamily: Strings.fontRegular,
                              fontSize: 10,
                              color: CustomColors.grayLetter2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            checkDates
                                ? GestureDetector(
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  "Assets/images/ic_check2.png"))),
                                    ),
                                    onTap: () {
                                      this.checkDates = false;
                                      print("true");
                                      setState(() {});
                                    },
                                  )
                                : GestureDetector(
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  "Assets/images/ic_check.png"))),
                                    ),
                                    onTap: () {
                                      this.checkDates = true;
                                      print("False");
                                      setState(() {});
                                    },
                                  ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                Strings.AuthorizeDates,
                                style: TextStyle(
                                    fontFamily: Strings.fontRegular,
                                    fontSize: 12,
                                    color: CustomColors.blackLetter),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          checkTerms
                              ? GestureDetector(
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  "Assets/images/ic_check2.png")))),
                                  onTap: () {
                                    this.checkTerms = false;
                                    print("true");
                                    setState(() {});
                                  },
                                )
                              : GestureDetector(
                                  child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  "Assets/images/ic_check.png")))),
                                  onTap: () {
                                    this.checkTerms = true;
                                    print("False");
                                    setState(() {});
                                  },
                                ),
                          SizedBox(width: 10),
                          Expanded(
                              child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 12,
                                color: CustomColors.blackLetter,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "He leido y acepto los ",
                                    style: TextStyle(
                                      fontFamily: Strings.fontRegular,
                                    )),
                                TextSpan(
                                  text: "Terminos y condiciones",
                                  style: TextStyle(
                                      fontFamily: Strings.fontRegular,
                                      color: CustomColors.blueActiveDots,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launch(
                                        "https://pamii-dev.s3.us-east-2.amazonaws.com/wawamko/system/Clientes_Terminos+y+condiciones.pdf"),
                                ),
                                TextSpan(
                                    text: " y la",
                                    style: TextStyle(
                                      fontFamily: Strings.fontRegular,
                                    )),
                                TextSpan(
                                  text: " Política de privacidad",
                                  style: TextStyle(
                                      fontFamily: Strings.fontRegular,
                                      color: CustomColors.blueActiveDots,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launch(
                                        "https://pamii-dev.s3.us-east-2.amazonaws.com/wawamko/system/Cliente_Politica_De_Tratamiento_De_Datos_Personales.pdf"),
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20, left: 50, right: 50),
                    child: btnCustomRoundedImage(
                        CustomColors.blueSplash,
                        CustomColors.white,
                        Strings.next,
                        callRegisterUser,
                        context,
                        "Assets/images/ic_next.png"),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget customBoxPassword(TextEditingController passwordController) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 52,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    color: CustomColors.gray.withOpacity(.3), width: 1),
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
                      image: AssetImage("Assets/images/ic_padlock_blue.png"),
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
                        width: 200,
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
                              fontSize: 16,
                              fontFamily: Strings.fontRegular,
                            ),
                            hintText: Strings.password,
                          ),
                          onChanged: (value) {
                            if (validatePwd(value)) {
                              notifyVariables.intRegister.validPass = true;
                              setState(() {});
                            } else {
                              notifyVariables.intRegister.validPass = false;
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
          snapshot.hasError
              ? Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Text(
                    Strings.passwordChallenge,
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 13,
                        color: CustomColors.red),
                  ),
                )
              : Container()
        ],
      );
    });
  }

  Widget customBoxConfirmPassword(TextEditingController passwordController) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 52,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    color: CustomColors.gray.withOpacity(.3), width: 1),
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
                      image: AssetImage("Assets/images/ic_padlock_blue.png"),
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
                              notifyVariables.intRegister.validConfirmPass =
                                  true;
                              setState(() {});
                            } else {
                              notifyVariables.intRegister.validConfirmPass =
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
          snapshot.hasError
              ? Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Text(
                    Strings.passwordChallenge,
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 13,
                        color: CustomColors.red),
                  ),
                )
              : Container()
        ],
      );
    });
  }

  bool _validateEmptyFields() {
    if (emailController.text.isEmpty) {
      msgError = Strings.emptyEmail;
      return false;
    } else if (!validateEmail(emailController.text.trim())) {
      msgError = Strings.emailInvalidate;
      return false;
    } else if (passwordController.text.isEmpty) {
      msgError = Strings.passwordEmpty;
      return false;
    } else if (confirmPassController.text.isEmpty) {
      msgError = Strings.emptyConfirmPassword;
      return false;
    } else if (!validatePwd(passwordController.text)) {
      msgError = Strings.passwordChallenge;
      return false;
    } else if (confirmPassController.text != passwordController.text) {
      msgError = Strings.dontSamePass;
      return false;
    } else if (!checkDates) {
      msgError = Strings.dontCheckDates;
      return false;
    } else if (!checkTerms) {
      msgError = Strings.dontCheckTerms;
      return false;
    }

    return true;
  }

  callRegisterUser() {
    if (_validateEmptyFields()) {
      widget.user.email = emailController.text;
      widget.user.passWord = passwordController.text;
      _serviceRegister();
    } else {
      utils.showSnackBar(context, msgError);
    }
  }

  _serviceRegister() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerOnboarding.createAccount(widget.user);
        await callUser.then((user) {
          utils.startOpenSlideUp(context, user.email, user.fullname);
        }, onError: (error) {
          utils.showSnackBar(context, error);
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
