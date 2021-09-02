import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Models/Support/QuestionsModel.dart';
import 'package:wawamko/src/Models/Support/TermsConditionsModel.dart';
import 'package:wawamko/src/Providers/SupportProvider.dart';
import 'package:wawamko/src/UI/InterestCategoriesUser.dart';
import 'package:wawamko/src/UI/Onboarding/UpdatePassword.dart';
import 'package:wawamko/src/UI/changePassword.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
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
  SupportProvider supportProvider;
  int pageOffset = 0;

  @override
  void initState() {
    supportProvider = Provider.of<SupportProvider>(context,listen: false);
    supportProvider.lstQuestion.clear();
    getQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    supportProvider = Provider.of<SupportProvider>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: "support",
      ),
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: Column(
            children: [
              titleBar(Strings.supportAndService, "ic_menu_w.png", () => keyMenuLeft.currentState.openDrawer()),
              SizedBox(height: 20,),
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
              InkWell(
                onTap:()=>Navigator.of(context).push(customPageTransition(PreRegisterPage())),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: CustomColors.greyBorder,width: 1)
                  ),
                  child: Row(
                    mainAxisSize:MainAxisSize.max ,
                    mainAxisAlignment:MainAxisAlignment.spaceAround ,
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
                        Icons.arrow_forward_ios,
                        color: CustomColors.gray7,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(child: SmartRefresher(
                  controller: _refreshSupport,
                  enablePullDown: true,
                  enablePullUp: true,
                  onLoading: _onLoadingToRefresh,
                  footer: footerRefreshCustom(),
                  header: headerRefresh(),
                  onRefresh: _pullToRefresh,
                  child:  listQuestion()))
            ],
          ),
        ),
      ),
    );
  }

  Widget listQuestion(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: supportProvider.lstQuestion.isEmpty ? 0 : supportProvider.lstQuestion.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return  itemHelpCenterExpanded(supportProvider.lstQuestion[index], context);
      },
    );
  }

  Widget listTerms(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: supportProvider.lstTermsAndConditions.isEmpty ? 0 : supportProvider.lstTermsAndConditions.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, int index) {
        return  itemHelpCenter(supportProvider.lstTermsAndConditions[index].name, () {
          launch(supportProvider.lstTermsAndConditions[index].url);
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
        Future callSupport = supportProvider.getQuestions(pageOffset.toString());
        await callSupport.then((list) {
          serviceGetTerms();
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
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
        await callSupport.then((list) {

        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
