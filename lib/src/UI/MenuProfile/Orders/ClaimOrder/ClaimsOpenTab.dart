import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Providers/ProviderClaimOrder.dart';
import 'package:wawamko/src/Providers/ProviderOder.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/CloseClaimPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/DetailClaimPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/WidgetsClaim.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/DetailOrderPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class ClaimsOpenTab extends StatefulWidget {
  @override
  _ClaimsOpenTabState createState() => _ClaimsOpenTabState();
}

class _ClaimsOpenTabState extends State<ClaimsOpenTab> {
  late ProviderClaimOrder providerClaims;
  RefreshController _refreshOrders = RefreshController(initialRefresh: false);
  int pageOffset = 0;

  @override
  void initState() {
    providerClaims = Provider.of<ProviderClaimOrder>(context,listen: false);
    providerClaims.lstClaimsOpen.clear();
    getClaimsOpen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerClaims = Provider.of<ProviderClaimOrder>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child:Column(
            children: [
              Expanded(child: SmartRefresher(
                  controller: _refreshOrders,
                  enablePullDown: true,
                  enablePullUp: true,
                  onLoading: _onLoadingToRefresh,
                  footer: footerRefreshCustom(),
                  header: headerRefresh(),
                  onRefresh: _pullToRefresh,
                  child:  providerClaims.lstClaimsOpen.isEmpty
                      ? emptyData("ic_highlights_empty.png",
                      Strings.sorryHighlights, Strings.emptyHighlights)
                      : listItemsClaimsOpen()))
            ],
          ),
        ),
      ),
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshOrders.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerClaims.lstClaimsOpen.clear();
    getClaimsOpen();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getClaimsOpen();
    _refreshOrders.loadComplete();
  }

  Widget listItemsClaimsOpen(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: providerClaims.lstClaimsOpen.isEmpty ? 0 :providerClaims.lstClaimsOpen.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return itemClaimOPen(providerClaims.lstClaimsOpen[index],openCloseClaim,openDetailClaim);
      },
    );
  }

  openDetailClaim(String id){
    print("id reclamo $id");
    Navigator.push(context, customPageTransition(DetailClaimPage(idClaim: id)));
  }

  openCloseClaim(String id){
    print("id de la orden $id");
    Navigator.push(context, customPageTransition(CloseClaimPage(idPackage: id)));
  }

  getClaimsOpen() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callClaims = providerClaims.getClaimsOpen(pageOffset.toString());
        await callClaims.then((list) {

        }, onError: (error) {
         // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}