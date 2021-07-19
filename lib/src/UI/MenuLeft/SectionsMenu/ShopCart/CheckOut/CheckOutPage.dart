import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Address.dart';
import 'package:wawamko/src/Models/ShopCart/PackageProvider.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/CheckOut/PaymentMethodsPage.dart';
import 'package:wawamko/src/UI/MenuProfile/MyAddress.dart';
import 'package:wawamko/src/Utils/utils.dart';
import '../CheckOut/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  TextEditingController controllerGift = TextEditingController();
  TextEditingController controllerCoupon = TextEditingController();
  ProviderCheckOut providerCheckOut;
  ProviderShopCart providerShopCart;


  @override
  Widget build(BuildContext context) {
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
    providerShopCart = Provider.of<ProviderShopCart>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.grayBackground,
          child: Column(
            children: [
              titleBar(Strings.order, "ic_blue_arrow.png", () => Navigator.pop(context)),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                          onTap: ()=>Navigator.push(context, customPageTransition(MyAddressPage())),
                          child: sectionAddress(providerCheckOut.addressSelected)),
                      SizedBox(height: 8,),
                      sectionProducts(providerShopCart?.shopCart?.packagesProvider),
                      SizedBox(height: 8,),
                      InkWell(
                        onTap: ()=>Navigator.push(context, customPageTransition(PaymentMethodsPage())),
                          child: sectionPayment(providerCheckOut.paymentSelected)),
                      SizedBox(height: 8,),
                      sectionDiscount(providerCheckOut.isValidateGift,providerCheckOut.isValidateDiscount,
                          changeValueValidateDiscount,controllerCoupon,controllerGift,callApplyDiscount,deleteCoupon
                      ),
                      SizedBox(height: 15,),
                      sectionTotal(providerShopCart?.shopCart?.totalCart)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  changeValueValidateDiscount(){
    controllerCoupon.clear();
    controllerGift.clear();
    providerCheckOut.isValidateGift = !providerCheckOut.isValidateGift;
  }

  callApplyDiscount(){
    if(providerCheckOut.isValidateGift){
      print("cajon de la gift ${controllerGift.text}");
    }else{
      if(controllerCoupon.text.isNotEmpty){
        applyCoupon(controllerCoupon.text.trim());
      }else{
        utils.showSnackBar(context, Strings.couponEmpty);
      }
    }
  }

  applyCoupon(String coupon) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerCheckOut.applyCoupon(coupon);
        await callCart.then((msg) {
          providerCheckOut.isValidateDiscount = true;
         getShopCart();
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          providerCheckOut.isValidateDiscount = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  deleteCoupon() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerCheckOut.deleteCoupon();
        await callCart.then((msg) {
          getShopCart();
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
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