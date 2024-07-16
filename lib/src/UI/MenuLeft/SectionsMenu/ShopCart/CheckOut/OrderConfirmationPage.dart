import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/features/feature_home/presentation/views/HomePage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/MyOrdersPage.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class OrderConfirmationPage extends StatefulWidget {
  @override
  _OrderConfirmationPageState createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final prefs = SharePreference();
  ProviderCheckOut? providerCheckOut;
  late ProviderSettings providerSettings;

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
    return Scaffold(
      backgroundColor: CustomColorsAPP.redTour,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              headerView(Strings.confirmationOrder, ()=> Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                      (Route<dynamic> route) => false)),

              SizedBox(height: 20,),
              Expanded(
                child: providerSettings.hasConnection?SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(Strings.thanksOrder,
                            style: TextStyle(
                                fontFamily: Strings.fontBold,
                                fontSize: 24,
                                color: CustomColorsAPP.blueSplash)),
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
                                  color: CustomColorsAPP.gray7)),
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
                                color: CustomColorsAPP.gray7)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(prefs.nameUser,
                            style: TextStyle(
                                fontFamily: Strings.fontBold,
                                fontSize: 18,
                                color: CustomColorsAPP.blueSplash)),
                        SizedBox(height: 10,),
                        Text(providerCheckOut?.addressSelected?.address??'',
                            style: TextStyle(
                                fontFamily: Strings.fontBold,
                                fontSize: 18,
                                color: CustomColorsAPP.blueSplash),
                        textAlign: TextAlign.center,),
                        SizedBox(
                          height: 20,
                        ),
                        btnCustom(230, Strings.myOrders, CustomColorsAPP.blueSplash,
                            Colors.white, openOrders),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(26)),
                              boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(2, 2))
                          ]),
                          child: btnCustom(230, Strings.start, Colors.white,
                              CustomColorsAPP.blackLetter, openStart),
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ):notConnectionInternet(),
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

  openOrders(){
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyHomePage()),
            (Route<dynamic> route) => false);
    Navigator.push(context, customPageTransition(MyOrdersPage(),PageTransitionType.rightToLeftWithFade));
  }
}
