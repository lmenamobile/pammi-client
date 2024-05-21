import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Providers/ProviderChat.dart';
import 'package:wawamko/src/Providers/ProviderHome.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/SocketService.dart';
import 'package:wawamko/src/Providers/SupportProvider.dart';
import 'package:wawamko/src/UI/Chat/ChatPage.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/UI/MenuLeft/DrawerMenu.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import 'PreRegister/PreRegisterPage.dart';

class SupportHelpPage extends StatefulWidget {
  @override
  _SupportHelpPageState createState() => _SupportHelpPageState();
}

class _SupportHelpPageState extends State<SupportHelpPage> {
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  RefreshController _refreshSupport = RefreshController(initialRefresh: false);
  late SupportProvider supportProvider;
  late ProviderChat providerChat;
  late ProviderHome providerHome;
  late SocketService socketService;
  late ProviderSettings providerSettings;
  final prefs = SharePreference();
  int pageOffset = 0;

  @override
  void initState() {
    supportProvider = Provider.of<SupportProvider>(context, listen: false);
    socketService = Provider.of<SocketService>(context,listen: false);
    providerHome = Provider.of<ProviderHome>(context,listen: false);
    supportProvider.lstQuestion.clear();
    getQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    supportProvider = Provider.of<SupportProvider>(context);
    providerChat = Provider.of<ProviderChat>(context);
    socketService = Provider.of<SocketService>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: "support",
        version: providerHome.version,
      ),
      body: WillPopScope(
        onWillPop:(()=> utils.startCustomAlertMessage(context, Strings.sessionClose,
            "Assets/images/ic_sign_off.png", Strings.closeAppText, ()=>
                Navigator.pop(context,true), ()=>Navigator.pop(context,false)).then((value) => value!)),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                headerDoubleTapMenu(context, Strings.supportAndService, "",
                    "ic_menu_w.png", CustomColors.redDot, "0", () => keyMenuLeft.currentState!.openDrawer(), (){}),
                SizedBox(
                  height: 20,
                ),
                Image(
                  width: 135,
                  height: 135,
                  image: AssetImage("Assets/images/ic_customer.png"),
                ),
                SizedBox(height: 10),
                Text(
                  Strings.support,
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: Strings.fontBold,
                      color: CustomColors.blackLetter),
                ),
                SizedBox(height: 20),
                btnChatSupport(),
                SizedBox(height: 20),
                InkWell(
                  onTap: () => Navigator.of(context)
                      .push(customPageTransition(PreRegisterPage())),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                            color: CustomColors.greyBorder, width: .5)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          Strings.preRegister,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: Strings.fontBold,
                              fontSize: 15,
                              color: CustomColors.blackLetter),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: CustomColors.gray7,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                    child: SmartRefresher(
                        controller: _refreshSupport,
                        enablePullDown: true,
                        enablePullUp: true,
                        onLoading: _onLoadingToRefresh,
                        footer: footerRefreshCustom(),
                        header: headerRefresh(),
                        onRefresh: _pullToRefresh,
                        child: providerSettings.hasConnection?listQuestion():notConnectionInternet()))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btnChatSupport() {
    return InkWell(
      onTap: () {
        getRoomSupport();
      },
      child: Container(
        width: 270,
        decoration: BoxDecoration(
            color: CustomColors.blue,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                "Assets/images/ic_chat_pamii.png",
                width: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                height: 20,
                width: 1,
                color: Colors.white.withOpacity(.2),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.chatWithUs,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: Strings.fontBold,
                    ),
                  ),
                  Text(
                    Strings.chatWithUsText,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: Strings.fontRegular,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 15,
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listQuestion() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: supportProvider.lstQuestion.isEmpty
          ? 0
          : supportProvider.lstQuestion.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return Container(
          margin: EdgeInsets.only(bottom: 5),
          child: itemHelpCenterExpanded(
              supportProvider.lstQuestion[index], context),
        );
      },
    );
  }

  Widget listTerms() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: supportProvider.lstTermsAndConditions.isEmpty
          ? 0
          : supportProvider.lstTermsAndConditions.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return itemHelpCenter(supportProvider.lstTermsAndConditions[index].name!,
                () {
              launch(supportProvider.lstTermsAndConditions[index].url!);
            });
      },
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshSupport.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    supportProvider.lstQuestion.clear();
    getQuestions();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getQuestions();
    _refreshSupport.loadComplete();
  }

  getQuestions() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSupport =
        supportProvider.getQuestions(pageOffset.toString());
        await callSupport.then((list) {
          serviceGetTerms();
        }, onError: (error) {
          // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  serviceGetTerms() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSupport = supportProvider.getTermsAndConditions();
        await callSupport.then((list) {}, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  getRoomSupport() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callChat = providerChat.getRomAdmin();
        await callChat.then((id) async {
          if(socketService.serverStatus!=ServerStatus.Online){
            socketService.connectSocket(Constants.typeAdmin, id,"");
          }
          Navigator.push(context, customPageTransition(ChatPage(roomId: id, typeChat: Constants.typeAdmin,imageProfile: Constants.profileAdmin,fromPush: false,)));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
