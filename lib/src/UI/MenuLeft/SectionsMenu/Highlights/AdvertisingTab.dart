import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import 'Widgets.dart';

class AdvertisingTab extends StatefulWidget {
  @override
  _AdvertisingTabState createState() => _AdvertisingTabState();
}

class _AdvertisingTabState extends State<AdvertisingTab> {
  ProviderSettings providerSettings;
  RefreshController _refreshAdvertising = RefreshController(initialRefresh: false);
  int pageOffset = 0;

  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context,listen: false);
    providerSettings.ltsBannersCampaign.clear();
    getBannersCampaigns();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: CustomColors.whiteBackGround,
      body: Container(
        child:Column(
          children: [
            Expanded(child: SmartRefresher(
                controller: _refreshAdvertising,
                enablePullDown: true,
                enablePullUp: true,
                onLoading: _onLoadingToRefresh,
                footer: footerRefreshCustom(),
                header: headerRefresh(),
                onRefresh: _pullToRefresh,
                child:  providerSettings.ltsBannersCampaign.isEmpty
                    ? emptyData("ic_highlights_empty.png",
                    Strings.sorryHighlights, Strings.emptyCampaigns)
                    : listHighlights()))
          ],
        ),
      ),
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshAdvertising.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerSettings.ltsBannersCampaign.clear();
    getBannersCampaigns();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
   getBannersCampaigns();
    _refreshAdvertising.loadComplete();
  }

  Widget listHighlights(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: providerSettings.ltsBannersCampaign.isEmpty ? 0 : providerSettings.ltsBannersCampaign.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return itemCampaigns( providerSettings.ltsBannersCampaign[index]);
      },
    );
  }

  getBannersCampaigns() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings = providerSettings.getBannersCampaign(pageOffset.toString());
        await callSettings.then((list) {

        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}