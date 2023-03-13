import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Models/Training.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../../DrawerMenu.dart';

class TrainingPage extends StatefulWidget {
  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> with SingleTickerProviderStateMixin{
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  RefreshController _refreshTraining = RefreshController(initialRefresh: false);
  late ProviderSettings providerSettings;
  int pageOffset = 0;

  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context,listen: false);
    getListTrainings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuTraining,
      ),
      body: WillPopScope(
        onWillPop:(()=> utils.startCustomAlertMessage(context, Strings.sessionClose,
            "Assets/images/ic_sign_off.png", Strings.closeAppText, ()=>
                Navigator.pop(context,true), ()=>Navigator.pop(context,false)).then((value) => value!)),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  children: [
                    //titleBar(Strings.trainings, "ic_menu_w.png", () => keyMenuLeft.currentState!.openDrawer()),
                    headerDoubleTapMenu(context, Strings.trainings, "", "ic_menu_w.png", CustomColors.redDot, "0", () => keyMenuLeft.currentState!.openDrawer(), (){}),
                    SizedBox(height: 20,),
                    Expanded(child: SmartRefresher(
                        controller: _refreshTraining,
                        enablePullDown: true,
                        enablePullUp: true,
                        onLoading: _onLoadingToRefresh,
                        footer: footerRefreshCustom(),
                        header: headerRefresh(),
                        onRefresh: _pullToRefresh,
                        child: providerSettings.hasConnection? providerSettings.ltsTraining.isEmpty
                            ? emptyData("ic_highlights_empty.png",
                            Strings.sorryHighlights, Strings.emptyTraining)
                            : listTraining():notConnectionInternet()))
                  ],
                ),
                Visibility(
                    visible: providerSettings.isLoading, child: LoadingProgress()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemTraining(Training training){
    return InkWell(
      onTap: ()=>launch(training.url!),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
        child: Container(
          decoration: BoxDecoration(
              color: CustomColors.greyBackground,
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    training.training??'',
                    style: TextStyle(
                        fontFamily: Strings.fontMedium,
                        color: CustomColors.blackLetter
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 40,
                  width: 1,
                  color: CustomColors.grayBackground,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: CustomColors.orange,
                  child: Center(
                    child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listTraining(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: providerSettings.ltsTraining.isEmpty?0:providerSettings.ltsTraining.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return itemTraining(providerSettings.ltsTraining[index]);
      },
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshTraining.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerSettings.ltsTraining.clear();
    getListTrainings();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getListTrainings();
    _refreshTraining.loadComplete();
  }

  getListTrainings() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings = providerSettings.getTrainings(pageOffset);
        await callSettings.then((list) {

        }, onError: (error) {
          //utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

}