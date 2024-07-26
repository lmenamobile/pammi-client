import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';

import 'package:wawamko/src/features/feature_filter_right/presentation/views/menu_filter_view.dart';
import 'package:wawamko/src/UI/Home/Products/DetailProductPage.dart';
import 'package:wawamko/src/Utils/Strings.dart';

import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/features/feature_products/presentation/presentation.dart';
import 'package:wawamko/src/features/feature_products/presentation/widgets/header_view_products.dart';

import '../../domain/domain.dart';
import '../widgets/card_product.dart';

class ProductsPage extends StatefulWidget {
  final String title;
  const ProductsPage({super.key, required this.title});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKeyMenu = GlobalKey<ScaffoldState>();
  RefreshController _refreshProducts = RefreshController(initialRefresh: false);
  final searchController = TextEditingController();
  late ProductsProvider productsProvider;

  late ProviderShopCart providerShopCart;
  late ProviderSettings providerSettings;


  @override
  void initState() {
    productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productsProvider.loadProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    productsProvider = Provider.of<ProductsProvider>(context);

    providerShopCart = Provider.of<ProviderShopCart>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      key: _scaffoldKeyMenu,
      backgroundColor: Colors.white,
      endDrawer: MenuFilterView(),
      body: SafeArea(
        child: Container(
          color:  Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  HeaderViewProducts(
                    title: widget.title,
                    searchController: searchController,
                    onTapShopCart: () {

                    },
                    onTapSearch: () {
                      //callSearchProducts(searchController.text);
                    },
                    onTapFilter: ()=>_scaffoldKeyMenu.currentState!.openEndDrawer(),
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
                      child: providerSettings.hasConnection
                          ? (productsProvider.products.isEmpty ? Center(
                        child: emptyData("ic_empty_notification.png", Strings.sorry, Strings.emptyCategories))
                          : AnimationLimiter(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            childAspectRatio: 179 / 318,
                            crossAxisSpacing: 15,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                          itemCount: productsProvider.products.length,
                          shrinkWrap: true,
                          itemBuilder: (_, int index) {
                            Product product = productsProvider.products[index];
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: CardProduct(
                                    product: product,
                                    onTapProduct: openDetailProduct,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )) : notConnectionInternet())),
                ],
              ),
              Visibility(
                  visible: productsProvider.isLoading,
                  child: LoadingProgress()),
            ],
          ),
        ),
      ),
    );
  }

  openDetailProduct(Product product) {
    print("openDetailProduct ${product.nameProduct}");
    Navigator.push(context, customPageTransition(DetailProductPage(product: product), PageTransitionType.rightToLeftWithFade));
  }


  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    productsProvider.refreshProducts();
    _refreshProducts.refreshCompleted();
  }



  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    productsProvider.loadMoreProducts();
    _refreshProducts.loadComplete();
  }


  /*allIsFavorite(Reference reference) {
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

  }*/
}
