import 'package:flutter/material.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Highlights/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';

class HighlightsTab extends StatefulWidget{
  @override
  _HighlightsTabState createState() => _HighlightsTabState();
}

class _HighlightsTabState extends State<HighlightsTab> {
  ProviderSettings providerSettings;
  int pageOffset = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteBackGround,
      body: Container(
        child:Column(
          children: [
            Expanded(child: listHighlights())
          ],
        ),
      ),
    );
  }

  Widget listHighlights(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: 5,//providerSettings.ltsBannersHighlights.isEmpty ? 0 : providerSettings.ltsBannersHighlights.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return itemHighlights();
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