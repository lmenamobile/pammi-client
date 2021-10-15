import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/PaymentMethod.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/CheckOut/DetailTransaction/DetailTransactionPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/CheckOut/PaymentMethodsPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/CheckOut/TransactionPSEPage.dart';
import 'package:wawamko/src/UI/MenuProfile/MyAddress.dart';
import 'package:wawamko/src/UI/MenuProfile/MyCreditCards.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/Widgets.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import '../CheckOut/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import 'OrderConfirmationPage.dart';

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  TextEditingController controllerGift = TextEditingController();
  TextEditingController controllerCoupon = TextEditingController();
  late ProviderCheckOut providerCheckOut;
  ProviderShopCart? providerShopCart;
  String msgError = '';

  @override
  Widget build(BuildContext context) {
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
    providerShopCart = Provider.of<ProviderShopCart>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.grayBackground,
          child: Stack(
            children: [
              Column(
                children: [
                  titleBar(Strings.order, "ic_blue_arrow.png", () => Navigator.pop(context)),
                  providerShopCart?.shopCart == null
                      ? emptyData(
                      "ic_highlights_empty.png",
                      Strings.sorryHighlights,
                      Strings.emptyProductsSave)
                      :Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          InkWell(
                              onTap: ()async{
                                await Navigator.push(context, customPageTransition(MyAddressPage()));
                                getShippingPrice();
                              },
                              child: sectionAddress(providerCheckOut.addressSelected)),
                          SizedBox(height: 8,),
                          providerShopCart!.shopCart!.packagesProvider!.isEmpty? listGiftCards():sectionProducts(providerShopCart?.shopCart?.packagesProvider),
                          SizedBox(height: 8,),
                          InkWell(
                            onTap: ()=>openPaymentMethods(),
                              child: sectionPayment(providerCheckOut.paymentSelected)),
                          SizedBox(height: 8,),
                          sectionDiscount(providerCheckOut.isValidateGift,providerCheckOut.isValidateDiscount,
                              changeValueValidateDiscount,controllerCoupon,controllerGift,callApplyDiscount,callDeleteDiscount
                          ),
                          SizedBox(height: 15,),
                          sectionTotal(providerShopCart?.shopCart?.totalCart,openCreateOrder,providerCheckOut.shippingPrice)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                  visible: providerCheckOut.isLoading, child: LoadingProgress()),
            ],
          ),
        ),
      ),
    );
  }

  Widget listGiftCards() {
    return Container(
      width: 180,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: providerShopCart?.shopCart?.products==null?0:providerShopCart?.shopCart?.products!.length,
        itemBuilder: (_, int index) {
          return itemGift(providerShopCart?.shopCart?.products![index].giftCard);
        },
      ),
    );
  }

  bool validateCheckOut(){
    if(providerCheckOut.addressSelected==null){
      msgError = Strings.errorSelectAddress;
      return false;
    }else if(providerCheckOut.paymentSelected==null){
      msgError = Strings.errorSelectPayment;
      return false;
    }
    if(providerCheckOut.paymentSelected!.id== 1){
      if(providerCheckOut.creditCardSelected==null){
        msgError = Strings.errorSelectedCreditCard;
        return false;
      }
    }
    if(providerCheckOut.paymentSelected!.id== 6){
      if(providerCheckOut.bankSelected  ==null){
        msgError = Strings.errorSelectedBank;
        return false;
      }
    }
    return true;
  }

  changeValueValidateDiscount(){
    controllerCoupon.clear();
    controllerGift.clear();
    providerCheckOut.isValidateGift = !providerCheckOut.isValidateGift;
  }

  openCreateOrder(){
    if(validateCheckOut()){
      actionsByTypePayment(providerCheckOut.paymentSelected!);
    }else{
      utils.showSnackBar(context, msgError);
    }
  }

  openPaymentMethods(){
    Navigator.push(context, customPageTransition(PaymentMethodsPage())).then((value)async{
      if(providerCheckOut.paymentSelected!.id== 1){
        Navigator.push(context, customPageTransition(MyCreditCards()));
      }else if(providerCheckOut.paymentSelected!.id== 6){
        var bank = await openSelectBank(context);
        if(bank!=null)
          providerCheckOut.bankSelected = bank;
      }
    });
  }

  callApplyDiscount(){
    if(providerCheckOut.isValidateGift){
      if(controllerGift.text.isNotEmpty){
        applyGiftCard(controllerGift.text.trim());
      }else{
        utils.showSnackBar(context, Strings.giftEmpty);
      }
    }else{
      if(controllerCoupon.text.isNotEmpty){
        applyCoupon(controllerCoupon.text.trim());
      }else{
        utils.showSnackBar(context, Strings.couponEmpty);
      }
    }
  }

  callDeleteDiscount(){
    if(providerCheckOut.isValidateGift){
      deleteGiftCard();
      providerCheckOut.isValidateGift = false;
    }else{
      deleteCoupon();
    }
  }

  actionsByTypePayment(PaymentMethod paymentMethod){
    switch (paymentMethod.id) {
      case 1:
          createOrder(providerCheckOut.paymentSelected!.id.toString(),
              providerCheckOut.addressSelected!.id.toString(), "",
              providerCheckOut.creditCardSelected!.id.toString(),providerCheckOut.shippingPrice);
        break;
      case 2:
        createOrder(
            providerCheckOut.paymentSelected!.id.toString(),
            providerCheckOut.addressSelected!.id.toString(), "","",providerCheckOut.shippingPrice);
        break;
      case 3:
        utils.showSnackBar(context, Strings.errorPaymentMethod);
        break;
      case 4:
        createOrder(
            providerCheckOut.paymentSelected!.id.toString(),
            providerCheckOut.addressSelected!.id.toString(), "","",providerCheckOut.shippingPrice);
        break;
      case 5:
        createOrder(
            providerCheckOut.paymentSelected!.id.toString(),
            providerCheckOut.addressSelected!.id.toString(), "","",providerCheckOut.shippingPrice);
        break;
      case 6:
        createOrder(
            providerCheckOut.paymentSelected!.id.toString(),
            providerCheckOut.addressSelected!.id.toString(), providerCheckOut.bankSelected!.bankCode,"",providerCheckOut.shippingPrice);
        break;
    }
  }

  applyGiftCard(String gift) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerCheckOut.applyGiftCard(gift);
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
          providerCheckOut.isValidateDiscount = false;
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

  deleteGiftCard() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerCheckOut.deleteGiftCard();
        await callCart.then((msg) {
          providerCheckOut.isValidateDiscount = false;
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
        Future callCart = providerShopCart!.getShopCart();
        await callCart.then((msg) {

        }, onError: (error) {
          providerShopCart!.isLoadingCart = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  getShippingPrice() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerCheckOut.calculateShippingPrice( providerCheckOut.addressSelected!.id.toString());
        await callCart.then((msg) {
          print("valor $msg");
        }, onError: (error) {
          providerShopCart!.isLoadingCart = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  createOrder( String paymentMethodId,
      String addressId,
      String? bankId,
      String creditCardId,
      String shippingValue) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerCheckOut.createOrder(paymentMethodId, addressId, bankId,creditCardId,shippingValue);
        await callCart.then((msg) {
          if(paymentMethodId == "1"){
            Navigator.push(context, customPageTransition(OrderConfirmationPage()));
          }else if(paymentMethodId == "2"){
            Navigator.push(context, customPageTransition(OrderConfirmationPage()));
          }else if(paymentMethodId == "5"){
            Navigator.push(context, customPageTransition(DetailTransactionPage()));
          }else if(paymentMethodId == "6"){
            Navigator.push(context, customPageTransition(TransactionPSEPage()));
          }
          utils.showSnackBarGood(context, msg);
        }, onError: (error) {
          providerCheckOut.isLoading = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }


}