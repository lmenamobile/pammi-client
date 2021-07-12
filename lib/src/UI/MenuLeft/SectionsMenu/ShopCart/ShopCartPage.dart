import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/UI/Home/Products/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';

import 'Widgets.dart';

class ShopCartPage  extends StatefulWidget {
  @override
  _ShopCartPageState createState() => _ShopCartPageState();
}

class _ShopCartPageState extends State<ShopCartPage> {

  ProviderShopCart providerShopCart;

  @override
  void initState() {
    providerShopCart = Provider.of<ProviderShopCart>(context,listen: false);
    providerShopCart.getShopCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerShopCart = Provider.of<ProviderShopCart>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: Stack(
            children: [
              titleBarWithDoubleAction(
                  Strings.shopCart,
                  "ic_blue_arrow.png",
                  "ic_car.png",
                      () => Navigator.pop(context),
                  null),
              Column(
                children: [
                  SizedBox(height: 55,),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: CustomColors.whiteBackGround,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )
                      ),
                      child: Column(
                        children: [

                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listProductsByProvider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: providerShopCart?.shopCart?.packagesProvider==null?0:providerShopCart?.shopCart?.packagesProvider?.length,
        itemBuilder: (BuildContext context, int index) {
          return cardListProductsByProvider();
        },
      ),
    );
  }

  getShopCart() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.getShopCart();
        await callCart.then((msg) {

        }, onError: (error) {
          providerShopCart.isLoadingCart = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}