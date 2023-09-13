import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
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
  final String? idCategory, idSubcategory, idBrand;

  const ProductCategoryPage(
      { this.idCategory,
       this.idSubcategory,
      this.idBrand});

  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  final searchController = TextEditingController();
  late ProviderProducts providerProducts;
  late ProviderUser providerUser;
  late ProviderShopCart providerShopCart;
  late ProviderSettings providerSettings;
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
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color:  Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(

                    decoration: BoxDecoration(

                        color:CustomColors.redDot,
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 37),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
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
                                Strings.products,
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontFamily: Strings.fontBold),
                              ),
                              GestureDetector (
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
                          boxSearchHome(
                              searchController, callSearchProducts),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SmartRefresher(
                            controller: _refreshProducts,
                            enablePullDown: true,
                            enablePullUp: true,
                            onLoading: _onLoadingToRefresh,
                            footer: footerRefreshCustom(),
                            header: headerRefresh(),
                            onRefresh: _pullToRefresh,
                            child:  providerSettings.hasConnection?providerProducts.ltsProductsByCategory.isEmpty
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
                                itemCount: providerProducts.ltsProductsByCategory.isEmpty ? 0 : providerProducts.ltsProductsByCategory.length,
                                shrinkWrap: true,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      columnCount: 2,
                                      child: ScaleAnimation(
                                          child: FadeInAnimation(child: itemProductCategory(providerProducts.ltsProductsByCategory[index], openDetailProduct, callIsFavorite))));
                                },
                              ),
                            ):notConnectionInternet(),
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

    String? color = product.references[0].color;

    print("producto y color $color ${product.references[0].images?.length}");
    if(product.references[0].images?.length != 0)
      {
        if (color != null  && color.startsWith('#') && color.length >= 6) {
          providerProducts.imageReferenceProductSelected = product.references[0].images?[0].url ?? "";
          Navigator.push(context, customPageTransition(DetailProductPage(product: product)));
        }
      }

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
            widget.idBrand==null ? null : widget.idBrand,
           null,
            widget.idCategory==null ? null : widget.idCategory,
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
      reference.isFavorite = false;
      removeFavoriteProduct(reference);
    } else {
      reference.isFavorite = true;
      saveFavoriteProduct(reference);
    }
  }

  saveFavoriteProduct(Reference reference) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerUser.saveAsFavorite(reference.id.toString());
        await callUser.then((msg) {
          utils.showSnackBarGood(context, msg.toString());
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
