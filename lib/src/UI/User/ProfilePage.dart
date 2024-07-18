import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/Providers/ProviderHome.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/MenuProfile/MyCreditCards.dart';
import 'package:wawamko/src/UI/MenuProfile/MyAddress.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/MyClaimPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/MyOrdersPage.dart';
import 'package:wawamko/src/UI/OnBoarding/Login.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/UI/MenuLeft/DrawerMenu.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:animate_do/animate_do.dart';

import 'MyDates.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  SharePreference _prefs = SharePreference();
  ProfileProvider? profileProvider;
  late ProviderSettings providerSettings;
  late ProviderHome providerHome;

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    providerHome = Provider.of<ProviderHome>(context);
    return Scaffold(
      key: _drawerKey,
      drawer: DrawerMenuPage(
        rollOverActive: "profile",
      ),
      backgroundColor: AppColors.redTour,
      body: SafeArea(
        child: Container(
          color: AppColors.redTour,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        //Image.asset("Assets/images/ic_bg_profile.png"),
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
                            _drawerKey.currentState!.openDrawer();
                          },
                        ),
                        Expanded(
                            child: Center(
                          child: Text(
                            "Mi perfil",
                            style: TextStyle(
                                fontFamily: Strings.fontBold,
                                fontSize: 24,
                                color: AppColors.white),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            border: Border.all(
                                color: AppColors.white, width: 1),
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
                                        color: AppColors.white,
                                        width: 1),
                                    color: AppColors.grayBackground,
                                  ),
                                  child:  Container(
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
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                profileProvider!.user==null?_prefs.nameUser:profileProvider?.user?.fullname??'',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontFamily: Strings.fontBold,
                                    fontSize: 18,
                                    color: AppColors.white),
                              ),
                              SizedBox(height: 5,),
                              GestureDetector(
                                onTap: (){
                                  print("ALERTA");
                                  utils.alertCloseAccount(context,(){closeAccount();});
                                },
                                child: Text(
                                  "Cerrar cuenta",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: Strings.fontRegular,
                                      fontSize: 15,
                                      color: AppColors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: Container(
                  child:  providerSettings.hasConnection?SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                       linkUser(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Navigator.of(context).push(customPageTransition(MyDatesPage(),PageTransitionType.rightToLeft));
                                }),
                                itemProfile(context, "Assets/images/ic_place.png",
                                    Strings.myAddress, false, true, true, () {
                                  Navigator.of(context).push(customPageTransition( MyAddressPage(),PageTransitionType.rightToLeft));
                                }),
                                itemProfile(context, "Assets/images/ic_my_claims.png",
                                    Strings.myClaims, true, true, false, () {
                                      Navigator.of(context).push(customPageTransition( MyClaimPage(),PageTransitionType.rightToLeft));
                                    }),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                itemProfile(context, "Assets/images/ic_target.png",
                                    Strings.methodsPay, false, false, false, () {
                                  Navigator.of(context).push(customPageTransition(MyCreditCards(isActiveSelectCard: false,),PageTransitionType.rightToLeft));
                                }),
                                itemProfile(context, "Assets/images/ic_order_history.png",
                                    Strings.myOrders, true, false, true, () {
                                 Navigator.push(context, customPageTransition(MyOrdersPage(),PageTransitionType.rightToLeft));
                                }),

                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ):notConnectionInternet(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget linkUser(){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.blueSplash,
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  Strings.linkUp,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: Strings.fontBold
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  Strings.shareYourCode,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: Strings.fontRegular
                  ),
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: ()=>profileProvider!.isOpenLink = !profileProvider!.isOpenLink,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(profileProvider!.isOpenLink?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down_sharp,color: AppColors.blueSplash,),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: profileProvider!.isOpenLink,
          child: BounceInDown(
            child: Container(
              margin: EdgeInsets.only(left: 30,right: 30,top: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.blueSplash,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      _prefs.referredCode,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: Strings.fontBold
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                    ? AppColors.grayBackground.withOpacity(.1)
                    : AppColors.grayBackground.withOpacity(.8)),
            bottom: BorderSide(
                width: 1,
                color: border
                    ? AppColors.grayBackground.withOpacity(.1)
                    : AppColors.grayBackground.withOpacity(.8)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 87,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
              child: Center(
                child: Image.asset(icon,width: 40,height: 40,fit: BoxFit.fill,),
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
                  color: AppColors.blackLetter),
            )
          ],
        ),
      ),
      onTap: () {
        action();
      },
    );
  }

  closeAccount() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCloseAccount = profileProvider!.getCloseAccount();
        await callCloseAccount.then((list) {
          print("DIO 200");
          Navigator.pop(context);
          Timer(const Duration(seconds: 2), () {
            utils.accountClosedSuccessfully(context);
          });
          Timer(const Duration(seconds: 5), () {
            Navigator.pushReplacement(context, customPageTransition( LoginPage(),PageTransitionType.rightToLeft));
          });

        }, onError: (error) {
          // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }


}
