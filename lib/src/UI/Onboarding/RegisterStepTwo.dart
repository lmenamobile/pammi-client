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
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class RegisterStepTwoPage extends StatefulWidget {
  final UserModel user;

  RegisterStepTwoPage({Key key, this.user}) : super(key: key);

  @override
  _RegisterStepTwoPageState createState() => _RegisterStepTwoPageState();
}

class _RegisterStepTwoPageState extends State<RegisterStepTwoPage> {
  final phoneController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    return Scaffold(
      backgroundColor: CustomColors.blueSplash,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: CustomColors.white,
          child: _body(context),
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
        SizedBox(height: 10,),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 17, left: 29),
                  child: Column(
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
                            fontWeight: FontWeight.normal,
                            fontFamily: Strings.fontRegular,
                            fontSize: 15,
                            color: CustomColors.blackLetter),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, right: 35),
                        child: Column(
                            children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 600),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: <Widget>[
                            customTextField(
                                "Assets/images/ic_telephone.png",
                                "Número telefónico",
                                phoneController,
                                TextInputType.number,
                                [maskFormatter]),
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
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 6, right: 20),
                        child: Text(
                          Strings.challengePassword,
                          style: TextStyle(
                              fontFamily: Strings.fontRegular,
                              fontSize: 10,
                              color: CustomColors.grayLetter2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 17, top: 30),
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
                                                  "Assets/images/ic_check2.png"))

                                          ),
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
                                                  "Assets/images/ic_check.png"))

                                          ),
                                    ),
                                    onTap: () {
                                      this.checkDates = true;
                                      print("False");
                                      setState(() {});
                                    },
                                  ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  Strings.AuthorizeDates,
                                  style: TextStyle(
                                      fontFamily: Strings.fontRegular,
                                      fontSize: 12,
                                      color: CustomColors.blackLetter),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.only(right: 17),
                        child: Row(
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
                                                    "Assets/images/ic_check2.png"))

                                            )),
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
                                                    "Assets/images/ic_check.png"))

                                            )),
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
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 80, right: 80),
                  child: btnCustomRoundedImage(
                      CustomColors.blueSplash, CustomColors.white, Strings.next,
                      () {
                    _serviceRegister();
                  }, context, "Assets/images/ic_next.png"),
                )
              ],
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
                    color: CustomColors.gray.withOpacity(.3)
                         ,
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
                      image:  AssetImage("Assets/images/ic_padlock_blue.png"),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 1,
                      height: 25,
                      color: CustomColors.grayLetter.withOpacity(.4),
                    ),
                    SizedBox(width: 5,),
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
                        image: obscureTextPass? AssetImage("Assets/images/ic_showed.png")
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
                    color: CustomColors.gray.withOpacity(.3),
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
                      image: AssetImage("Assets/images/ic_padlock_blue.png")
                          ,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 1,
                      height: 25,
                      color: CustomColors.grayLetter.withOpacity(.4),
                    ),
                    SizedBox(width: 5,),
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
                        image:  obscureTextConfirmPass? AssetImage("Assets/images/ic_showed.png")
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
    if (phoneController.text == "") {
      utils.showSnackBar(context, Strings.emptyPhone);
      return true;
    }

    if (emailController.text == "") {
      utils.showSnackBar(context, Strings.emptyEmail);
      return true;
    }else if(!validateEmail(emailController.text)){
      utils.showSnackBar(context, Strings.emailInvalidate);
      return true;
    }

    if (passwordController.text == "") {
      utils.showSnackBar(context, Strings.passwordEmpty);
      return true;
    }

    if (confirmPassController.text == "") {
      utils.showSnackBar(context, Strings.emptyConfirmPassword);
      return true;
    }

    if (!validateEmail(emailController.text)) {
      utils.showSnackBar(context, Strings.emailInvalid);
      return true;
    }

    if (!validatePwd(passwordController.text)) {
      utils.showSnackBar(context, Strings.passwordChallenge);
      return true;
    }

    if (confirmPassController.text != passwordController.text) {
      utils.showSnackBar(context, Strings.dontSamePass);
      return true;
    }

    if (!checkDates) {
      utils.showSnackBar(context, Strings.dontCheckDates);
      return true;
    }

    if (!checkTerms) {
      utils.showSnackBar(context, Strings.dontCheckTerms);
      return true;
    }

    widget.user.numPhone = phoneController.text;
    widget.user.email = emailController.text;
    widget.user.passWord = passwordController.text;

    return false;
  }

  _serviceRegister() async {
    FocusScope.of(context).unfocus();

    if (_validateEmptyFields()) {
      return;
    }

    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser =
            providerOnboarding.createAccount(context, widget.user);
        await callUser.then((user) {
          var decodeJSON = jsonDecode(user);
          ResponseUserinfo data = ResponseUserinfo.fromJsonMap(decodeJSON);

          if (data.code.toString() == "100") {
            var dataUser = data.data.user;

            //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BaseNavigationPage()), (Route<dynamic> route) => false);
            Navigator.pop(context);
            utils.startOpenSlideUp(context, dataUser.email,dataUser.fullname);
            //Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child: MyHomePage(), duration: Duration(milliseconds: 700)));

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
