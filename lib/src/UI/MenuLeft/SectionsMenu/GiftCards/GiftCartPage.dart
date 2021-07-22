import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/GiftCard.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/UI/Home/Products/Widgets.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../../DrawerMenu.dart';

class GiftCartPage extends StatefulWidget {
  @override
  _GiftCartPageState createState() => _GiftCartPageState();
}

class _GiftCartPageState extends State<GiftCartPage> {
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  RefreshController _refreshGiftCard = RefreshController(initialRefresh: false);
  ProviderShopCart providerShopCart;
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
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuGiftCard,
      ),
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: Stack(
            children: [
              titleBarWithDoubleAction(
                  Strings.giftCards,
                  "ic_menu_w.png",
                  "ic_car.png",
                  () => keyMenuLeft.currentState.openDrawer(),
                  null),
              Column(
                children: [
                  SizedBox(
                    height: 55,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: CustomColors.whiteBackGround,
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
                          child: providerShopCart.ltsGiftCard.isEmpty
                              ? emptyData(
                                  "ic_highlights_empty.png",
                                  Strings.sorryHighlights,
                                  Strings.emptyGiftCards)
                              : SingleChildScrollView(child: gridViewItems())),
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
    return InkWell(
      onTap: () => null,
      child: Container(
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
                color: CustomColors.gray4,
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
                          formatMoney(gift?.value ?? '0'),
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
                    gift?.name ?? '',
                    style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 12,
                      color: CustomColors.gray7,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    formatMoney(gift?.value ?? '0'),
                    style: TextStyle(
                      fontFamily: Strings.fontBold,
                      fontSize: 13,
                      color: CustomColors.orange,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        decoration: BoxDecoration(
                            color: CustomColors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listGiftCards() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 0,
        itemBuilder: (BuildContext context, int index) {
          return Container();
        },
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

  getLtsGiftCarts() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.getGiftCards(pageOffset, null, null);
        await callCart.then((msg) {}, onError: (error) {
          providerShopCart.isLoadingCart = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
