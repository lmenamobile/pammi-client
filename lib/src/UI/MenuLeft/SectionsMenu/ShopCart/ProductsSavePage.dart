import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import 'Widgets.dart';

class ProductsSavePage extends StatefulWidget {
  @override
  _ProductsSavePageState createState() => _ProductsSavePageState();
}

class _ProductsSavePageState extends State<ProductsSavePage> {
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  ProviderShopCart providerShopCart;
  RefreshController _refreshProductsSave = RefreshController(initialRefresh: false);
  int pageOffset = 0;

  @override
  void initState() {
    providerShopCart = Provider.of<ProviderShopCart>(context,listen: false);
    getLtsProductsSave();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    providerShopCart = Provider.of<ProviderShopCart>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.grayBackground,
          child: Column(
            children: [
              titleBar(Strings.productsSave, "ic_blue_arrow.png", () => Navigator.pop(context)),
              SizedBox(height: 20,),
              Expanded(child: SmartRefresher(
                  controller: _refreshProductsSave,
                  enablePullDown: true,
                  enablePullUp: true,
                  onLoading: _onLoadingToRefresh,
                  footer: footerRefreshCustom(),
                  header: headerRefresh(),
                  onRefresh: _pullToRefresh,
                  child:  providerShopCart.ltsProductsSave.isEmpty
                      ? emptyData("ic_highlights_empty.png",
                      Strings.sorryHighlights, Strings.emptyProductsSave)
                      : listReferencesSave()))
            ],
          ),
        ),
      ),
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshProductsSave.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerShopCart.ltsProductsSave.clear();
    getLtsProductsSave();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getLtsProductsSave();
    _refreshProductsSave.loadComplete();
  }

  Widget listReferencesSave(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: providerShopCart.ltsProductsSave.isEmpty ? 0 : providerShopCart.ltsProductsSave.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return itemProductSave(providerShopCart.ltsProductsSave[index],addProductCart,deleteReference);
      },
    );
  }

  getLtsProductsSave() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.getLtsReferencesSave(pageOffset);
        await callCart.then((list) {

        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  addProductCart(int quantity,String idReference,String idProduct) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.updateQuantityProductCart(
            idReference,
            quantity.toString());
        await callCart.then((msg) {
          deleteReference(idProduct);
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  deleteReference(String idProduct) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.deleteReference(idProduct);
        await callCart.then((msg) {
          getLtsProductsSave();
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          providerShopCart.isLoadingCart = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

}