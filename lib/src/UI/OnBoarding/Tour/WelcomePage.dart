import 'package:flutter/material.dart';
import 'package:wawamko/src/UI/Home/HomePage.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../Login.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: WillPopScope(
        onWillPop: (() async => showAlertActions(
            context, Strings.closeApp, Strings.textCloseApp,"ic_sign_off.png",()=>Navigator.pop(context,true), ()=>Navigator.pop(context)) as Future<bool>),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image(
            fit: BoxFit.fitWidth,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            image: AssetImage("Assets/images/ic_img_begin.png"),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Strings.welcome3,
                  style: TextStyle(
                    fontSize: 48,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blueTitle,
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  Strings.textWelcome,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 15,
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.blueTitle,
                  ),
                ),
                SizedBox(height: 34),
                btnCustomRoundedBorder(CustomColors.blueSplash,
                    CustomColors.white, Strings.login, () {
                      Navigator.of(context).push(customPageTransition(
                          LoginPage()));
                    }, context, CustomColors.white),
                SizedBox(height: 20),
                btnCustomRounded(CustomColors.gray13,
                    CustomColors.gray14, Strings.begin, () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                              (Route<dynamic> route) => false);
                    }, context),
                SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
