import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/GiftCard.dart';
import 'package:wawamko/src/Providers/ProviderHome.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/GiftCards/FilterGiftCartPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/ShopCartPage.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../../DrawerMenu.dart';

class GiftCartPage extends StatefulWidget {
  @override
  _GiftCartPageState createState() => _GiftCartPageState();
}

class _GiftCartPageState extends State<GiftCartPage> {
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  RefreshController _refreshGiftCard = RefreshController(initialRefresh: false);
  late ProviderShopCart providerShopCart;
  late ProviderSettings providerSettings;
  late ProviderHome providerHome;
  int pageOffset = 0;

  @override
  void initState() {
    providerShopCart = Provider.of<ProviderShopCart>(context, listen: false);
    getLtsGiftCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerShopCart = Provider.of<ProviderShopCart>(context);
    providerHome = Provider.of<ProviderHome>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: CustomColorsAPP.redTour,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuGiftCard,
      ),
      body: WillPopScope(
        onWillPop:(()=> utils.startCustomAlertMessage(context, Strings.sessionClose,
            "Assets/images/ic_sign_off.png", Strings.closeAppText, ()=>
                Navigator.pop(context,true), ()=>Navigator.pop(context,false)).then((value) => value!)),
        child: SafeArea(
          child: Container(
            color: CustomColorsAPP.whiteBackGround,
            child: Stack(
              children: [
                Column(
                  children: [
                    headerDoubleTapMenu(context, Strings.giftCards, "ic_car.png", "ic_menu_w.png",
                        CustomColorsAPP.redDot, providerShopCart.totalProductsCart,() => keyMenuLeft.currentState!.openDrawer(),
                            ()=>Navigator.push(context, customPageTransition(ShopCartPage(),PageTransitionType.rightToLeftWithFade))),
                    const SizedBox(height: 10),
                    Text(
                      Strings.buyGiftCard,
                      style: TextStyle(
                        fontFamily: Strings.fontBold,
                        fontSize: 17,
                        color: CustomColorsAPP.blackLetter,
                      ),
                    ),
                    Text(
                      Strings.textGiftCard,
                      style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        color: CustomColorsAPP.blackLetter,
                      ),
                    ),
                    SizedBox(height: 13,),
                    InkWell(
                      onTap: ()=>updateDataFilter(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomColorsAPP.blueSplash,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5)
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                Strings.filter,
                                style: TextStyle(
                                  fontFamily: Strings.fontRegular,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8,),
                              Text(
                                "0",
                                style: TextStyle(
                                  fontFamily: Strings.fontRegular,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: CustomColorsAPP.whiteBackGround,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                        child: SmartRefresher(
                            controller: _refreshGiftCard,
                            enablePullDown: true,
                            enablePullUp: true,
                            onLoading: _onLoadingToRefresh,
                            footer: footerRefreshCustom(),
                            header: headerRefresh(),
                            onRefresh: _pullToRefresh,
                            child:providerSettings.hasConnection? providerShopCart.ltsGiftCard.isEmpty
                                ? emptyData(
                                    "ic_highlights_empty.png",
                                    Strings.sorryHighlights,
                                    Strings.emptyGiftCards)
                                : SingleChildScrollView(child: gridViewItems()):notConnectionInternet()),
                      ),
                    ),
                  ],
                ),
                Visibility(
                    visible: providerShopCart.isLoadingCart,
                    child: LoadingProgress()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget gridViewItems() {
    return Container(
      child: GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          childAspectRatio: .8,
          crossAxisSpacing: 15,
        ),
        padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
        itemCount: providerShopCart.ltsGiftCard.isEmpty
            ? 0
            : providerShopCart.ltsGiftCard.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return itemGiftCard(providerShopCart.ltsGiftCard[index]);
        },
      ),
    );
  }

  Widget itemGiftCard(GiftCard gift) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: CustomColorsAPP.gray4,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12)),
            ),
            width: double.infinity,
            height: 100,
            child: Container(
              margin: EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Image.asset("Assets/images/ic_giftcard.png")),
                    Center(
                      child: Text(
                        formatMoney(gift.value ?? '0'),
                        style: TextStyle(
                          fontFamily: Strings.fontBold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gift.name ?? '',
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 12,
                    color: CustomColorsAPP.gray7,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  formatMoney(gift.value ?? '0'),
                  style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 13,
                    color: CustomColorsAPP.orange,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: ()=>addGiftCard(gift.id.toString()),
                    child: Container(
                        decoration: BoxDecoration(
                            color: CustomColorsAPP.blue,
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 20,
                          ),
                        )),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshGiftCard.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerShopCart.ltsGiftCard.clear();
    getLtsGiftCarts();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getLtsGiftCarts();
    _refreshGiftCard.loadComplete();
  }

  updateDataFilter(){
    Navigator.push(context, customPageTransition(FilterGiftCartPage(),PageTransitionType.fade)).then((value) =>{
      if(value as bool){
        providerShopCart.ltsGiftCard.clear(),
        getLtsGiftCarts()
      }
    });
  }

  getLtsGiftCarts() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.getGiftCards(pageOffset, providerSettings.selectCategory==null?null:
            providerSettings.selectCategory!.id.toString(), null);
        await callCart.then((msg) {}, onError: (error) {
          providerShopCart.isLoadingCart = false;
          //utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  addGiftCard(String idGift) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.addGiftCard(idGift, "1");
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
}
