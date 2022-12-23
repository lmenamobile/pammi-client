import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Support/Themes.dart';
import 'package:wawamko/src/Providers/ProviderCustomerService.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/MenuLeft/DrawerMenu.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/CustomerService/contactPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/CustomerService/pqrs/pqrs.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/CustomerService/subthemes_questions.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class CustomerServicePage extends StatefulWidget {
  const CustomerServicePage({Key? key}) : super(key: key);

  @override
  State<CustomerServicePage> createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> {
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  RefreshController _refreshControllerThemes = RefreshController();
  late ProviderCustomerService providerCustomerService;
  int pageOffset = 0;

  @override
  void initState() {
    providerCustomerService =
        Provider.of<ProviderCustomerService>(context, listen: false);
    getThemes(false);
    super.initState();
  }

  @override
  void dispose() {
    providerCustomerService.ltsThemes.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    providerCustomerService = Provider.of<ProviderCustomerService>(context);
    final providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuCustomerService,
      ),
      body: WillPopScope(
        onWillPop: (() => utils
            .startCustomAlertMessage(
          context,
          Strings.sessionClose,
          "Assets/images/ic_sign_off.png",
          Strings.closeAppText,
              () => Navigator.pop(context, true),
              () => Navigator.pop(context, false),
        )
            .then((value) => value!)),
        child: SafeArea(
          child: Container(
            color: CustomColors.grayBackground,
            child:  Column(
              children: [
                titleBar(
                  Strings.customerService,
                  "ic_menu_w.png",
                      () => keyMenuLeft.currentState!.openDrawer(),
                ),
                Expanded(
                  child: !providerCustomerService.isLoading
                      ? SmartRefresher(
                    controller: _refreshControllerThemes,
                    enablePullUp: true,
                    enablePullDown: true,
                    physics: const BouncingScrollPhysics(),
                    footer: footerRefreshCustom(),
                    header: headerRefresh(),
                    onLoading: _onLoadingOpen,
                    onRefresh: _pullToRefreshOpen,
                    child: providerSettings.hasConnection
                        ? SingleChildScrollView(
                      child: Column(

                        children: [

                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: providerCustomerService
                                .ltsThemes.length,
                            itemBuilder: (context, index) {
                              return itemTheme(
                                providerCustomerService
                                    .ltsThemes[index],
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Column(
                            children: [
                              _themeLabel(
                                Strings.customerService,
                              ),
                              _itemSubTheme(
                                  false,
                                  title: Strings.contactUs,
                                  pathImage:
                                  'Assets/images/ic_contact.svg',
                                  action: (){
                                    Navigator.of(context).push(
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: ContactPage(),
                                        duration: Duration(milliseconds: 700),
                                      ),
                                    );
                                  }
                              ),
                              _itemSubTheme(
                                  false,
                                  title: Strings.pqrs,
                                  pathImage:
                                  'Assets/images/ic_question.svg',
                                  action: (){
                                    Navigator.of(context).push(
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: PqrsPage(),
                                        duration: Duration(milliseconds: 700),
                                      ),
                                    );
                                  }
                              ),
                            ],
                          )



                        ],
                      ),
                    )
                        :notConnectionInternet()
                    ,
                  )
                      : LoadingProgress(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pullToRefreshOpen() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _clearForRefreshOpen();
    _refreshControllerThemes.refreshCompleted();
  }

  void _clearForRefreshOpen() async {
    pageOffset = 0;
    providerCustomerService.ltsThemes.clear();
    getThemes(false);
  }

  void _onLoadingOpen() async {
    await Future.delayed(const Duration(milliseconds: 800));
    pageOffset++;
    getThemes(true);
    _refreshControllerThemes.loadComplete();
  }

  Widget itemTheme(Themes theme) {
    return Column(
      children: [
        _themeLabel(theme.theme),
        SizedBox(height: 10),
        ListView.builder(
          primary: false,
          itemCount: theme.subthemes?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return _itemSubTheme(true, subtheme: theme.subthemes?[index],action: (){
              Navigator.of(context).push(
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: SubthemesQuestionsPage(
                    id: theme.subthemes?[index].id ?? 0,
                    subtheme: theme.subthemes?[index].subtheme ?? '',
                  ),
                  duration: Duration(milliseconds: 700),
                ),
              );
            });
          },
        )
      ],
    );
  }

  Padding _themeLabel(String? theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          theme ?? '',
          style: TextStyle(
            color: CustomColors.black1,
            fontFamily: Strings.fontMedium,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _itemSubTheme(bool isDynamic,
      {Subtheme? subtheme, String pathImage = '', String title = '',required Function action}) {
    //TODO: fix padding
    return GestureDetector(
      onTap: (){
        action();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
        height: 65,
        child: Row(
          children: [
            isDynamic
                ? Image.network(subtheme?.image ?? '')
                : Container(
              width: 30,
              height: 30,
              child: SvgPicture.asset(pathImage),
            ),
            Expanded(
              child: Text(
                isDynamic ? subtheme?.subtheme ?? '' : title,
                style: TextStyle(
                  color: CustomColors.blackLetter,
                  fontFamily: Strings.fontRegular,
                  fontSize: 16,
                ),
              ),
            ),
            Center(
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: CustomColors.gray11,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  getThemes(bool scrolling) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callThemes =
        providerCustomerService.getThemes(pageOffset, scrolling);
        await callThemes.then((value) => null);
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
