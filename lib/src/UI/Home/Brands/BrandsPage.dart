import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Providers/ProviderHome.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/Categories/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../../../features/feature_views_shared/domain/domain.dart';

class BrandsPage extends StatefulWidget{
  @override
  _BrandsPageState createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  late ProviderHome providerHome;
  late ProviderSettings providerSettings;
  SharePreference prefs = SharePreference();
  RefreshController _refreshBrands =
  RefreshController(initialRefresh: false);
  int pageOffset = 0;

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    providerHome = Provider.of<ProviderHome>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color:  Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  headerView(Strings.brandsAssociate,()=>Navigator.pop(context)),
                  Expanded(
                      child: SmartRefresher(
                          controller: _refreshBrands,
                          enablePullDown: true,
                          enablePullUp: true,
                          onLoading: _onLoadingToRefresh,
                          footer: footerRefreshCustom(),
                          header: headerRefresh(),
                          onRefresh: _pullToRefresh,
                          child: Container()/*providerSettings.hasConnection?[]
                              ? emptyData("ic_empty_notification.png",
                              Strings.sorry, Strings.emptyBrands)
                              :SingleChildScrollView(child: listBrands()):notConnectionInternet()*/))
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

  Widget listBrands() {
    return Container(
      /*margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: providerHome.ltsBrands.isEmpty?0:providerHome.ltsBrands.length,
        itemBuilder: (BuildContext context, int index) {
          return itemBrandRow(providerHome.ltsBrands[index],openProductsByBrand);
        },
      ),*/
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshBrands.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    _refreshBrands.loadComplete();
  }

  openProductsByBrand(Brand brand){
    //Navigator.push(context, customPageTransition(ProductsByCategoryPage( idBrand:brand.id.toString()),PageTransitionType.rightToLeftWithFade));
  }


}