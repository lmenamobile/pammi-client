import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderUser.dart';
import 'package:wawamko/src/UI/Home/Categories/Widgets.dart';
import 'package:wawamko/src/UI/Home/Products/DetailProductPage.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Widgets.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../DrawerMenu.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  RefreshController _refreshFavorites = RefreshController(initialRefresh: false);
  late ProviderUser providerUser;
  late ProviderProducts providerProducts;
  late ProviderSettings providerSettings;
  int pageOffset = 0;
  int pageOffsetProductsRelations = 0;
  int randomReference = 0;
  @override
  void initState() {
    providerUser = Provider.of<ProviderUser>(context, listen: false);
    providerUser.ltsProductsFavorite.clear();
    getProductsFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerUser = Provider.of<ProviderUser>(context);
    providerProducts = Provider.of<ProviderProducts>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuFavorites,
      ),
      body: WillPopScope(
        onWillPop:(()=> utils.startCustomAlertMessage(context, Strings.sessionClose,
            "Assets/images/ic_sign_off.png", Strings.closeAppText, ()=>
                Navigator.pop(context,true), ()=>Navigator.pop(context,false)).then((value) => value!)),
        child: SafeArea(
          child: Container(
            color: CustomColors.whiteBackGround,
            child: Stack(
              children: [
                Column(
                  children: [
                    titleBar(Strings.favorites, "ic_menu_w.png",
                        () => keyMenuLeft.currentState!.openDrawer()),
                    Expanded(
                      child: SmartRefresher(
                        controller: _refreshFavorites,
                        enablePullDown: true,
                        enablePullUp: true,
                        onLoading: _onLoadingToRefresh,
                        footer: footerRefreshCustom(),
                        header: headerRefresh(),
                        onRefresh: _pullToRefresh,
                        child: providerSettings.hasConnection?providerUser.ltsProductsFavorite.isEmpty
                            ? emptyData("ic_favorite_empty.png",
                                Strings.sorryFavorites, Strings.emptyFavorites)
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    GridView.builder(
                                      gridDelegate:
                                          new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: .77,
                                        crossAxisSpacing: 15,
                                      ),
                                      padding: EdgeInsets.only(
                                          top: 20, bottom: 10, left: 10, right: 10),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: providerUser.ltsProductsFavorite.isEmpty
                                          ? 0
                                          : providerUser.ltsProductsFavorite.length,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        return itemProductFavorite(
                                            providerUser.ltsProductsFavorite[index],
                                            getProduct,
                                            removeFavoriteProduct);
                                      },
                                    ),
                                    customDivider(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                          child: Text(
                                            Strings.productsRelations,
                                            style:TextStyle(
                                              fontFamily: Strings.fontBold,
                                              color: CustomColors.blackLetter
                                            ) ,
                                          ),
                                        ),
                                        Container(
                                            height: 217,
                                            child: listItemsProductsRelations()),
                                      ],
                                    )
                                  ],
                                ),
                              ):notConnectionInternet(),
                      ),
                    )
                  ],
                ),
                Visibility(
                    visible: providerProducts.isLoadingProducts, child: LoadingProgress()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listItemsProductsRelations() {
    return ListView.builder(
      itemCount: providerProducts.ltsProductsRelationsByReference.isEmpty?0:providerProducts.ltsProductsRelationsByReference.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: itemProductRelations(providerProducts.ltsProductsRelationsByReference[index],openDetailProduct)
        );
      },
    );
  }

  openDetailProduct(Product product) {
    providerProducts
        ?.imageReferenceProductSelected = product.references[0]?.images?[0].url ?? "";
    Navigator.push(context, customPageTransition(DetailProductPage(product: product)));
  }

  callIsFavorite(Reference reference){
    if(reference.isFavorite!){
      removeFavoriteProduct(reference.id.toString());
    }else{
      saveFavoriteProduct(reference);
    }
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshFavorites.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerUser.ltsProductsFavorite.clear();
    getProductsFavorites();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getProductsFavorites();
    _refreshFavorites.loadComplete();
  }

  getProductsFavorites() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerUser.getProductsFavorites(pageOffset);
        await callUser.then((list) {
          randomReference = providerProducts.getRandomPosition(providerUser.ltsProductsFavorite.length);
          providerProducts.ltsProductsRelationsByReference.clear();
          getProductsRelations();
        }, onError: (error) {
         // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  getProductsRelations() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerProducts.getProductsRelationByReference(pageOffsetProductsRelations,providerUser.ltsProductsFavorite[randomReference].reference!.id.toString() );
        await callUser.then((list) {

        }, onError: (error) {
         // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  saveFavoriteProduct(Reference reference) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerUser.saveAsFavorite(reference.id.toString());
        await callUser.then((msg) {
          utils.showSnackBarGood(context, msg.toString());
          providerUser.ltsProductsFavorite.clear();
          getProductsFavorites();

        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  removeFavoriteProduct(String idReference) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerUser.deleteFavorite(idReference);
        await callUser.then((msg) {
          utils.showSnackBarGood(context, msg.toString());
          providerUser.ltsProductsFavorite.clear();
          getProductsFavorites();
        }, onError: (error) {
          providerUser.ltsProductsFavorite.clear();
          getProductsFavorites();
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
  getProduct(String idProduct) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts = providerProducts.getProduct(idProduct);
        await callProducts.then((product) {
          providerProducts
              ?.imageReferenceProductSelected = product.references[0]?.images?[0].url ?? "";
          Navigator.push(context, customPageTransition(DetailProductPage(product: product)));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
