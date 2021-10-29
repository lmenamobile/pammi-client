import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../OrderConfirmationPage.dart';
import 'Widgets.dart';

class DetailTransactionPage extends StatefulWidget{
  @override
  _DetailTransactionPageState createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  ProviderShopCart? providerShopCart;
  ProviderCheckOut? providerCheckOut;
  late ProviderSettings providerSettings;
  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    providerShopCart = Provider.of<ProviderShopCart>(context);
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
   return WillPopScope(
     onWillPop: () async => false,
     child: Scaffold(
       backgroundColor: CustomColors.blueSplash,
       body: SafeArea(
         child: Container(
           margin: EdgeInsets.only(top: 30),
           child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft:  Radius.circular(20),
                )
              ),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Expanded(
                    child: providerSettings.hasConnection?SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Text(
                            formatMoney(providerCheckOut?.efecty?.valorPesos??''),
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: Strings.fontBold,
                                color: CustomColors.blackLetter
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            Strings.completeCheckOut,
                            style: TextStyle(
                                fontFamily: Strings.fontRegular,
                                color: CustomColors.gray7
                            ),
                          ),
                          SizedBox(height: 20,),
                          imageAvatar("ic_efecty.png"),
                          SizedBox(height: 30,),
                          Text(
                            Strings.agreement,
                            style: TextStyle(
                                fontFamily: Strings.fontRegular,
                                color: CustomColors.gray7
                            ),
                          ),
                          SizedBox(height: 10,),
                          containerText(providerCheckOut?.efecty?.codigoproyecto??''),
                          SizedBox(height: 20,),
                          Text(
                            Strings.reference,
                            style: TextStyle(
                                fontFamily: Strings.fontRegular,
                                color: CustomColors.gray7
                            ),
                          ),
                          SizedBox(height: 10,),
                          containerText(providerCheckOut?.efecty?.pin??''),
                          SizedBox(height: 20,),
                          Container(
                            margin:EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              Strings.textTransactionEfecty,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: Strings.fontRegular,
                                  color: CustomColors.gray7
                              ),
                            ),
                          ),
                          containerExpansion(providerShopCart?.shopCart?.packagesProvider),
                          SizedBox(height: 10,),
                          Container(
                            width: 230,
                            child: btnCustomSize(40, Strings.btnAccept, CustomColors.blueSplash,
                                Colors.white, openFinishTransaction),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ):notConnectionInternet(),
                  )
                ],
              ),
           ),
         ),
       ),
     ),
   );
  }

  openFinishTransaction(){
    Navigator.push(context, customPageTransition(OrderConfirmationPage()));
  }
}

