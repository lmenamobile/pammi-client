import 'package:flutter/material.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/OrdersActiveTab.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../../../Widgets/WidgetsGeneric.dart';
import 'OrdersFinishTab.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
  TabController? tabControllerPages;

  @override
  void initState() {
    tabControllerPages = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabControllerPages!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              headerView( Strings.myOrdersTitle, ()=>Navigator.pop(context)),
              TabBar(
                controller: tabControllerPages,
                labelPadding:
                    EdgeInsets.only(right: 10, left: 10, top: 0, bottom: 0),
                indicatorColor: Colors.red,
                indicatorPadding: EdgeInsets.only(right: 20, left: 20),
                indicatorWeight: 2,
                labelColor: CustomColorsAPP.blackLetter,
                unselectedLabelColor: CustomColorsAPP.blackLetter.withOpacity(.6),
                labelStyle: TextStyle(
                    fontFamily: Strings.fontMedium,
                    fontSize: 16,
                    color: CustomColorsAPP.blackLetter),
                unselectedLabelStyle: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 16,
                    color: CustomColorsAPP.blackLetter.withOpacity(.6)),
                tabs: [
                  Tab(text: Strings.actives,),
                  Tab(text: Strings.ordersPrevious,),
                ],
              ),
              SizedBox(height: 10,),
              Expanded(
                child: TabBarView(
                  controller: tabControllerPages,
                  children: [
                    OrdersActiveTab(),
                    OrdersFinishTab()
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
