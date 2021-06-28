import 'package:flutter/material.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Highlights/HighlightsTab.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../../DrawerMenu.dart';

class HighlightsPage extends StatefulWidget {
  @override
  _HighlightsPageState createState() => _HighlightsPageState();
}

class _HighlightsPageState extends State<HighlightsPage> with SingleTickerProviderStateMixin{
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  TabController tabControllerPages;

  @override
  void initState() {
    super.initState();
    tabControllerPages = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
   tabControllerPages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuHighlights,
      ),
      body: SafeArea(
        child: Container(
          color: CustomColors.grayBackground,
          child: Column(
              children: [
                Stack(
                  children: [
                    titleBar(Strings.highlights, "ic_menu_w.png", () => keyMenuLeft.currentState.openDrawer()),
                    Container(
                      margin: EdgeInsets.only(top: 48),
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                          color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        )
                      ),
                      child: TabBar(
                        controller:tabControllerPages,
                        labelPadding: EdgeInsets.only(right: 10, left:10, top: 0, bottom: 0),
                        indicatorColor: Colors.red,
                        indicatorPadding: EdgeInsets.only(right: 20, left: 20),
                        indicatorWeight: 2,
                        labelColor: CustomColors.blackLetter,
                        unselectedLabelColor:CustomColors.blackLetter.withOpacity(.6),
                        labelStyle: TextStyle(
                            fontFamily: Strings.fontMedium,
                            fontSize: 16,
                            color:CustomColors.blackLetter),
                        unselectedLabelStyle: TextStyle(
                            fontFamily: Strings.fontRegular,
                            fontSize: 16,
                            color: CustomColors.blackLetter.withOpacity(.6)),
                        tabs: [
                          Tab(
                            text: Strings.highlights,
                          ),
                          Tab(
                            text: Strings.advertising,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Expanded(
                  child: TabBarView(
                    controller: tabControllerPages,
                    children: [
                      HighlightsTab(),
                      Container()
                    ],
                  ),
                )
              ],
          ),
        ),
      ),
    );
  }
}