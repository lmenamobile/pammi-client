import 'package:flutter/material.dart';
import 'package:wawamko/src/UI/Home/HomePage.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:provider/provider.dart';

class OrderConfirmationPage extends StatefulWidget {
  @override
  _OrderConfirmationPageState createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final prefs = SharePreference();
  ProviderCheckOut providerCheckOut;

  @override
  Widget build(BuildContext context) {
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              titleBar(Strings.confirmationOrder, "ic_blue_arrow.png",
                  () => Navigator.pop(context)),
              SizedBox(height: 20,),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(Strings.thanksOrder,
                            style: TextStyle(
                                fontFamily: Strings.fontBold,
                                fontSize: 24,
                                color: CustomColors.blueSplash)),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(Strings.textConfirmationOrder,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: Strings.fontRegular,
                                  fontSize: 15,
                                  color: CustomColors.gray7)),
                        ),
                        Image.asset(
                          "Assets/images/order.gif",
                          width: 250,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(Strings.textConfirmation,
                            style: TextStyle(
                                fontFamily: Strings.fontRegular,
                                fontSize: 15,
                                color: CustomColors.gray7)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(prefs.nameUser??'',
                            style: TextStyle(
                                fontFamily: Strings.fontBold,
                                fontSize: 18,
                                color: CustomColors.blueSplash)),
                        Text(providerCheckOut?.addressSelected?.address??'',
                            style: TextStyle(
                                fontFamily: Strings.fontBold,
                                fontSize: 18,
                                color: CustomColors.blueSplash)),
                        SizedBox(
                          height: 20,
                        ),
                        btnCustom(230, Strings.myOrders, CustomColors.blueSplash,
                            Colors.white, null),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(2, 2))
                          ]),
                          child: btnCustom(230, Strings.start, Colors.white,
                              CustomColors.blackLetter, openStart),
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  openStart() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyHomePage()),
        (Route<dynamic> route) => false);
  }
}
