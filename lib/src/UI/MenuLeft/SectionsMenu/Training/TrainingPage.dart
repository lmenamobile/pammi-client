import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/UI/Home/Products/Widgets.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../../DrawerMenu.dart';

class TrainingPage extends StatefulWidget {
  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> with SingleTickerProviderStateMixin{
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  RefreshController _refreshHighlights = RefreshController(initialRefresh: false);
  int pageOffset = 0;

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuTraining,
      ),
      body: SafeArea(
        child: Container(
          color: CustomColors.grayBackground,
          child: Column(
            children: [
              titleBar(Strings.trainings, "ic_menu_w.png", () => keyMenuLeft.currentState.openDrawer()),
              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }



  Widget listTraining(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: 5,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return Container();
      },
    );
  }

}