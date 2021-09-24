import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Notifications.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/Products/Widgets.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/MyOrdersPage.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../../DrawerMenu.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  RefreshController _refreshNotifications = RefreshController(initialRefresh: false);
  ProviderSettings providerSettings;
  int pageOffset = 0;

  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context,listen: false);
    providerSettings.ltsNotifications.clear();
    getNotifications();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuNotifications,
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  titleBarWithDoubleAction(
                      Strings.notifications,
                      "ic_menu_w.png",
                      "ic_remove_white.png",
                          () => keyMenuLeft.currentState.openDrawer(),
                          () => validateActionDelete(),false,""),
                  SizedBox(height: 10,),
                  Expanded(child: SmartRefresher(
                      controller: _refreshNotifications,
                      enablePullDown: true,
                      enablePullUp: true,
                      onLoading: _onLoadingToRefresh,
                      footer: footerRefreshCustom(),
                      header: headerRefresh(),
                      onRefresh: _pullToRefresh,
                      child: providerSettings.ltsNotifications.isEmpty
                          ? emptyData("ic_empty_notification.png",
                          Strings.sorry, Strings.emptyNotifications)
                          : listNotifications()))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget itemNotification(Notifications notification,Function select) {
    return Container(
      color: notification.isSelected?CustomColors.gray9:Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  child: FadeInImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(notification.image??''),
                    placeholder: AssetImage("Assets/images/spinner.gif"),
                  ),
                ),
                SizedBox(width: 15,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title??'',
                        style: TextStyle(
                            fontFamily: Strings.fontBold,
                            color: CustomColors.blackLetter
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        formatDate(notification?.createdAt, "dd-MM-yyyy", Constants.localeES),
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: CustomColors.gray8
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                       notification?.message??'',
                        maxLines: 4,
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: CustomColors.gray8
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: ()=>select(notification.id),
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: notification.isSelected?CustomColors.orange:CustomColors.gray5,
                    ),
                  ),
                )
              ],
            ),
          ),
          customDivider()
        ],
      ),
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshNotifications.refreshCompleted();
  }

  void clearForRefresh() {
    providerSettings.ltsNotifications.clear();
    pageOffset = 0;
    getNotifications();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
      pageOffset++;
      getNotifications();
    _refreshNotifications..loadComplete();
  }

  Widget listNotifications() {
    return ListView.builder(
      itemCount: providerSettings.ltsNotifications.isEmpty?0:providerSettings.ltsNotifications.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return InkWell(
          onTap: ()=>actionOpenNotification(providerSettings.ltsNotifications[index].type),
            child: itemNotification(providerSettings.ltsNotifications[index],providerSettings.selectNotification));
      },
    );
  }

  actionOpenNotification(String typeNotification){
    switch (typeNotification) {
      case Constants.notificationOrder:
        Navigator.push(context, customPageTransition(MyOrdersPage()));
        break;
      case "":

        break;
    }
  }

  validateActionDelete()async{
    if(providerSettings.ltsNotifications.firstWhere((element) => element.isSelected == true,orElse: ()=>null)!=null) {
      bool status = await showDialogDoubleAction(context, Strings.delete, Strings.deleteNotifications, "ic_trash_big.png");
      if (status)
        deleteNotifications();
    }else{
      utils.showSnackBar(context, Strings.notSelectedNotification);
    }
  }

  getNotifications() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings = providerSettings.getNotifications(pageOffset);
        await callSettings.then((product) {

        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  deleteNotifications() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings = providerSettings.deleteNotifications(providerSettings.ltsNotifications);
        await callSettings.then((product) {
          providerSettings.ltsNotifications.clear();
            getNotifications();
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

}