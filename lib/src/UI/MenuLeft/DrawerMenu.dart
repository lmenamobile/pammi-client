
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/UI/HelpSupport.dart';
import 'package:wawamko/src/UI/Home/HomePage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/CustomerService/CustomerServicePage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/FavoritesPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Highlights/HighlightsPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Notifications/NotificationsPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Offers/OffersDayPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Training/TrainingPage.dart';
import 'package:wawamko/src/UI/MenuLeft/Widgets.dart';
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
import 'SectionsMenu/GiftCards/GiftCartPage.dart';

class DrawerMenuPage extends StatefulWidget {
  final rollOverActive;
  DrawerMenuPage({Key? key, this.rollOverActive}) : super(key: key);

  _DrawerMenuPageState createState() => _DrawerMenuPageState();
}

class _DrawerMenuPageState extends State<DrawerMenuPage> {
  var hideMenu = false;
  SharePreference _prefs = SharePreference();
  ProfileProvider? profileProvider;
  late OnboardingProvider providerOnBoarding;


  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    providerOnBoarding = Provider.of<OnboardingProvider>(context);
    return Scaffold(
      backgroundColor: CustomColorsAPP.white.withOpacity(.6),
      body: _body(context),
    );
  }

   _body(BuildContext context) {
    return FadeInLeft(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 35, bottom: 10),
              child: GestureDetector(
                child: Image(image: AssetImage("Assets/images/ic_closed.png"), width: 35,),
                onTap: () => Navigator.pop(context),),
            ),
            Expanded(
              child: Container(
                width: 286,
                padding: EdgeInsets.only(top: 12, bottom: 12),
                decoration: BoxDecoration(
                    color: CustomColorsAPP.grayMenu,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      itemProfile(profileProvider?.user == null ? _prefs.nameUser : profileProvider?.user?.fullname,),
                      SizedBox(height: 20),
                      BounceInDown(
                          child: itemBtnReferred(() => userIsLogged()?openBottomSheet(context, openReferredCode, _prefs.codeShare.toString()):
                          validateSession(context))),

                      itemMenu("ic_start.png",
                          () => widget.rollOverActive != Constants.menuHome
                              ? pushToPage(MyHomePage()) : Navigator.pop(context), Strings.start),

                      itemMenu("ic_offers_day.png",  () => widget.rollOverActive != Constants.menuOffersTheDay
                          ? pushToPage(OffersDayPage()) : Navigator.pop(context), Strings.dayOferts),

                      itemMenu(
                          "ic_highlight.png",
                          () => widget.rollOverActive != Constants.menuHighlights
                                  ? pushToPage(HighlightsPage()) : Navigator.pop(context), Strings.destacados),

                      itemMenu(
                          "ic_favorite.png",
                          () => widget.rollOverActive != Constants.menuFavorites
                              ? userIsLogged()?pushToPage(FavoritesPage()):validateSession(context) : Navigator.pop(context), Strings.wishes),

                      itemMenu("ic_gif_card.png",() => widget.rollOverActive != Constants.menuGiftCard
                          ? pushToPage(GiftCartPage()) : Navigator.pop(context), Strings.giftCards),

                      itemMenu("ic_orders.png", ()=>launch(Constants.urlBlog), Strings.blog),

                      itemMenu("ic_trainings.png", () => widget.rollOverActive != Constants.menuTraining
                          ? pushToPage(TrainingPage()) : Navigator.pop(context), Strings.trainings),
                      itemMenu("ic_notification.png", () => widget.rollOverActive != Constants.menuNotifications
                          ? pushToPage(NotificationsPage()) : Navigator.pop(context), Strings.notifications),
                      itemMenu("ic_support.png", () {
                        widget.rollOverActive != "support" ? pushToPage(SupportHelpPage()) : Navigator.pop(context);
                      }, Strings.supportservices),
                      itemMenu("ic_inf.png", () {
                        widget.rollOverActive != Constants.menuCustomerService ? pushToPage(CustomerServicePage()) : Navigator.pop(context);
                      }, Strings.customerService),
                      SizedBox(height: 17),
                      Opacity(
                        opacity: userIsLogged()?1:0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 39, right: 39),
                          child: btnCustomRounded(CustomColorsAPP.orange,
                              CustomColorsAPP.white, Strings.closeSesion, () {
                            utils.startCustomAlertMessage(
                                context,
                                Strings.closeSesion,
                                "Assets/images/ic_sign_off.png",
                                Strings.closeSesionText, () {
                                 _prefs.deletePrefsLogout();
                                 Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                     MaterialPageRoute(builder: (context) => LoginPage()),
                                         (Route<dynamic> route) => false);
                             // await callAccessToken();
                            }, () {
                              Navigator.pop(context);
                            });
                          }, context),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Versión ${_prefs.versionApp}",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: Strings.fontRegular,
                            color: CustomColorsAPP.gray7),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }



  void openReferredCode() {
      if (_prefs.codeShare.toString().isNotEmpty) {
        Navigator.pop(context);
        openShareLink(_prefs.codeShare.toString());
      } else {
        utils.showSnackBar(context, Strings.errorCodeReferred);
      }
  }

  Widget itemProfile(String? nameUser) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: CustomColorsAPP.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),

        margin: EdgeInsets.only(left: 6, right: 6, top: 6),
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            crossAxisAlignment: _prefs.authToken == "0" ? CrossAxisAlignment.center : CrossAxisAlignment.start ,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(top: _prefs.authToken == "0" ? 0 : 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: CustomColorsAPP.grayBackground,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(100)),
                  child: FadeInImage(
                    image: profileProvider?.user !=
                        null
                        ? NetworkImage(profileProvider
                        ?.user?.photoUrl??'')
                        : NetworkImage(_prefs.photoUser),
                    fit: BoxFit.cover,
                    placeholder: AssetImage(
                        "Assets/images/ic_img_profile.png"),
                    imageErrorBuilder: (_,__,___){
                      return Container();
                    },
                  ),
                ),
              ),
              SizedBox(width: 10),
              _prefs.authToken == "0"?
              Text(
                Strings.login,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: Strings.fontBold,
                    fontSize: 12,
                    color: CustomColorsAPP.yellow),
              ): Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Text(
                      nameUser ?? '',
                      style: TextStyle(
                          fontFamily: Strings.fontBold,
                          fontSize: 12,
                          color: CustomColorsAPP.letterDarkBlue),
                    ),
                    Container(
                      height: 25,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 5,top: 10,bottom: 10),
                      decoration: BoxDecoration(
                        color: CustomColorsAPP.whiteBackGround,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              Strings.linkUp,
                              style: TextStyle(
                                color: CustomColorsAPP.gray7,
                                fontSize: 12,
                                fontFamily: Strings.fontRegular,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              height: 25,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: CustomColorsAPP.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(4), topRight: Radius.circular(4))
                              ),
                              child: Center(
                                child: Text(
                                  _prefs.referredCode,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: CustomColorsAPP.orange,
                                    fontFamily: Strings.fontRegular,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      Strings.seeProfile,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: Strings.fontBold,
                          fontSize: 12,
                          color: CustomColorsAPP.yellow),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: ()=>  widget.rollOverActive == "profile" ? Navigator.pop(context)
          : userIsLogged()?Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.leftToRight,
          child: ProfilePage(), duration: Duration(milliseconds: 700))):validateSession(context),
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
                color: CustomColorsAPP.grayMenu,
                border: Border.all(color: CustomColorsAPP.grayThree, width: 1),
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
                  color: CustomColorsAPP.blackLetter),
            )
          ],
        ),
      ),
      onTap: () => action(),
    );
  }

  pushToPage(Widget page) {
    Navigator.pushReplacement(context, customPageTransition(page,PageTransitionType.leftToRight));
  }

  callAccessToken() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerOnBoarding.getAccessToken();
        await callUser.then((token) {

          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
