import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Offer.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Offers/OfferDetail.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Offers/Widgets.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/ShopCartPage.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Providers/ProviderHome.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import '../../DrawerMenu.dart';

class OffersDayPage extends StatefulWidget {
  @override
  _OffersDayPageState createState() => _OffersDayPageState();
}

class _OffersDayPageState extends State<OffersDayPage> {
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  final searchController = TextEditingController();
  RefreshController _refreshView = RefreshController(initialRefresh: false);
  late ProviderHome providerHome;
  late ProviderShopCart providerShopCart;
  late ProviderSettings providerSettings;
  late ProviderCheckOut providerCheckOut;
  int pageOffsetUnits = 0;
  int pageOffsetMix = 0;

  @override
  void initState() {
   /* providerHome = Provider.of<ProviderHome>(context, listen: false);
    providerProducts = Provider.of<ProviderProducts>(context, listen: false);

    providerProducts.ltsOfferUnits.clear();
    providerProducts.ltsOfferMix.clear();
    getOffersUnits(Constants.offersUnits, "", pageOffsetUnits);
    getOffersMix(Constants.offersMix, "", pageOffsetMix);*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  /*  providerProducts = Provider.of<ProviderProducts>(context);*/
    providerHome = Provider.of<ProviderHome>(context);
    providerShopCart = Provider.of<ProviderShopCart>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    providerCheckOut = Provider.of<ProviderCheckOut>(context);

    return Container(); /*Scaffold(
      backgroundColor: Colors.white,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuOffersTheDay,
      ),
      body: WillPopScope(
        onWillPop:(()=> utils.startCustomAlertMessage(context, Strings.sessionClose,
            "Assets/images/ic_sign_off.png", Strings.closeAppText, ()=>
                Navigator.pop(context,true), ()=>Navigator.pop(context,false)).then((value) => value!)),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                headerDoubleTapMenu(context, Strings.offersDay, "ic_car.png","ic_menu_w.png", AppColors.redDot, providerShopCart.totalProductsCart,  () =>keyMenuLeft.currentState!.openDrawer(), ()=>Navigator.push(context,
                    customPageTransition(ShopCartPage(),PageTransitionType.rightToLeftWithFade))),

                Visibility(
                  visible: true,
                  child: Container(
                    height: 100,
                      child: listBrands()),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshView,
                    enablePullDown: true,
                    enablePullUp: false,
                    footer: footerRefreshCustom(),
                    header: headerRefresh(),
                    onRefresh: _pullToRefresh,
                    child:providerSettings.hasConnection?providerProducts.ltsOfferMix.isEmpty&&providerProducts.ltsOfferUnits.isEmpty?
                    emptyView("ic_percentage.png", "", Strings.offersEmpty):SingleChildScrollView(
                      child: Column(
                        children: [
                          Visibility(
                            visible: providerProducts.ltsOfferUnits.isNotEmpty,
                            child: Column(
                              children: [
                                Container(
                                  height: 37,
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10, bottom: 10),
                                    child: Text(
                                      Strings.offersForUnits,
                                      style: TextStyle(
                                          fontFamily: Strings.fontBold,
                                          color: AppColors.blackLetter),
                                    ),
                                  ),
                                ),
                                Container(
                                    height: 335,
                                    width: double.infinity,
                                    child: listOffersUnits()),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: providerProducts.ltsOfferMix.isNotEmpty,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 37,
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10, bottom: 10),
                                    child: Text(
                                      Strings.offersForMix,
                                      style: TextStyle(
                                          fontFamily: Strings.fontBold,
                                          color: AppColors.blackLetter),
                                    ),
                                  ),
                                ),
                                Container(
                                    height: 335,
                                    width: double.infinity,
                                    child: listOffersMix())
                              ],
                            ),
                          ),
                        ],
                      ),
                    ):notConnectionInternet(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );*/
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[AppColors.redTour, AppColors.redOne],
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
                    height: 30,
                    width: 30,
                    child: Image(
                      image: AssetImage("Assets/images/ic_backward_arrow.png"),
                    ),
                  ),
                  onTap: () => keyMenuLeft.currentState!.openDrawer(),
                ),
                Text(
                  Strings.offersDay,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: Strings.fontBold),
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: boxSearchHome(searchController, null)),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: AppColors.graySearch.withOpacity(.3),
                      ),
                      onPressed: null)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

 /* Widget listOffersUnits() {
    return ListView.builder(
      itemCount: providerProducts.ltsOfferUnits.isEmpty ? 0 : providerProducts.ltsOfferUnits.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: itemOfferUnits(providerProducts.ltsOfferUnits[index],addOfferCart,openDetailOffer),
        );
      },
    );
  }

  Widget listBrands() {
    return Container();
    *//*return ListView.builder(
      itemCount: providerHome.ltsBrands.isEmpty ? 0 : providerHome.ltsBrands.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: (){
            providerHome.selectedBrand = providerHome.ltsBrands[index];
            getOffersByBrand(providerHome.ltsBrands[index].id.toString());
          },
            child: itemBrandOffer(providerHome.selectedBrand,providerHome.ltsBrands[index]));
      },
    );*//*
  }

  Widget listOffersMix() {
    return ListView.builder(
      itemCount: providerProducts.ltsOfferMix.isEmpty
          ? 0
          : providerProducts.ltsOfferMix.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: itemOfferUnits(providerProducts.ltsOfferMix[index],addOfferCart,openDetailOffer),
        );
      },
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    providerProducts.ltsOfferUnits.clear();
    providerProducts.ltsOfferMix.clear();
    pageOffsetUnits = 0;
    pageOffsetMix = 0;
    getOffersUnits(Constants.offersUnits, "", pageOffsetUnits);
    getOffersMix(Constants.offersMix, "", pageOffsetMix);
    _refreshView.refreshCompleted();
  }

  openDetailOffer(Offer offer){
    Navigator.push(context, customPageTransition(
        OfferDetail(nameOffer: offer.name,idOffer: offer.id.toString(),),PageTransitionType.rightToLeftWithFade));
  }

  getOffersUnits(String typeOffer, String brandId, int offset) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts = providerProducts.getOfferByType(typeOffer, brandId, offset);
        await callProducts.then((list) {
          providerProducts.ltsOfferUnits = list;
        }, onError: (error) {
        //  utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  getOffersMix(String typeOffer, String brandId, int offset) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts =
            providerProducts.getOfferByType(typeOffer, brandId, offset);
        await callProducts.then((list) {
          providerProducts.ltsOfferMix = list;
        }, onError: (error) {
         // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  addOfferCart(String idOffer) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.addOfferCart(idOffer, "1",providerCheckOut.paymentSelected?.id ?? 2);
        await callCart.then((msg) {
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  getOffersByBrand(String brandId){
    providerProducts.ltsOfferUnits.clear();
    providerProducts.ltsOfferMix.clear();
    getOffersUnits(Constants.offersUnits, brandId, pageOffsetUnits);
    getOffersMix(Constants.offersMix, brandId, pageOffsetMix);
  }*/
}
