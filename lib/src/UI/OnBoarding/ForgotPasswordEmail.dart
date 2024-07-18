import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/VariablesNotifyProvider.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/Onboarding/VerificationCode.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/config/theme/colors.dart';
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
  VariablesNotifyProvider? notifyVariables;
  late OnboardingProvider providerOnboarding;
  String msgError = '';

  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    notifyVariables = Provider.of<VariablesNotifyProvider>(context);

    return Scaffold(
     backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                headerView( Strings.recoverPass,  ()=> Navigator.pop(context)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        Text(
                          Strings.textRecoverPass,
                          style: TextStyle(fontSize: 18, color: AppColors.black1, fontFamily: Strings.fontRegular),
                        ),
                        const SizedBox(height: 42),
                        customBoxEmailForgotPass(emailController, notifyVariables, () {setState(() {});}),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child:btnCustomRounded(AppColors.blueSplash, AppColors.white, Strings.sender, callServicePassword, context),
            ),
            Visibility(visible: providerOnboarding.isLoading, child: LoadingProgress())
          ],
        )
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
          Navigator.of(context).push(customPageTransition(VerificationCodePage(email: emailController.text.trim(), typeView: Constants.isViewPassword,),
              PageTransitionType.rightToLeftWithFade ));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
