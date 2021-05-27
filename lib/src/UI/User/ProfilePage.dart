import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:wawamko/src/UI/MyAddress.dart';
import 'package:wawamko/src/UI/MyDates.dart';
import 'package:wawamko/src/UI/coupons.dart';
import 'package:wawamko/src/UI/payMethods.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/drawerMenu.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  SharePreference _prefs = SharePreference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: DraweMenuPage(
        rollOverActive: "profile",
      ),
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.redTour,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        Image.asset("Assets/images/ic_bg_profile.png"),
        Column(
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            width: 31,
                            height: 31,
                            child: Center(
                              child: Image(
                                image: AssetImage("Assets/images/ic_menu.png"),
                              ),
                            ),
                          ),
                          onTap: () {
                            _drawerKey.currentState.openDrawer();
                          },
                        ),
                        Expanded(
                            child: Center(
                          child: Text(
                            "Mi perfil",
                            style: TextStyle(
                                fontFamily: Strings.fontBold,
                                fontSize: 15,
                                color: CustomColors.white),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                border: Border.all(
                                    color: CustomColors.white, width: 1),
                              ),
                              child: Center(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 55,
                                      width: 55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        border: Border.all(
                                            color: CustomColors.white,
                                            width: 1),
                                        color: CustomColors.grayBackground,
                                      ),
                                      child: Image(
                                        image: AssetImage(
                                            "Assets/images/ic_default_perfil.png"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 23),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _prefs.nameUser??'',
                                  style: TextStyle(
                                      fontFamily: Strings.fontBold,
                                      fontSize: 18,
                                      color: CustomColors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          itemProfile(
                              context,
                              "Assets/images/ic_user_Profile.png",
                              Strings.myDates,
                              false,
                              true,
                              false, () {
                            Navigator.of(context).push(customPageTransition(MyDatesPage()));
                          }),
                          itemProfile(context, "Assets/images/ic_place.png",
                              Strings.myAddress, true, true, true, () {
                            Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.slideInLeft,
                                child: MyAddressPage(),
                                duration: Duration(milliseconds: 700)));
                          }),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          itemProfile(context, "Assets/images/ic_target.png",
                              Strings.methodsPay, false, false, false, () {
                            Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.slideInLeft,
                                child: PayMethodsPage(),
                                duration: Duration(milliseconds: 700)));
                          }),
                          itemProfile(context, "Assets/images/discount_big.png",
                              Strings.coupons, true, false, true, () {
                            Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.slideInLeft,
                                child: CoupondsPage(),
                                duration: Duration(milliseconds: 700)));
                          }),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget itemProfile(BuildContext context, String icon, String title,
      bool border, bool borderLeft, bool padding, Function action) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(top: padding ? 25 : 0),
        height: 150,
        width: 140,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
                width: 1,
                color: borderLeft
                    ? CustomColors.grayBackground.withOpacity(.1)
                    : CustomColors.grayBackground.withOpacity(.8)),
            bottom: BorderSide(
                width: 1,
                color: border
                    ? CustomColors.grayBackground.withOpacity(.1)
                    : CustomColors.grayBackground.withOpacity(.8)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 105,
              height: 87,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
              child: Center(
                child: Image(width: 50, height: 50, image: AssetImage(icon)),
              ),
            ),
            SizedBox(
              height: 19,
            ),
            Text(
              title,
              style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  fontSize: 13,
                  color: CustomColors.blackLetter),
            )
          ],
        ),
      ),
      onTap: () {
        action();
      },
    );
  }
}
