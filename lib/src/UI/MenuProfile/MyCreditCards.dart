import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/CreditCard.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:wawamko/src/UI/PaymentMethods/addTarjet.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class MyCreditCards extends StatefulWidget {
  final bool isActiveSelectCard;
  const MyCreditCards({required this.isActiveSelectCard}) ;
  @override
  _MyCreditCardsState createState() => _MyCreditCardsState();
}

class _MyCreditCardsState extends State<MyCreditCards> {
  late ProfileProvider profileProvider;
  late ProviderCheckOut providerCheckOut;
  int pageOffset = 0;

  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context,listen: false);
    profileProvider.ltsCreditCards.clear();
    getListCreditsCard(pageOffset);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: <Widget>[
        titleBar(Strings.methodsPay, "ic_blue_arrow.png",
            () => Navigator.pop(context)),
        Expanded(
          child: profileProvider.ltsCreditCards.isEmpty
              ? emptyData("ic_empty_payment.png",
              Strings.notMethodPayment, Strings.beginShop)
              :Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 20),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: profileProvider.ltsCreditCards==null?0:profileProvider.ltsCreditCards.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap:()=>selectCreditCard(profileProvider.ltsCreditCards[index]) ,
                        child: itemPayMethod(profileProvider.ltsCreditCards[index]));
                  })),
        ),

        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50,vertical: 30),
            child: btnCustomRounded(
                CustomColors.blueSplash, CustomColors.white, Strings.addTarjet,
                    ()=>
                  Navigator.of(context).push(customPageTransition( AddTargetPage()))
                , context)),
      ],
    );
  }

  selectCreditCard(CreditCard creditCard){
    if(widget.isActiveSelectCard) {
      providerCheckOut.creditCardSelected = creditCard;
      Navigator.pop(context);
    }
  }

  Widget itemPayMethod(CreditCard creditCard) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: CustomColors.gray.withOpacity(.1), width: 1),
          color: CustomColors.white),
      child: Center(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                child:  SvgPicture.network(creditCard.iconCart!),
              ),
              SizedBox(width: 17),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      creditCard.cardNumber!,
                      style: TextStyle(
                          fontFamily: Strings.fontBold,
                          fontSize: 17,
                          color: CustomColors.blackLetter),
                    ),
                    Text(
                     creditCard.franchise!,
                      style: TextStyle(
                          fontSize: 13,
                          color: CustomColors.purpleOpacity,
                          fontFamily: Strings.fontRegular),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  child: Image(
                    width: 20,
                    height: 20,
                    image: AssetImage("Assets/images/ic_garbage.png"),
                  ),
                ),
                onTap: () {
                  utils.startCustomAlertMessage(
                      context,
                      Strings.titleDeleteCreditCard,
                      "Assets/images/ic_trash_big.png",
                      Strings.msgDeleteCreditCard, () {
                    Navigator.pop(context);
                   changeStatusCreditCart(creditCard);
                  }, () {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getListCreditsCard(int page) {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = profileProvider.getLtsCreditCards(pageOffset.toString());
      await callUser.then((lts) {}, onError: (error) {
        //utils.showSnackBar(context, error.toString());
      });
      } else {
        utils.showSnackBar(context, Strings.internetError);      }
    });
  }

  changeStatusCreditCart(CreditCard creditCard) async {
   utils.checkInternet().then((value) async {
      if (value) {
        Future callResponse = profileProvider.deleteCreditCard(creditCard.id.toString());
        await callResponse.then((user) {

        }, onError: (error) {
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
