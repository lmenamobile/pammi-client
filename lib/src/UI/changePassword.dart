import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool obscureTextCurrentPass = true;
  bool obscureTextPass = true;
  bool obscureTextConfirmPass = true;
  final passwordController = TextEditingController();
  final passwordCurrentController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  String msgError = '';
  ProfileProvider profileProvider;

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: _body(context),
            ),
            Visibility(
                visible: profileProvider.isLoading, child: LoadingProgress()),
          ],
        ),
      ),
    );
  }

  _body(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("Assets/images/ic_header_red.png"),
                fit: BoxFit.fill)),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 15,
              top: 15,
              child: GestureDetector(
                child: Image(
                  width: 40,
                  height: 40,
                  color: Colors.white,
                  image: AssetImage("Assets/images/ic_blue_arrow.png"),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(
              child: Container(
                //alignment: Alignment.center,

                child: Text(
                  Strings.changePass,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: Strings.fontRegular,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 600),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: <Widget>[
                        Text(
                          Strings.changePass,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: Strings.fontBold,
                              color: CustomColors.blackLetter),
                        ),
                        Text(
                          Strings.inputPass,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: Strings.fontRegular,
                              color: CustomColors.blueGray),
                        ),
                        SizedBox(height: 28),
                        txtCurrentPassword(
                            passwordCurrentController, Strings.passCurrent),
                        SizedBox(height: 17),
                        txtPassword(passwordController, Strings.password),
                        SizedBox(height: 25),
                        txtConfirmPassword(
                            passwordConfirmController, Strings.confirmPassword),
                        SizedBox(height: 40),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 30),
                          child: btnCustomRounded(
                              CustomColors.blueSplash,
                              CustomColors.white,
                              Strings.saveDates,
                              callUpdatePWD,
                              context),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      )
    ]);
  }

  Widget txtCurrentPassword(
      TextEditingController passwordController, String hintText) {
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
                    color: CustomColors.gray7.withOpacity(.4),
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
                          hintText: hintText,
                        ),
                        onChanged: (value) {},
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
      ],
    );
  }

  Widget txtPassword(
      TextEditingController passwordController, String hintText) {
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
                    color: CustomColors.gray7.withOpacity(.4),
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
                          hintText: hintText,
                        ),
                        onChanged: (value) {},
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
      ],
    );
  }

  Widget txtConfirmPassword(
      TextEditingController passwordController, String hintText) {
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
                    color: CustomColors.gray7.withOpacity(.4),
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
                          hintText: hintText,
                        ),
                        onChanged: (value) {},
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
      ],
    );
  }

  bool validateFormPWD(){
    bool validateForm = true;
    if (passwordCurrentController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.pwdActuallyEmpty;
    }else if (passwordController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.pwdNewEmpty;
    } else if (passwordConfirmController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.pwdConfirmEmpty;
    }else if (passwordConfirmController.text != passwordController.text) {
      validateForm = false;
      msgError = Strings.pwdNotEquals;
    }else if (!validatePwd(passwordController.text)) {
      validateForm = false;
      msgError = Strings.errorFormatPWD;
    }
    return validateForm;
  }

  callUpdatePWD(){
    if(validateFormPWD()){
      passwordUpdate();
    }else{
      utils.showSnackBar(context, msgError);
    }
  }

  void passwordUpdate() {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = profileProvider.updatePWD(passwordCurrentController.text, passwordController.text);
        await  callUser.then((msg) {
          Navigator.pop(context);
          utils.showSnackBarGood(context, msg);
        }, onError: (error) {
          profileProvider.isLoading = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
