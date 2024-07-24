import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Providers/ProviderHome.dart';

import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/features/feature_products/presentation/views/products_by_sub_category_page.dart';
import 'package:wawamko/src/UI/Home/Products/DetailProductPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Offers/OfferDetail.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../../../../features/feature_views_shared/domain/domain.dart';
import '../../DrawerMenu.dart';
import 'Widgets.dart';

class HighlightsPage extends StatefulWidget {
  @override
  _HighlightsPageState createState() => _HighlightsPageState();
}

class _HighlightsPageState extends State<HighlightsPage> with SingleTickerProviderStateMixin{
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  late ProviderSettings providerSettings;
  late ProviderProducts providerProducts;
  late ProviderHome providerHome;
  RefreshController _refreshHighlights = RefreshController(initialRefresh: false);
  int pageOffset = 0;

  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context,listen: false);
    providerSettings.ltsBannersHighlights.clear();
    getBannersHighlights();
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    providerProducts = Provider.of<ProviderProducts>(context);
    providerHome = Provider.of<ProviderHome>(context);
    return Scaffold(
      backgroundColor: AppColors.redTour,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuHighlights,
      ),
      body: WillPopScope(
        onWillPop:(()=> utils.startCustomAlertMessage(context, Strings.sessionClose,
            "Assets/images/ic_sign_off.png", Strings.closeAppText, ()=>
                Navigator.pop(context,true), ()=>Navigator.pop(context,false)).then((value) => value!)),
        child: SafeArea(
          child: Container(
            color: AppColors.whiteBackGround,
            child: Column(
                children: [
                  //titleBar(Strings.highlights, "ic_menu_w.png", () => keyMenuLeft.currentState!.openDrawer()),

                  headerDoubleTapMenu(context, Strings.highlights, "", "ic_menu_w.png", AppColors.redDot, "0", () => keyMenuLeft.currentState!.openDrawer(), (){}),
                  SizedBox(height: 20,),
                  Expanded(child: SmartRefresher(
                      controller: _refreshHighlights,
                      enablePullDown: true,
                      enablePullUp: true,
                      onLoading: _onLoadingToRefresh,
                      footer: footerRefreshCustom(),
                      header: headerRefresh(),
                      onRefresh: _pullToRefresh,
                      child: providerSettings.hasConnection? providerSettings.ltsBannersHighlights.isEmpty
                          ? emptyData("ic_highlights_empty.png",
                          Strings.sorryHighlights, Strings.emptyHighlights)
                          : listHighlights():notConnectionInternet()))
                ],
            ),
          ),
        ),
      ),
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshHighlights.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerSettings.ltsBannersHighlights.clear();
    getBannersHighlights();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getBannersHighlights();
    _refreshHighlights.loadComplete();
  }

  Widget listHighlights(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: providerSettings.ltsBannersHighlights.isEmpty ? 0 : providerSettings.ltsBannersHighlights.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return InkWell(
          onTap: ()=>openPageByTypeHighlights(providerSettings.ltsBannersHighlights[index]),
            child: itemHighlights( providerSettings.ltsBannersHighlights[index]));
      },
    );
  }

  getBannersHighlights() async {
   /*TODO for refactor code
   utils.checkInternet().then((value) async {
      if (value) {
        Future callHome = providerSettings.getBannersHighlights(pageOffset.toString());
        await callHome.then((list) {

        }, onError: (error) {
         // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });*/
  }

  getProduct(String idProduct) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts = providerProducts.getProduct(idProduct);
        await callProducts.then((product) {
          providerProducts
              .imageReferenceProductSelected = product.references[0]?.images?[0].url ?? "";
          //providerProducts.referenceProductSelected = referenceOffer;//product.references.firstWhere((reference) => reference.id == referenceOffer.id, orElse: () => referenceOffer.);
          providerProducts.limitedQuantityError = false;
          Navigator.push(context, customPageTransition(DetailProductPage(product: product),PageTransitionType.rightToLeftWithFade));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  openPageByTypeHighlights(Banners bannerHighlight){
/*    if(bannerHighlight.offerHighlights!.offerType=="percent"&&bannerHighlight.offerHighlights!.reference!=null){
      getProduct(bannerHighlight.offerHighlights!.reference!.brandAndProduct!.id.toString());
    }else if(bannerHighlight.offerHighlights!.offerType=="units"||bannerHighlight.offerHighlights!.offerType=="mixed"){
      openDetailOffer(bannerHighlight);
    }else {
      openProductsBySubCategory(bannerHighlight);
    }*/
  }

  openDetailOffer(Banners bannerHighlight){
   /* providerProducts.limitedQuantityError = false;
    Navigator.push(context, customPageTransition(
        OfferDetail(nameOffer: bannerHighlight.offerHighlights!.name,idOffer: bannerHighlight.offerHighlights!.id.toString(),),
        PageTransitionType.rightToLeftWithFade));*/
  }

  openProductsBySubCategory(Banners bannerHighlight){
    /*Navigator.push(context, customPageTransition(ProductCategoryPage(idCategory: "",
      idSubcategory: bannerHighlight.offerHighlights?.subcategory?.id.toString(),
      idBrand: "",), PageTransitionType.rightToLeftWithFade));*/
  }
}