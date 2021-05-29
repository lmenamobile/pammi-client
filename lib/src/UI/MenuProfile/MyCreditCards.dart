import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/CreditCard.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/UI/PaymentMethods/addTarjet.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';

class MyCreditCards extends StatefulWidget {
  @override
  _MyCreditCardsState createState() => _MyCreditCardsState();
}

class _MyCreditCardsState extends State<MyCreditCards> {
  ProfileProvider profileProvider;
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
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: CustomColors.grayBackground,
              child: _body(context),
            ),
            Visibility(
                visible: profileProvider.isLoading, child: LoadingProgress()),
          ],
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
          child:profileProvider.ltsCreditCards.isEmpty?
              emptyView("Assets/images/ic_payment.png",Strings.emptyPaymentMethods,Strings.textPaymentMethods)
              :Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 20),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: profileProvider.ltsCreditCards==null?0:profileProvider.ltsCreditCards.length,
                  itemBuilder: (BuildContext context, int index) {
                    return itemPayMethod(profileProvider.ltsCreditCards[index]);
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

  Widget itemPayMethod(CreditCard creditCard) {
    return GestureDetector(
      child: Container(
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
                Image(
                    width: 70,
                    height: 70,
                    fit: BoxFit.fill,
                    image: AssetImage("Assets/images/ic_express.png")),
                SizedBox(width: 17),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        creditCard.cardNumber,
                        style: TextStyle(
                            fontFamily: Strings.fontBold,
                            fontSize: 17,
                            color: CustomColors.blackLetter),
                      ),
                      Text(
                        creditCard?.franchise??'',
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
                      deleteCreditCard(creditCard.id.toString());
                    }, () {
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            ),
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
        utils.showSnackBar(context, error.toString());
      });
      } else {
        utils.showSnackBar(context, Strings.internetError);      }
    });
  }


  deleteCreditCard(String id) {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = profileProvider.deleteCreditCard(id);
        await callUser.then((msg) {
          utils.showSnackBarGood(context,msg.toString());
        }, onError: (error) {
          utils.showSnackBar(context,error.toString());
          profileProvider.isLoading = false;
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}