import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Providers/ProviderUser.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Widgets.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../DrawerMenu.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  RefreshController _refreshFavorites =
      RefreshController(initialRefresh: false);
  ProviderUser providerUser;
  int pageOffset = 0;

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
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuFavorites,
      ),
      body: SafeArea(
        child: Container(
          color: CustomColors.grayBackground,
          child: Column(
            children: [
              titleBar(Strings.favorites, "ic_menu_w.png",
                  () => keyMenuLeft.currentState.openDrawer()),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshFavorites,
                  enablePullDown: true,
                  enablePullUp: true,
                  onLoading: _onLoadingToRefresh,
                  footer: footerRefreshCustom(),
                  header: headerRefresh(),
                  onRefresh: _pullToRefresh,
                  child: providerUser.ltsProductsFavorite.isEmpty
                      ? emptyData("ic_favorite_empty.png",
                          Strings.sorryFavorites, Strings.emptyFavorites)
                      : SingleChildScrollView(
                          child: GridView.builder(
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
                                  openDetailProduct,
                                  removeFavoriteProduct);
                            },
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  openDetailProduct() {}

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
        await callUser.then((list) {}, onError: (error) {
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
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
