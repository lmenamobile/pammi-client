import 'package:flutter/material.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/OrdersActiveTab.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class MyClaimPage extends StatefulWidget {
  @override
  _MyClaimPageState createState() => _MyClaimPageState();
}

class _MyClaimPageState extends State<MyClaimPage>
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
          color: CustomColors.whiteBackGround,
          child: Column(
            children: [
              titleBar(Strings.myClaims, "ic_back.png",
                  () => Navigator.pop(context)),
              TabBar(
                controller: tabControllerPages,
                labelPadding:
                    EdgeInsets.only(right: 10, left: 10, top: 0, bottom: 0),
                indicatorColor: Colors.red,
                indicatorPadding: EdgeInsets.only(right: 20, left: 20),
                indicatorWeight: 2,
                labelColor: CustomColors.blackLetter,
                unselectedLabelColor: CustomColors.blackLetter.withOpacity(.6),
                labelStyle: TextStyle(
                    fontFamily: Strings.fontMedium,
                    fontSize: 16,
                    color: CustomColors.blackLetter),
                unselectedLabelStyle: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 16,
                    color: CustomColors.blackLetter.withOpacity(.6)),
                tabs: [
                  Tab(text: Strings.claimOpen,),
                  Tab(text: Strings.claimClose,),
                ],
              ),
              SizedBox(height: 10,),
              Expanded(
                child: TabBarView(
                  controller: tabControllerPages,
                  children: [

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
