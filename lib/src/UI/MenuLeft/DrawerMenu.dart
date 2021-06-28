import 'dart:io';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/UI/Featured.dart';
import 'package:wawamko/src/UI/HelpSupport.dart';
import 'package:wawamko/src/UI/Home/HomePage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/FavoritesPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Highlights/HighlightsPage.dart';
import 'package:wawamko/src/UI/MenuLeft/Widgets.dart';
import 'package:wawamko/src/UI/MyOrders.dart';
import 'package:wawamko/src/UI/dayOferts.dart';
import 'package:wawamko/src/UI/User/ProfilePage.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../Onboarding/Login.dart';

class DrawerMenuPage extends StatefulWidget {
  final rollOverActive;

  DrawerMenuPage({Key key, this.rollOverActive}) : super(key: key);

  _DrawerMenuPageState createState() => _DrawerMenuPageState();
}

class _DrawerMenuPageState extends State<DrawerMenuPage> {
  var hideMenu = false;
  SharePreference _prefs = SharePreference();
  ProfileProvider profileProvider;

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: CustomColors.white.withOpacity(.5),
      body: Container(
          child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    return FadeInLeft(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 35,bottom: 10),
              child: GestureDetector(
                child: Image(
                  image: AssetImage("Assets/images/ic_closed.png"),
                  width: 35,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: Container(
                width: 286,
                padding: EdgeInsets.only(top: 12, bottom: 12),
                decoration: BoxDecoration(
                    color: CustomColors.grayMenu,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      itemProfile(
                        context,
                        profileProvider?.user == null
                            ? _prefs.nameUser
                            : profileProvider?.user?.fullname,
                      ),
                      SizedBox(height: 23),
                      BounceInDown(
                          child: itemBtnReferred(() => openBottomSheet(context,
                              openReferredCode, _prefs.referredCode.toString()))),
                      itemMenu("ic_start.png", () => widget.rollOverActive != Constants.menuHome ? pushToPage(MyHomePage()) : Navigator.pop(context), Strings.start),
                      itemMenu("ic_ offers_day.png", () {}, Strings.dayOferts),
                      itemMenu("ic_featured.png",  () => widget.rollOverActive != Constants.menuHighlights? pushToPage(HighlightsPage()) : Navigator.pop(context), Strings.destacados),
                      itemMenu("ic_wishes.png", () => widget.rollOverActive != Constants.menuFavorites ? pushToPage(FavoritesPage()) : Navigator.pop(context), Strings.wishes),
                      itemMenu("ic_news.png", () {}, Strings.myOrders),
                      itemMenu(
                          "ic_ notification.png", () {}, Strings.notifications),
                      itemMenu("ic_support.png", () {
                        widget.rollOverActive != "support"
                            ? pushToPage(SupportHelpPage())
                            : Navigator.pop(context);
                      }, Strings.supportservices),
                      SizedBox(height: 17),
                      Padding(
                        padding: const EdgeInsets.only(left: 39, right: 39),
                        child: btnCustomRounded(CustomColors.orange,
                            CustomColors.white, Strings.closeSesion, () {
                          utils.startCustomAlertMessage(
                              context,
                              Strings.closeSesion,
                              "Assets/images/ic_sign_off.png",
                              Strings.closeSesionText, () {
                            _prefs.dataUser = "0";
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.of(context).pushReplacement(PageTransition(
                                type: PageTransitionType.slideInUp,
                                child: LoginPage(),
                                duration: Duration(milliseconds: 700)));
                          }, () {
                            Navigator.pop(context);
                          });
                        }, context),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  void openReferredCode() {
    if (_prefs.referredCode.toString().isNotEmpty) {
      Navigator.pop(context);
      openShareLink(_prefs.referredCode.toString());
    } else {
      utils.showSnackBar(context, Strings.errorCodeReferred);
    }
  }

  Widget itemProfile(BuildContext context, String nameUser) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        height: 63,
        margin: EdgeInsets.only(left: 6, right: 6, top: 6),
        child: Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: CustomColors.grayBackground,
                ),
                child: Center(
                  child: Image(
                    fit: BoxFit.fill,
                    image: AssetImage("Assets/images/ic_default_perfil.png"),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      nameUser ?? '',
                      style: TextStyle(
                          fontFamily: Strings.fontBold,
                          fontSize: 12,
                          color: CustomColors.letterDarkBlue),
                    ),
                    Text(
                      Strings.seeProfile,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: Strings.fontBold,
                          fontSize: 12,
                          color: CustomColors.yellow),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        widget.rollOverActive == "profile"
            ? Navigator.pop(context)
            : Navigator.of(context).pushReplacement(PageTransition(
                type: PageTransitionType.slideInLeft,
                child: ProfilePage(),
                duration: Duration(milliseconds: 700)));
      },
    );
  }

  Widget itemMenu(String icon, Function action, String titleAction) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 30, right: 30),
        height: 63,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: CustomColors.grayMenu,
                border: Border.all(color: CustomColors.grayThree, width: 1),
              ),
              child: Center(
                child: Image(
                  width: 23,
                  height: 23,
                  fit: BoxFit.fill,
                  image: AssetImage("Assets/images/$icon"),
                ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              titleAction,
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: Strings.fontBold,
                  color: CustomColors.blackLetter),
            )
          ],
        ),
      ),
      onTap: () => action(),
    );
  }

  pushToPage(Widget page) {
    Navigator.pushReplacement(context, customPageTransition(page));
  }
}
