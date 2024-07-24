import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
;
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/Providers/ProviderUser.dart';
import 'package:wawamko/src/UI/Home/Categories/Widgets.dart';
import 'package:wawamko/src/features/feature_department_categories/domain/domain.dart';
import 'package:wawamko/src/features/feature_filter_right/presentation/views/menu_filter_view.dart';
import 'package:wawamko/src/UI/Home/Products/DetailProductPage.dart';
import 'package:wawamko/src/Utils/Strings.dart';

import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/features/feature_products/presentation/presentation.dart';

import '../../domain/domain.dart';

class ProductsByCategoryPage extends StatefulWidget {
  final SubCategory subCategory;

  const ProductsByCategoryPage({super.key, required this.subCategory});

  @override
  _ProductsByCategoryPageState createState() => _ProductsByCategoryPageState();
}

class _ProductsByCategoryPageState extends State<ProductsByCategoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKeyMenu = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  late ProductsProvider productsProvider;
  late ProviderUser providerUser;
  late ProviderShopCart providerShopCart;
  late ProviderSettings providerSettings;
  int pageOffset = 0;
  RefreshController _refreshProducts = RefreshController(initialRefresh: false);

  @override
  void initState() {
    productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    productsProvider = Provider.of<ProductsProvider>(context);
    providerUser = Provider.of<ProviderUser>(context);
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
                  headerWithSearchFilter(Strings.products, searchController, providerShopCart.totalProductsCart, ()=>Navigator.pop(context), (){}, callSearchProducts,
                      ()=>_scaffoldKeyMenu.currentState!.openEndDrawer()),
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
                                  child: emptyData("ic_empty_notification.png", Strings.sorry, Strings.emptyCategories)),
                            ) : AnimationLimiter(
                              child: GridView.builder(
                                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                      childAspectRatio: 179 / 318,
                                      crossAxisSpacing: 15,
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                                itemCount: providerProducts.ltsProductsByCategory.isEmpty ? 0 : providerProducts.ltsProductsByCategory.length,
                                shrinkWrap: true,
                                itemBuilder: (_, int index) {
                                  return AnimationConfiguration.staggeredGrid(
                                      position: index,
                                      duration: const Duration(milliseconds: 375),
                                      columnCount: 2,
                                      child: ScaleAnimation(
                                          child: FadeInAnimation(
                                              child: Container(
                                                  width: 179.0,
                                                  height: 318.0,
                                                  child: itemProductCategory(providerProducts.ltsProductsByCategory[index], openDetailProduct, callIsFavorite)))));
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
    Navigator.push(context, customPageTransition(DetailProductPage(product: product), PageTransitionType.rightToLeftWithFade));

  }


  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshProducts.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerProducts.ltsProductsByCategory.clear();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;

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
