import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/OnBoarding/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class RegisterStepTwoPage extends StatefulWidget {
  final UserModel? user;

  RegisterStepTwoPage({Key? key, this.user}) : super(key: key);

  @override
  _RegisterStepTwoPageState createState() => _RegisterStepTwoPageState();
}

class _RegisterStepTwoPageState extends State<RegisterStepTwoPage> {
  final emailController = TextEditingController();
  final referredController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '###############', filter: {"#": RegExp(r'[0-9]')});
  NotifyVariablesBloc? notifyVariables;
  late OnboardingProvider providerOnBoarding;
  bool obscureTextPass = true;
  bool obscureTextConfirmPass = true;
  String msgError = '';



  @override
  Widget build(BuildContext context) {
    providerOnBoarding = Provider.of<OnboardingProvider>(context);
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
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
            header(context, Strings.register,CustomColors.red, ()=> Navigator.pop(context)),
            Expanded(child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 55,
                  ),
                  Text(
                    "¡${Strings.createAccount}!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: Strings.fontBold,
                        fontSize: 36,
                        color: CustomColors.blueTitle),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Text(
                    Strings.registerMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 18,
                        color: CustomColors.black1),
                  ),
                  SizedBox(height: 52),
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
                          SizedBox(height: 15),
                          customTextFieldIcon("ic_data.png",true, Strings.codeReferred,
                              referredController, TextInputType.text, [ LengthLimitingTextInputFormatter(30)]),

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
                          fontSize: 12,
                          color: CustomColors.grayLetter2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: itemCheck(
                            () => providerOnBoarding.stateDates =
                        !providerOnBoarding.stateDates,
                        providerOnBoarding.stateDates,
                        Text(
                          Strings.AuthorizeDates,
                          style: TextStyle(
                              fontFamily: Strings.fontRegular,
                              fontSize: 12,
                              color: CustomColors.blackLetter),
                        )),
                  ),
                  const SizedBox(height: 20),
                  itemCheck(() => providerOnBoarding.stateTerms =
                  !providerOnBoarding.stateTerms, providerOnBoarding.stateTerms, termsAndConditions()),
                  const SizedBox(height: 20),
                  btnCustomRounded(CustomColors.blueSplash, Colors.white, Strings.next, callRegisterUser, context)

                ],
              ),
            )),



          ],
        ),
        Visibility(visible: providerOnBoarding.isLoading, child: LoadingProgress())
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
                borderRadius: BorderRadius.all(Radius.circular(26)),
                border: Border.all(
                    color: CustomColors.gray.withOpacity(.3), width: 1),
                color: CustomColors.white),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      width: 25,
                      height: 25,
                      image: AssetImage("Assets/images/ic_padlock_blue.png"),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 1,
                      height: 20,
                      color: CustomColors.gray7.withOpacity(.3),
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
                              color: CustomColors.gray7.withOpacity(.4),
                              fontSize: 16,
                              fontFamily: Strings.fontRegular,
                            ),
                            hintText: Strings.password,
                          ),
                          onChanged: (value) {
                            if (validatePwd(value)) {
                              notifyVariables!.intRegister.validPass = true;
                              setState(() {});
                            } else {
                              notifyVariables!.intRegister.validPass = false;
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
                borderRadius: BorderRadius.all(Radius.circular(26)),
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
                      width: 25,
                      height: 25,
                      image: AssetImage("Assets/images/ic_padlock_blue.png"),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 1,
                      height: 20,
                      color: CustomColors.gray7.withOpacity(.3),
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
                              color: CustomColors.gray7.withOpacity(.4),
                              fontFamily: Strings.fontRegular,
                            ),
                            hintText: Strings.confirmPassword,
                          ),
                          onChanged: (value) {
                            if (validatePwd(value)) {
                              notifyVariables!.intRegister.validConfirmPass =
                                  true;
                              setState(() {});
                            } else {
                              notifyVariables!.intRegister.validConfirmPass =
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
    } else if (!providerOnBoarding.stateDates) {
      msgError = Strings.dontCheckDates;
      return false;
    }
    /*else if (!providerOnBoarding.stateCentrals) {
      msgError = Strings.notCheckCentral;
      return false;
    }*/
    else if (!providerOnBoarding.stateTerms) {
      msgError = Strings.dontCheckTerms;
      return false;
    }else{
      return true;
    }

  }

  callRegisterUser() {
    if (_validateEmptyFields()) {
      print("aqui2 $msgError");
      widget.user!.email = emailController.text;
      widget.user!.passWord = passwordController.text;
      _serviceRegister();
    } else {
      print("aqui1 ${msgError}");
      utils.showSnackBar(context, msgError);
    }
  }

  _serviceRegister() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerOnBoarding.createAccount(widget.user!,referredController.text);
        await callUser.then((user) {
          print("aqui3");
          utils.startOpenSlideUp(context, user.email, user.fullname);
        }, onError: (error) {
          print("error $error");
          utils.showSnackBar(context, error);
        });
      } else {

        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
