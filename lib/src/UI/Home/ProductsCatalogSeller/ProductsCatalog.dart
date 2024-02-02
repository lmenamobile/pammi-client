import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Models/SubCategory.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/Categories/ProductCategoryPage.dart';
import 'package:wawamko/src/UI/Home/Categories/Widgets.dart';
import 'package:wawamko/src/UI/Home/ProductsCatalogSeller/Widgets.dart';
import 'package:wawamko/src/UI/Home/ProductsCatalogSeller/filter_brands.dart';
import 'package:wawamko/src/UI/Home/SearchProduct/Widgets.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class ProductsCatalog extends StatefulWidget{
  final String  idSeller;

  const ProductsCatalog({required this.idSeller});
  @override
  _ProductsCatalogState createState() => _ProductsCatalogState();
}

class _ProductsCatalogState extends State<ProductsCatalog> {
  late ProviderSettings providerSettings;
  late ProviderProducts providerProducts;
  SharePreference prefs = SharePreference();
  RefreshController _refreshSubCategories = RefreshController(initialRefresh: false);

  int pageOffset = 0;
  final searchController = TextEditingController();

  @override
  void initState() {
    providerProducts = Provider.of<ProviderProducts>(context,listen: false);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
    getProducts(pageOffset);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerProducts = Provider.of<ProviderProducts>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                 // titleBar(Strings.catalog,"ic_blue_arrow.png", ()=>Navigator.pop(context)),
                  header(context, Strings.catalog, CustomColors.redDot, ()=> Navigator.pop(context)),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        IconButton(onPressed: _selectFilterBrands, icon: Icon(
                          Icons.filter_alt_rounded,
                          size: 30,
                          color: CustomColors.blue6,
                        )),
                        const SizedBox(width: 20),
                        Expanded(child: boxSearch(searchController, _searchProducts)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                      child: SmartRefresher(
                          controller: _refreshSubCategories,
                          enablePullDown: true,
                          enablePullUp: true,
                          onLoading: _onLoadingToRefresh,
                          footer: footerRefreshCustom(),
                          header: headerRefresh(),
                          onRefresh: _pullToRefresh,
                          child: providerSettings.hasConnection?providerProducts.ltsProductsByCatalog.isEmpty
                              ? emptyData("ic_empty_notification.png",
                              Strings.sorry, Strings.emptyCatalog)
                              :SingleChildScrollView(
                                child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, childAspectRatio: .77, crossAxisSpacing: 15,
                            ),
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            itemCount: providerProducts.ltsProductsByCatalog.length,
                            shrinkWrap: true,
                            itemBuilder: (_, int index) {
                                return AnimationConfiguration.staggeredGrid(position: index, duration:
                                    const Duration(milliseconds: 375), columnCount: 2,
                                    child: ScaleAnimation(
                                        child: FadeInAnimation(child: itemProductCatalog(providerProducts.ltsProductsByCatalog[index]))));
                            },
                          ),
                              ):notConnectionInternet()))
                ],
              ),
              Visibility(
                  visible: providerSettings.isLoading, child: LoadingProgress()),
            ],
          ),
        ),
      ),
    );
  }

  _searchProducts(String value){
      providerProducts.ltsProductsByCatalog = [];
      getProducts(0);
  }

  _selectFilterBrands(){
    Navigator.push(context, customPageTransitionLeftToRight(FilterBrandsCatalog(actionFilter: (){
      providerProducts.ltsProductsByCatalog = [];
     getProducts(0);
    },)));
  }


  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshSubCategories.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerProducts.brandSelectedCatalog = null;
    providerSettings.ltsCategories.clear();
    getProducts(pageOffset);
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getProducts(pageOffset);
    _refreshSubCategories.loadComplete();
  }

  getProducts(int page) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts = providerProducts.getProductsByCatalogSeller(widget.idSeller, page,searchController.text);
        await callProducts.then((list) {}, onError: (error) {
          providerProducts.isLoadingProducts = false;
        });
      }else{
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }




}