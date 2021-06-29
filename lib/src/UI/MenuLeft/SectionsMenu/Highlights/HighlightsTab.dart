import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Highlights/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class HighlightsTab extends StatefulWidget{
  @override
  _HighlightsTabState createState() => _HighlightsTabState();
}

class _HighlightsTabState extends State<HighlightsTab> {
  ProviderSettings providerSettings;
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
    return Scaffold(
      backgroundColor: CustomColors.whiteBackGround,
      body: Container(
        child:Column(
          children: [
            Expanded(child: SmartRefresher(
                controller: _refreshHighlights,
                enablePullDown: true,
                enablePullUp: true,
                onLoading: _onLoadingToRefresh,
                footer: footerRefreshCustom(),
                header: headerRefresh(),
                onRefresh: _pullToRefresh,
                child:  providerSettings.ltsBannersHighlights.isEmpty
                    ? emptyData("ic_highlights_empty.png",
                    Strings.sorryHighlights, Strings.emptyHighlights)
                    : listHighlights()))
          ],
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
    providerSettings.ltsBannersCampaign.clear();
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
        return itemHighlights( providerSettings.ltsBannersHighlights[index]);
      },
    );
  }

  getBannersHighlights() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callHome = providerSettings.getBannersHighlights(pageOffset.toString());
        await callHome.then((list) {

        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}