import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Notifications.dart';
import 'package:wawamko/src/Providers/ProviderHome.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/CustomerService/pqrs/pqrs.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/MyOrdersPage.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../../DrawerMenu.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  RefreshController _refreshNotifications = RefreshController(initialRefresh: false);
  late ProviderSettings providerSettings;
  late ProviderHome providerHome;
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
    providerHome = Provider.of<ProviderHome>(context);
    return Scaffold(
      key: keyMenuLeft,
      backgroundColor: Colors.white,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuNotifications,
      ),
      body: WillPopScope(
        onWillPop:(()=> utils.startCustomAlertMessage(context, Strings.sessionClose,
            "Assets/images/ic_sign_off.png", Strings.closeAppText, ()=>
                Navigator.pop(context,true), ()=>Navigator.pop(context,false)).then((value) => value!)),
        child: SafeArea(
          child: Container(
            child: Stack(
              children: [
                Column(
                  children: [
                    headerDoubleTapMenu(context, Strings.notifications, "ic_remove_white.png", "ic_menu_w.png", AppColors.redDot, "0", () => keyMenuLeft.currentState!.openDrawer(), () => validateActionDelete()),
                    SizedBox(height: 10,),
                    Expanded(child: SmartRefresher(
                        controller: _refreshNotifications,
                        enablePullDown: true,
                        enablePullUp: true,
                        onLoading: _onLoadingToRefresh,
                        footer: footerRefreshCustom(),
                        header: headerRefresh(),
                        onRefresh: _pullToRefresh,
                        child:providerSettings.hasConnection? providerSettings.ltsNotifications.isEmpty
                            ? emptyData("ic_empty_notification.png",
                            Strings.sorry, Strings.emptyNotifications)
                            : listNotifications():notConnectionInternet()))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget itemNotification
      (Notifications notification,Function select) {
    return Container(
      color: notification.isSelected!?AppColors.gray9:Colors.transparent,
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
                    imageErrorBuilder: (_,__,___){
                      return Container();
                    },
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
                            color: AppColors.blackLetter
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        formatDate(notification.createdAt??DateTime.now(), "dd-MM-yyyy", Constants.localeES),
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: AppColors.gray8
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                       notification.message??'',
                        maxLines: 4,
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: AppColors.gray8
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
                      backgroundColor: notification.isSelected!?AppColors.orange:AppColors.gray5,
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

  actionOpenNotification(String? typeNotification){
    switch (typeNotification) {
      case Constants.notificationOrder:
        Navigator.push(context, customPageTransition(MyOrdersPage(),PageTransitionType.rightToLeft));
        break;
      case "pqrs":
        Navigator.of(context).push(
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: PqrsPage(),
            duration: Duration(milliseconds: 700),
          ),
        );
        break;
    }
  }

  validateActionDelete()async{
    if(providerSettings.ltsNotifications.firstWhereOrNull((element) => element.isSelected == true)!=null) {
      bool? status = await showDialogDoubleAction(context, Strings.delete, Strings.deleteNotifications, "ic_trash_big.png",Strings.yesDelete);
      if (status??false)
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
          //utils.showSnackBar(context, error.toString());
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
          clearForRefresh();
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

}