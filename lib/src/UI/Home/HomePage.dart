import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Brand.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Providers/ConectionStatus.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/Providers/ProviderHome.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/UI/Home/Brands/BrandsPage.dart';
import 'package:wawamko/src/UI/Home/Categories/CategoriesPage.dart';
import 'package:wawamko/src/UI/Home/Categories/ProductCategoryPage.dart';
import 'package:wawamko/src/UI/Home/Categories/SubCategoryPage.dart';
import 'package:wawamko/src/UI/Home/SearchProduct/SearchProductHome.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Highlights/HighlightsPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/ShopCartPage.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/UI/MenuLeft/DrawerMenu.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'Products/DetailProductPage.dart';
import 'Widgets.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final searchController = TextEditingController();
  RefreshController _refreshHome = RefreshController(initialRefresh: false);
  RefreshController _refreshCategories = RefreshController(initialRefresh: false);
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late ProviderSettings providerSettings;
  ProviderHome? providerHome;
  ProfileProvider? profileProvider;
  late ProviderShopCart  providerShopCart;
  SharePreference prefs = SharePreference();
  ConnectionAdmin connectionStatus = ConnectionAdmin.getInstance();


  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context, listen: false);
    providerHome = Provider.of<ProviderHome>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    providerHome!.ltsBrands.clear();
    providerHome!.ltsBanners.clear();
    providerHome!.ltsBannersOffer.clear();
    providerSettings.ltsCategories.clear();
    providerHome!.ltsMostSelledProducts.clear();
    connectionStatus.initialize('www.google.com');
    if (prefs.countryIdUser != "0") {
      serviceGetCategories();
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        selectCountryUserNotLogin();
      });
    }
    profileProvider?.user?.photoUrl = prefs.photoUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    providerHome = Provider.of<ProviderHome>(context);
    providerShopCart = Provider.of<ProviderShopCart>(context);
    connectionStatus.connectionListen.listen((value){
      providerSettings.hasConnection = value;
    });
    return Scaffold(
      key: _drawerKey,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuHome,
      ),
      backgroundColor: CustomColors.redTour,
      body: WillPopScope(
        onWillPop:(()=> utils.startCustomAlertMessage(context, Strings.sessionClose,
            "Assets/images/ic_sign_off.png", Strings.closeAppText, ()=>
              Navigator.pop(context,true), ()=>Navigator.pop(context,false)).then((value) => value!)),
        child: SafeArea(
          child: Container(
              color: CustomColors.grayBackground, child: _body(context)),
        ),
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
                      onTap: () => _drawerKey.currentState!.openDrawer(),
                    ),
                    Image(
                      height: 25,
                      image: AssetImage("Assets/images/ic_logo_email.png"),
                    ),
                    GestureDetector(
                      child: Stack(
                        children: [
                          Container(
                            width: 30,
                            child: Image(
                              image: AssetImage("Assets/images/ic_car.png"),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Visibility(
                              visible: providerShopCart.totalProductsCart!="0"?true:false,
                              child: CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                                child: Text(
                                  providerShopCart.totalProductsCart,
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: CustomColors.redTour
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      onTap: () => Navigator.push(
                          context, customPageTransition(ShopCartPage())),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: boxSearchNextPage(searchController, openPageSearch))
              ],
            ),
          ),
        ),
        Expanded(
          child: SmartRefresher(
            controller: _refreshHome,
            enablePullDown: true,
            header: headerRefresh(),
            footer: footerRefreshCustom(),
            onRefresh: _pullToRefresh,
            child: providerSettings.hasConnection?SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                      height: 200,
                      width: double.infinity,
                      child: providerHome!.ltsBanners.isEmpty
                          ? Center(
                              child: loadingWidgets(70),
                            )
                          : sliderBanner(providerHome?.indexBannerHeader,
                              updateIndexBannerHeader, providerHome!.ltsBanners)),
                  Container(
                    margin: EdgeInsets.only(top: 185),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        sectionCategories(),
                        sectionsBrands(),
                        providerHome!.ltsBannersOffer.isEmpty
                            ? Container()
                            : sectionHighlight(),
                        sectionBestSellers(),

                      ],
                    ),
                  ),
                ],
              ),
            ):notConnectionInternet(),
          ),
        ),
      ],
    );
  }

  Widget sectionCategories() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
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
                InkWell(
                  onTap: () => Navigator.push(
                      context, customPageTransition(CategoriesPage())),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: CustomColors.blue.withOpacity(.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                      child: Text(
                        Strings.moreAll,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: CustomColors.blueOne,
                            fontSize: 12,
                            fontFamily: Strings.fontBold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8,),
          AnimationLimiter(
            child: GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
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
              itemBuilder: (_, int index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 3,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: InkWell(
                          onTap: () =>
                              openSubCategory(providerSettings.ltsCategories[index]),
                          child: itemCategory(providerSettings.ltsCategories[index])),
                    ),
                  ),
                );
              },
            ),
          ),
          customDivider(),
        ],
      ),
    );
  }

  Widget sectionsBrands() {
    return providerHome!.ltsBrands.isEmpty?Container():Container(
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
              InkWell(
                onTap: ()=>openAllBrands(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: CustomColors.blue.withOpacity(.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                    child: Text(
                      Strings.moreAll,
                      style: TextStyle(
                          color: CustomColors.blueOne,
                          fontSize: 12,
                          fontFamily: Strings.fontBold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8,),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 100,
              child: listItemsBrands()),
          customDivider(),
        ],
      ),
    );
  }

  Widget sectionHighlight() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              Strings.findHere,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: Strings.fontRegular,
                  color: CustomColors.blueOne),
            ),
          ),
          SizedBox(
            height: 5,
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
                InkWell(
                  onTap: () => Navigator.pushReplacement(context, customPageTransition( HighlightsPage())),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: CustomColors.blue.withOpacity(.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                      child: Text(
                        Strings.moreAll,
                        style: TextStyle(
                            color: CustomColors.blueOne,
                            fontSize: 12,
                            fontFamily: Strings.fontBold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 200,
              width: double.infinity,
              child: providerHome!.ltsBannersOffer.isEmpty
                  ? Center(child: loadingWidgets(70),)
                  : sliderBanner(providerHome!.indexBannerFooter,
                      updateIndexBannerFooter, providerHome!.ltsBannersOffer)),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget sectionBestSellers() {
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
            ],
          ),
          SizedBox(
            height: 20,
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
      itemCount: providerHome!.ltsBrands.length > 6 ? 6 : providerHome!.ltsBrands.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: ()=>openProductsByBrand(providerHome!.ltsBrands[index]),
              child: itemBrand(providerHome!.ltsBrands[index])),
        );
      },
    );
  }

  Widget listBestSellers() {
    return ListView.builder(
      itemCount: providerHome?.ltsMostSelledProducts.length??0,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: ()=>openDetailProduct(providerHome!.ltsMostSelledProducts[index]),
              child: itemProduct(providerHome!.ltsMostSelledProducts[index])),
        );
      },
    );
  }

  openProductsByBrand(Brand brand){
    Navigator.push(context, customPageTransition(ProductCategoryPage( idBrand:brand.id.toString())));
  }

  openAllBrands(){
    Navigator.push(context, customPageTransition(BrandsPage()));
  }

  openDetailProduct(Product product){
    Navigator.push(context, customPageTransition(DetailProductPage(product: product)));
  }

  openSubCategory(Category category) {
    Navigator.push(
        context,
        customPageTransition(SubCategoryPage(
          category: category,
        )));
  }

  openPageSearch() {
    FocusScope.of(context).unfocus();
    if (searchController.text.isNotEmpty) {
      Navigator.push(
          context,
          customPageTransition(SearchProductHome(
            textSearch: searchController.text,
          )));
    }
  }

  updateIndexBannerFooter(int index) {
    providerHome!.indexBannerFooter = index;
  }

  updateIndexBannerHeader(int index) {
    providerHome!.indexBannerHeader = index;
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    providerHome!.ltsBrands.clear();
    providerHome!.ltsBanners.clear();
    providerHome!.ltsBannersOffer.clear();
    providerSettings.ltsCategories.clear();
    providerHome!.ltsMostSelledProducts.clear();
    serviceGetCategories();
    getProductsMoreSelled();
    _refreshHome.refreshCompleted();
  }

  serviceGetCategories() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings =
            providerSettings.getCategoriesInterest("", 0, prefs.countryIdUser);
        await callSettings.then((list) {
          getBrands();
          getProductsMoreSelled();
        }, onError: (error) {
          // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  getBrands() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callHome = providerHome!.getBrands("0");
        await callHome.then((list) {
          getBanners();
        }, onError: (error) {
          getBanners();
          //utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  getBanners() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callHome = providerHome!.getBannersGeneral("0");
        await callHome.then((list) {
          getBannersOffer();
        }, onError: (error) {
          // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  getBannersOffer() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callHome = providerHome!.getBannersOffer("0");
        await callHome.then((list) {}, onError: (error) {
          //utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  getProductsMoreSelled() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callHome = providerHome!.getProductsMostSelled();
        await callHome.then((list) {}, onError: (error) {

        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  selectCountryUserNotLogin() async {
    bool state = await openSelectCountry(context);
    if (state) serviceGetCategories();
  }
}
