import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/Providers/ProviderUser.dart';
import 'package:wawamko/src/UI/Home/Categories/Widgets.dart';
import 'package:wawamko/src/UI/Home/Products/DetailProductPage.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/ShopCartPage.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class ProductCategoryPage extends StatefulWidget {
  final String? idCategory, idSubcategory, idBrandProvider;

  const ProductCategoryPage(
      {required this.idCategory,
      required this.idSubcategory,
      this.idBrandProvider});

  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  final searchController = TextEditingController();
  late ProviderProducts providerProducts;
  late ProviderUser providerUser;
  late ProviderShopCart providerShopCart;
  int pageOffset = 0;
  RefreshController _refreshProducts = RefreshController(initialRefresh: false);

  @override
  void initState() {
    providerProducts = Provider.of<ProviderProducts>(context, listen: false);
    providerProducts.ltsProductsByCategory.clear();
    getProducts("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerProducts = Provider.of<ProviderProducts>(context);
    providerUser = Provider.of<ProviderUser>(context);
    providerShopCart = Provider.of<ProviderShopCart>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.grayBackground,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          CustomColors.redTour,
                          CustomColors.redOne
                        ],
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
                                    image: AssetImage(
                                        "Assets/images/ic_backward_arrow.png"),
                                  ),
                                ),
                                onTap: () => Navigator.pop(context),
                              ),
                              Text(
                                Strings.categories,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontFamily: Strings.fontBold),
                              ),
                              GestureDetector(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 30,
                                      child: Image(
                                        image: AssetImage(
                                            "Assets/images/ic_car.png"),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Visibility(
                                        visible: providerShopCart
                                                    .totalProductsCart !=
                                                "0"
                                            ? true
                                            : false,
                                        child: CircleAvatar(
                                          radius: 6,
                                          backgroundColor: Colors.white,
                                          child: Text(
                                            providerShopCart.totalProductsCart,
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: CustomColors.redTour),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () => Navigator.push(context,
                                    customPageTransition(ShopCartPage())),
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
                                Expanded(
                                    child: boxSearchHome(
                                        searchController, callSearchProducts)),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.menu,
                                      color: CustomColors.graySearch
                                          .withOpacity(.3),
                                    ),
                                    onPressed: null)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child:SmartRefresher(
                              controller: _refreshProducts,
                              enablePullDown: true,
                              enablePullUp: true,
                              onLoading: _onLoadingToRefresh,
                              footer: footerRefreshCustom(),
                              header: headerRefresh(),
                              onRefresh: _pullToRefresh,
                              child:  providerProducts.ltsProductsByCategory.isEmpty
                                  ? Center(
                                child: SingleChildScrollView(
                                    child: emptyData("ic_empty_notification.png",
                                        Strings.sorry, Strings.emptyCategories)),
                              )
                                  : AnimationLimiter(
                                child: GridView.builder(
                                  gridDelegate:
                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: .77,
                                    crossAxisSpacing: 15,
                                  ),
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 10, left: 10, right: 10),
                                  itemCount: providerProducts
                                          .ltsProductsByCategory.isEmpty
                                      ? 0
                                      : providerProducts
                                          .ltsProductsByCategory.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AnimationConfiguration.staggeredGrid(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 375),
                                        columnCount: 2,
                                        child: ScaleAnimation(
                                            child: FadeInAnimation(
                                                child: itemProductCategory(
                                                    providerProducts
                                                            .ltsProductsByCategory[
                                                        index],
                                                    openDetailProduct,
                                                    callIsFavorite))));
                                  },
                                ),
                              ),
                            ),
                    ),
                  )
                ],
              ),
              Visibility(
                  visible: providerProducts.isLoadingProducts,
                  child: LoadingProgress()),
            ],
          ),
        ),
      ),
    );
  }

  openDetailProduct(Product product) {
    Navigator.push(context, customPageTransition(DetailProductPage(product: product)));
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshProducts.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerProducts.ltsProductsByCategory.clear();
    getProducts("");
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getProducts(searchController.text);
    _refreshProducts.loadComplete();
  }

  getProducts(String searchProduct) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts = providerProducts.getProductsByCategory(
            searchProduct,
            pageOffset,
            widget.idBrandProvider == null ? null : widget.idBrandProvider,
            widget.idCategory!.isEmpty ? null : widget.idCategory,
            widget.idSubcategory,
            null,
            null);
        await callProducts.then((list) {}, onError: (error) {
          providerProducts.isLoadingProducts = false;
         // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  callIsFavorite(Reference reference) {
    if (reference.isFavorite!) {
      removeFavoriteProduct(reference);
    } else {
      saveFavoriteProduct(reference);
    }
  }

  saveFavoriteProduct(Reference reference) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerUser.saveAsFavorite(reference.id.toString());
        await callUser.then((msg) {
          utils.showSnackBarGood(context, msg.toString());
          providerProducts.ltsProductsByCategory.clear();
          getProducts("");
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  removeFavoriteProduct(Reference reference) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerUser.deleteFavorite(reference.id.toString());
        await callUser.then((msg) {
          utils.showSnackBarGood(context, msg.toString());
          providerProducts.ltsProductsByCategory.clear();
          getProducts("");
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  callSearchProducts(String value) {
    FocusScope.of(context).unfocus();
    providerProducts.ltsProductsByCategory.clear();
    if (value.isNotEmpty) {
      getProducts(value);
    } else {
      getProducts("");
    }
  }
}
