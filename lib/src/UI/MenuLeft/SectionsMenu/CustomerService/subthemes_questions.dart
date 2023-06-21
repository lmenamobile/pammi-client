import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Themes/subtheme_response.dart';
import 'package:wawamko/src/Models/Themes/theme_response.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/pqrs_provider.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/CustomerService/subtheme_response.dart';
import 'package:wawamko/src/UI/MenuProfile/MyAddress.dart';
import 'package:wawamko/src/UI/MenuProfile/MyCreditCards.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/ClaimPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/MyClaimPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/MyOrdersPage.dart';
import 'package:wawamko/src/UI/User/MyDates.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/DialogLoading.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../FavoritesPage.dart';


class SubthemesQuestionsPage extends StatefulWidget {
  final int id;
  final String subtheme;


  const SubthemesQuestionsPage(
      {Key? key, required this.id, required this.subtheme})
      : super(key: key);

  @override
  State<SubthemesQuestionsPage> createState() => _SubthemesQuestionsPageState();
}

class _SubthemesQuestionsPageState extends State<SubthemesQuestionsPage> {
  
  final RefreshController _refreshControllerQuestions = RefreshController();
  int offset = 0;
  late PQRSProvider pqrsProvider;
  
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getQuestionsBySubTheme();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) { 
    pqrsProvider = Provider.of<PQRSProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          child: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        header(context, widget.subtheme, CustomColors.redDot, ()=> Navigator.pop(context)),
        const SizedBox(height: 10,),
        Expanded(
          child: pqrsProvider.isLoadingQuestions ? DialogLoadingAnimated() :  SmartRefresher(
            controller: _refreshControllerQuestions,
            onLoading:_onLoading ,
            onRefresh: _pullToRefresh,
            physics: const BouncingScrollPhysics(),
            child: pqrsProvider.questionsSubTheme.isEmpty ? Center(
              child: emptyPage(
                  description: Strings.thisIsSoEmptyDescription,
                  title: Strings.thisIsSoEmpty,
                  image: "ic_empty_order.png"
              ),
            ): Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      Strings.frecuensQuestion,
                      style: TextStyle(
                        color: CustomColors.blackLetter,
                        fontFamily: Strings.fontMedium,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: pqrsProvider.questionsSubTheme.length,
                  padding: EdgeInsets.only(top: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ItemQuestion(itemQuestionsSubTheme: pqrsProvider.questionsSubTheme[index],action: _goToTopology);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _goToTopology(ItemQuestionsSubTheme itemQuestionsSubTheme){
    switch(itemQuestionsSubTheme.typology){
      case "questionAndResponse":
        _goToResponseQuestion(itemQuestionsSubTheme);
        break;
      case "redirectModule":
        _goToModuleTopology(itemQuestionsSubTheme.module ?? "");
        break;
      default:
        utils.showSnackBar(context,Strings.noReceiveTopology);
    }
  }

  _goToModuleTopology(String module){

    switch(module){
      case "dates":
        Navigator.of(context)
            .push(PageTransition(
            type: PageTransitionType.fade,
            child: MyDatesPage(),
            duration: Duration(milliseconds: 700)));
        break;
      case "claims":
        Navigator.of(context).push(PageTransition(
            type: PageTransitionType.fade,
            child: MyClaimPage(),
            duration: Duration(milliseconds: 700)));
        break;
      case "wishes":
       Navigator.of(context).push(PageTransition(
            type: PageTransitionType.fade,
            child: FavoritesPage(),
            duration: Duration(milliseconds: 700)));
        break;
      case "addresses":
       Navigator.of(context).push(PageTransition(
            type: PageTransitionType.fade,
            child: MyAddressPage(),
            duration: Duration(milliseconds: 700)));
        break;
      case "payments":
        Navigator.of(context).push(PageTransition(
            type: PageTransitionType.fade,
            child: MyCreditCards(isActiveSelectCard: false,),
            duration: Duration(milliseconds: 700)));
        break;

      case "orders":
        Navigator.of(context).push(PageTransition(
            type: PageTransitionType.fade,
            child: MyOrdersPage(),
            duration: Duration(milliseconds: 700)));

    }
  }

  _goToResponseQuestion(ItemQuestionsSubTheme itemQuestionsSubTheme){
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: SubThemeResponse(itemQuestionsSubTheme: itemQuestionsSubTheme),
        duration: Duration(milliseconds: 700),
      ),
    );
  }



  getQuestionsBySubTheme() {
    utils.check().then((value) async {
      if (value) {
        Future<dynamic> pqrsFuture = pqrsProvider.getQuestionsBySubTheme(widget.id, offset);

        await pqrsFuture.then((value) {
          print("call message ${value}");
          if(value != null){
            utils.showSnackBar(
                context,
                value,
               );
          }

        });
      } else {
        utils.showSnackBarError(context, Strings.internetError);
      }
    });
  }

  _pullToRefresh(){
    offset = 0;
    getQuestionsBySubTheme();
    _refreshControllerQuestions.refreshCompleted();
  }

  _onLoading() async {
    if(offset < pqrsProvider.totalPages -1){
      offset++;
      getQuestionsBySubTheme();
    }
    _refreshControllerQuestions.loadComplete();
  }
  
}

class ItemQuestion extends StatelessWidget {
  final ItemQuestionsSubTheme itemQuestionsSubTheme;
  final Function action;

  const ItemQuestion({
    Key? key,
   required this.itemQuestionsSubTheme,
    required this.action
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        action(itemQuestionsSubTheme);
      },
      child: Container(
        height: 60,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: CustomColors.gray8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                itemQuestionsSubTheme.question ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: Strings.fontRegular,
                  color: CustomColors.blackLetter,
                ),
              ),
            ),
            Container(
              child: Image(
                width: 30,
                height: 30,
                color: CustomColors.gray2,
                image: AssetImage("Assets/images/ic_arrow_black.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }




}
  
  

