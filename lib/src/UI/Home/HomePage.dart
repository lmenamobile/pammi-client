import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Providers/ProviderHome.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/UI/MenuLeft/DrawerMenu.dart';

import 'Widgets.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final searchController = TextEditingController();
  RefreshController _refreshCategories =
      RefreshController(initialRefresh: false);
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  ProviderSettings providerSettings;
  ProviderHome providerHome;
  SharePreference prefs = SharePreference();
  PageController controllerBanner = PageController(
    initialPage: 0,
    keepPage: true,
  );
  int pageOffset = 0;
  int pageOffsetBrands = 0;

  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context, listen: false);
    providerHome = Provider.of<ProviderHome>(context, listen: false);
    providerHome.ltsBrands.clear();
    providerSettings.ltsCategories.clear();
    serviceGetCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    providerHome = Provider.of<ProviderHome>(context);
    return Scaffold(
      key: _drawerKey,
      drawer: DrawerMenuPage(
        rollOverActive: "start",
      ),
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
            color: CustomColors.grayBackground, child: _body(context)),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[CustomColors.redTour, CustomColors.redOne],
            ),
          ),
          child: Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                          child: Image(
                            image: AssetImage("Assets/images/ic_menu.png"),
                          ),
                        ),
                      ),
                      onTap: () => _drawerKey.currentState.openDrawer(),
                    ),
                    Image(
                      height: 25,
                      image: AssetImage("Assets/images/ic_logo_email.png"),
                    ),
                    GestureDetector(
                      child: Container(
                        width: 30,
                        child: Image(
                          image: AssetImage("Assets/images/ic_car.png"),
                        ),
                      ),
                      onTap: null,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                boxSearchHome(searchController)
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    height: 120,
                    width: double.infinity,
                    child:sliderBanner(providerHome.indexBannerHeader,updateIndexBannerHeader,null)),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      sectionCategories(),
                      sectionsBrands(),
                      sectionHighlight(),
                      sectionBestSellers(),
                      Image.asset(
                        "Assets/images/ic_banner.png",
                        width: double.infinity,
                        fit: BoxFit.fill,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget sectionCategories(){
    return Container(
      margin: EdgeInsets.only(left: 15,right: 15,top: 20,bottom: 5),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  Strings.categories,
                  style: TextStyle(
                      color: CustomColors.letterDarkBlue,
                      fontSize: 16,
                      fontFamily: Strings.fontBold),
                ),
                GestureDetector(
                  child: Text(
                    Strings.moreAll,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: CustomColors.blueOne,
                        fontSize: 12,
                        fontFamily: Strings.fontBold),
                  ),
                  onTap: null,
                ),
              ],
            ),
          ),
          GridView.builder(
            gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
              crossAxisSpacing: 5.0,
            ),
            padding: EdgeInsets.only(top: 20),
            physics: NeverScrollableScrollPhysics(),
            itemCount: providerSettings.ltsCategories.length > 6
                ? 6
                : providerSettings.ltsCategories.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return itemCategory(
                  providerSettings.ltsCategories[index]);
            },
          ),
          customDivider(),
        ],
      ),
    );
  }

  Widget sectionsBrands(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.enjoy,
            style: TextStyle(
                fontSize: 13,
                fontFamily: Strings.fontRegular,
                color: CustomColors.blueOne),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.ourOfficialBrands,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blueSplash),
              ),
              Text(
                Strings.moreAll,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: CustomColors.blueOne,
                    fontSize: 12,
                    fontFamily: Strings.fontBold),
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 100,
              child: listItemsBrands()),
          customDivider(),
        ],
      ),
    );
  }

  Widget sectionHighlight(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            child: Text(
              Strings.findHere,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: Strings.fontRegular,
                  color: CustomColors.blueOne),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.highlightedOffers,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: Strings.fontBold,
                      color: CustomColors.blueSplash),
                ),
                Text(
                  Strings.moreAll,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: CustomColors.blueOne,
                      fontSize: 12,
                      fontFamily: Strings.fontBold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 200,
              width: double.infinity,
              child:sliderBanner(providerHome.indexBannerFooter,updateIndexBannerFooter,null)),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget sectionBestSellers(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.discoverThe,
            style: TextStyle(
                fontSize: 13,
                fontFamily: Strings.fontRegular,
                color: CustomColors.blueOne),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.mostSelledProducts,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blueSplash),
              ),
              Text(
                Strings.moreAll,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: CustomColors.blueOne,
                    fontSize: 12,
                    fontFamily: Strings.fontBold),
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 260,
              child: listBestSellers()),
        ],
      ),
    );
  }

  Widget listItemsBrands() {
    return ListView.builder(
      itemCount:
          providerHome.ltsBrands.length > 6 ? 6 : providerHome.ltsBrands.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: itemBrand(providerHome.ltsBrands[index]),
        );
      },
    );
  }

  Widget listBestSellers() {
    return ListView.builder(
      itemCount: 5,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: itemProduct(),
        );
      },
    );
  }

  updateIndexBannerFooter(int index){
    providerHome.indexBannerFooter = index;
  }

  updateIndexBannerHeader(int index){
    providerHome.indexBannerHeader = index;
  }

  serviceGetCategories() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings = providerSettings.getCategoriesInterest(
            "", pageOffset, prefs.countryIdUser);
        await callSettings.then((list) {
          getBrands();
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  getBrands() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callHome = providerHome.getBrands(pageOffsetBrands.toString());
        await callHome.then((list) {}, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
