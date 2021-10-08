import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/Onboarding/VerificationCode.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class ForgotPasswordEmailPage extends StatefulWidget {
  @override
  _ForgotPasswordEmailPageState createState() =>
      _ForgotPasswordEmailPageState();
}

class _ForgotPasswordEmailPageState extends State<ForgotPasswordEmailPage> {
  final emailController = TextEditingController();
  NotifyVariablesBloc? notifyVariables;
  late OnboardingProvider providerOnboarding;
  String msgError = '';

  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
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
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 170),
                child: Image(
                  image: AssetImage("Assets/images/ic_shape.png"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 75, left: 30),
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
                      Strings.recoverPass,
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
                        Strings.textRecoverPass,
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
                    top: 10
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
                customBoxEmailForgotPass(emailController, notifyVariables, () {
                  setState(() {});
                }),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: btnCustomRounded(
                      CustomColors.blueSplash,
                      CustomColors.white,
                      Strings.send,
                      callServicePassword,
                      context),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void callServicePassword() {
    if (_validateEmptyFields()) {
      _servicePasswordRecovery();
    } else {
      utils.showSnackBar(context, msgError);
    }
  }

  bool _validateEmptyFields() {
    FocusScope.of(context).unfocus();
    bool validate = true;
    if (emailController.text.isEmpty) {
      validate = false;
      msgError = Strings.emptyEmail;
    } else if (!validateEmail(emailController.text.trim())) {
      validate = false;
      msgError = Strings.emailInvalid;
    }
    return validate;
  }

  _servicePasswordRecovery() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerOnboarding.passwordRecovery(emailController.text.trim());
        await callUser.then((msg) {
          Navigator.of(context).push(customPageTransition(VerificationCodePage(email: emailController.text.trim(), typeView: Constants.isViewPassword,)));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
