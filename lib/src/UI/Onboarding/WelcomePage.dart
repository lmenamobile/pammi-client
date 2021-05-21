import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:wawamko/src/UI/HomePage.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import 'login.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.blueSplash,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: _body(context),
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
            padding: const EdgeInsets.only(left: 42, right: 27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Strings.welcome,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.white,
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  Strings.textWelcome,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 15,
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.white,
                  ),
                ),
                SizedBox(height: 34),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: btnCustomRoundedBorder(CustomColors.blueSplash,
                      CustomColors.white, Strings.login, () {
                    Navigator.of(context).push(PageTransition(
                        type: PageTransitionType.slideInLeft,
                        child: LoginPage(),
                        duration: Duration(milliseconds: 700)));
                  }, context, CustomColors.white),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35),
                  child: btnCustomRounded(CustomColors.white,
                      CustomColors.grayLetter, Strings.begin, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                        (Route<dynamic> route) => false);
                  }, context),
                ),
                SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
