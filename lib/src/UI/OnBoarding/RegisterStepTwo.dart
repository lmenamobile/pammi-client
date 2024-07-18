import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/VariablesNotifyProvider.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/OnBoarding/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import '../../Providers/SupportProvider.dart';

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
  var maskFormatter = new MaskTextInputFormatter(mask: '###############', filter: {"#": RegExp(r'[0-9]')});
  late VariablesNotifyProvider? notifyVariables;
  late OnboardingProvider providerOnBoarding;
  String msgError = '';
  late SupportProvider supportProvider;

  @override
  void initState() {

    supportProvider = Provider.of<SupportProvider>(context, listen: false);
    providerOnBoarding = OnboardingProvider();
    serviceGetTerms();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    providerOnBoarding = Provider.of<OnboardingProvider>(context);
    notifyVariables = Provider.of<VariablesNotifyProvider>(context);
    supportProvider = Provider.of<SupportProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                headerView( Strings.register, ()=> Navigator.pop(context)),
                Expanded(child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 55,),
                      Text(
                        "¡${Strings.createAccount}!",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: Strings.fontBold, fontSize: 36, color: AppColors.blueTitle),
                      ),
                      SizedBox(height: 17),
                      Text(
                        Strings.registerMsg,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 18, color: AppColors.black1),
                      ),
                      SizedBox(height: 52),
                      Column(
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 600),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(child: widget,),
                            ),
                            children: <Widget>[
                              SizedBox(height: 21),
                              customBoxEmailRegister(emailController, notifyVariables, () {setState(() {});}),
                              SizedBox(height: 15),
                              customTextFieldIcon("ic_data.png",true, Strings.codeReferred, referredController, TextInputType.text, [ LengthLimitingTextInputFormatter(30)]),
                              //PASSWORD
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    customBoxPassword(AppColors.gray.withOpacity(.3),Strings.password,notifyVariables!.intRegister.
                                    validPass!,"Assets/images/ic_padlock_blue.png","Assets/images/ic_padlock_blue.png",
                                        passwordController,providerOnBoarding.obscureTextPass,validatePassLogin,showPassword),
                                    Visibility(
                                      visible: notifyVariables!.intRegister.validPass == false ? true : false,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8, top: 2),
                                        child: Text(Strings.passwordChallenge, style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 13, color: AppColors.red),),
                                      ),
                                    )
                                  ]),
                              //CONFIRM PASSWORD
                              SizedBox(height: 21),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    customBoxPassword(AppColors.gray.withOpacity(.3),Strings.confirmPassword,notifyVariables!.intRegister.validConfirmPass!,"Assets/images/ic_padlock_blue.png","Assets/images/ic_padlock_blue.png",confirmPassController,providerOnBoarding.obscureTextConfirmPass,validateConfirmPassLogin,showConfirmPassword),
                                    Visibility(
                                        visible: notifyVariables!.intRegister.validConfirmPass == false ? true : false,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8, top: 2),
                                          child: Text(Strings.passwordChallenge, style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 13, color: AppColors.red),),
                                        )
                                    )
                                  ]),
                              SizedBox(height: 10),
                            ],
                          )),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 6, right: 6),
                        child: Text(
                          Strings.challengePassword,
                          style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 12, color: AppColors.grayLetter2),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: itemCheck(() => providerOnBoarding.stateDates = !providerOnBoarding.stateDates, providerOnBoarding.stateDates,
                            Text(Strings.AuthorizeDates, style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 12, color: AppColors.blackLetter),)),
                      ),
                      const SizedBox(height: 20),
                      itemCheck(() => providerOnBoarding.stateTerms = !providerOnBoarding.stateTerms, providerOnBoarding.stateTerms, termsAndConditions(supportProvider.lstTermsAndConditions[0].url.toString())),
                      const SizedBox(height: 20),
                      btnCustomRounded(AppColors.blueSplash, Colors.white, Strings.next, callRegisterUser, context)
                    ],
                  ),
                )),
              ],
            ),
            Visibility(visible: providerOnBoarding.isLoading, child: LoadingProgress())
          ],
        ),
      ),
    );
  }


  validatePassLogin(value){
    if (validatePwd(value)) {
      notifyVariables!.intRegister.validPass = true;
      setState(() {});
    } else {
      notifyVariables!.intRegister.validPass = false;
      setState(() {});
    }
  }

  showPassword(){
    providerOnBoarding.obscureTextPass = !providerOnBoarding.obscureTextPass;
  }
  validateConfirmPassLogin(value){
    if (validatePwd(value)) {
      notifyVariables!.intRegister.validConfirmPass = true;
      setState(() {});
    } else {
      notifyVariables!.intRegister.validConfirmPass = false;
      setState(() {});
    }
  }
  showConfirmPassword(){
    providerOnBoarding.obscureTextConfirmPass = !providerOnBoarding.obscureTextConfirmPass;
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
      widget.user!.email = emailController.text;
      widget.user!.passWord = passwordController.text;
      _serviceRegister();
    } else {
      utils.showSnackBar(context, msgError);
    }
  }

  _serviceRegister() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerOnBoarding.createAccount(widget.user!,referredController.text);
        await callUser.then((user) {
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

  serviceGetTerms() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSupport = supportProvider.getTermsAndConditions();
        await callSupport.then((list) {
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
