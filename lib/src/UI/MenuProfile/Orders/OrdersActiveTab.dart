import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Providers/ProviderOder.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/DetailOrderPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class OrdersActiveTab extends StatefulWidget {
  @override
  _OrdersActiveTabState createState() => _OrdersActiveTabState();
}

class _OrdersActiveTabState extends State<OrdersActiveTab> {
  late ProviderOrder providerOrder;
  RefreshController _refreshOrders = RefreshController(initialRefresh: false);
  int pageOffset = 0;

  @override
  void initState() {
    providerOrder = Provider.of<ProviderOrder>(context,listen: false);
    providerOrder.lstOrders.clear();
    getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerOrder = Provider.of<ProviderOrder>(context);
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
                  child:  providerOrder.lstOrders.isEmpty
                      ? emptyData("ic_highlights_empty.png",
                      Strings.sorryHighlights, Strings.emptyHighlights)
                      : listItemsOrders()))
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
    providerOrder.lstOrders.clear();
    getOrders();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getOrders();
    _refreshOrders.loadComplete();
  }

  Widget listItemsOrders(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: providerOrder.lstOrders.isEmpty ? 0 :providerOrder.lstOrders.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return InkWell(
          onTap: ()=>openDetailOrder(providerOrder.lstOrders[index].id.toString()),
            child: itemOrder(providerOrder.lstOrders[index]));
      },
    );
  }

  openDetailOrder(String id){
    print("id de la orden $id");
    Navigator.push(context, customPageTransition(DetailOrderPage(idOrder: id,isActiveOrder: false,isOrderFinish: false)));
  }

  getOrders() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callOrders = providerOrder.getOrders(pageOffset.toString());
        await callOrders.then((list) {

        }, onError: (error) {
         // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}