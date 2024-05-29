import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Providers/ProviderClaimOrder.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/DetailClaimPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/WidgetsClaim.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class ClaimsCloseTab extends StatefulWidget {
  @override
  _ClaimsCloseTabState createState() => _ClaimsCloseTabState();
}

class _ClaimsCloseTabState extends State<ClaimsCloseTab> {
  late ProviderClaimOrder providerClaims;
  RefreshController _refreshOrders = RefreshController(initialRefresh: false);
  int pageOffset = 0;

  @override
  void initState() {
    providerClaims = Provider.of<ProviderClaimOrder>(context,listen: false);
    providerClaims.lstClaimsOpen.clear();
    getClaimsClose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerClaims = Provider.of<ProviderClaimOrder>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
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
                  child: providerClaims.lstClaimsClose.isEmpty
                      ? emptyData("ic_highlights_empty.png",
                      Strings.sorryHighlights, Strings.emptyHighlights)
                      : listItemsClaimsClose()))
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
    providerClaims.lstClaimsClose.clear();
    getClaimsClose();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getClaimsClose();
    _refreshOrders.loadComplete();
  }

  Widget listItemsClaimsClose(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: providerClaims.lstClaimsClose.isEmpty ? 0 :providerClaims.lstClaimsClose.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return InkWell(
          onTap: ()=>openDetailClaim(providerClaims.lstClaimsClose[index].id.toString()),
            child: itemClaimClose(providerClaims.lstClaimsClose[index]));
      },
    );
  }

  openDetailClaim(String id){
    print("id reclamo $id");
    Navigator.push(context, customPageTransition(DetailClaimPage(idClaim: id),PageTransitionType.rightToLeftWithFade));
  }

  getClaimsClose() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callClaims = providerClaims.getClaimsClose(pageOffset.toString());
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