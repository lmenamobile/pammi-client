import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Banner.dart';

import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/Categories/ProductCategoryPage.dart';
import 'package:wawamko/src/UI/Home/Products/DetailProductPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Offers/OfferDetail.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

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
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuHighlights,
      ),
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: Column(
              children: [
                titleBar(Strings.highlights, "ic_menu_w.png", () => keyMenuLeft.currentState!.openDrawer()),
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
    });
  }

  getProduct(String idProduct) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts = providerProducts.getProduct(idProduct);
        await callProducts.then((product) {
          //providerProducts.referenceProductSelected = referenceOffer;//product.references.firstWhere((reference) => reference.id == referenceOffer.id, orElse: () => referenceOffer.);
          Navigator.push(context, customPageTransition(DetailProductPage(product: product)));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  openPageByTypeHighlights(Banners bannerHighlight){
    if(bannerHighlight.offerHighlights!.offerType=="percent"&&bannerHighlight.offerHighlights!.reference!=null){
      getProduct(bannerHighlight.offerHighlights!.reference!.brandAndProduct!.id.toString());
    }else if(bannerHighlight.offerHighlights!.offerType=="units"||bannerHighlight.offerHighlights!.offerType=="mixed"){
      openDetailOffer(bannerHighlight);
    }else {
      openProductsBySubCategory(bannerHighlight);
    }
  }

  openDetailOffer(Banners bannerHighlight){
    Navigator.push(context, customPageTransition(OfferDetail(nameOffer: bannerHighlight.offerHighlights!.name,idOffer: bannerHighlight.offerHighlights!.id.toString(),)));
  }

  openProductsBySubCategory(Banners bannerHighlight){
    Navigator.push(context, customPageTransition(ProductCategoryPage(idCategory: "",
      idSubcategory: bannerHighlight.offerHighlights?.subcategory?.id.toString(),
      idBrandProvider: bannerHighlight.offerHighlights?.brandProvider.toString()??null,)));
  }
}