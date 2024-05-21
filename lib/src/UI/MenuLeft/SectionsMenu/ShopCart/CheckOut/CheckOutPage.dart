 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Address/GetAddress.dart';
import 'package:wawamko/src/Models/PaymentMethod.dart';
import 'package:wawamko/src/Models/UserProfile.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/Providers/ProviderUser.dart';
import 'package:wawamko/src/Providers/UserProvider.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/CheckOut/DetailTransaction/DetailTransactionPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/CheckOut/PaymentMethodsPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/CheckOut/TransactionADDIPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/CheckOut/TransactionPSEPage.dart';
import 'package:wawamko/src/UI/MenuProfile/MyAddress.dart';
import 'package:wawamko/src/UI/MenuProfile/MyCreditCards.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/Widgets.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import '../../../../../Utils/FunctionsUtils.dart';
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
  late ProviderSettings providerSettings;

  ProviderShopCart? providerShopCart;
  String msgError = '';

  //PaymentMethod? _paymentSelected = PaymentMethod(image:"https://pamii-dev.s3.us-east-2.amazonaws.com/wawamko/methods_payment/ic_upon_delivery.svg",id: 2,methodPayment: "Pago a la entrega del pedido");


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setCardPayMethodIfGiftCard();
    //  providerCheckOut = Provider.of<ProviderCheckOut>(context,listen: false);
      providerCheckOut.clearValuesPayment();
      serviceGetAddAddressUser();
     });

    super.initState();
  }

  _setCardPayMethodIfGiftCard(){
    if(providerShopCart?.shopCart!
        .packagesProvider!.isEmpty ?? false){
      providerCheckOut.paymentSelected = null;
      PaymentMethod? _paymentSelected = PaymentMethod(image:"https://pamii-dev.s3.us-east-2.amazonaws.com/wawamko/methods_payment/ic_card.svg",id: 1,methodPayment: "Tarjeta de crèdito");
      providerCheckOut.paymentSelected = _paymentSelected;
    }

  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
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

                  header(context, Strings.order, CustomColors.redDot, () => Navigator.pop(context)),

                  providerShopCart?.shopCart == null
                      ? emptyData(
                      "ic_highlights_empty.png",
                      Strings.sorryHighlights,
                      Strings.emptyProductsSave)
                      :Expanded(
                    child: providerSettings.hasConnection?SingleChildScrollView(
                      child: Column(
                        children: [
                          InkWell(
                              onTap: ()async{
                                await Navigator.push(context, customPageTransition(MyAddressPage()));
                                getShippingPrice();
                                getShopCart();
                              },
                              child: sectionAddress(providerCheckOut.addressSelected)),
                          SizedBox(height: 8,),
                          providerShopCart?.shopCart?.packagesProvider?.isEmpty ?? false? listGiftCards():sectionProducts(providerShopCart?.shopCart?.packagesProvider),
                          SizedBox(height: 8,),
                          Visibility(
                            visible: !providerCheckOut.isTotalPaymentFree,
                            child: InkWell(
                              onTap: ()=>openPaymentMethods((){
                                getShippingPrice();
                                getShopCart();
                              }),
                            child: sectionPayment(providerCheckOut.paymentSelected,reduceQuota,providerCheckOut.quotaValue,providerCheckOut.quotaList)),
                          ),
                          SizedBox(height: 8,),
                          sectionDiscount(providerCheckOut.isValidateGift,providerCheckOut.isValidateDiscount,
                              changeValueValidateDiscount,controllerCoupon,controllerGift,callApplyDiscount,callDeleteDiscount
                          ),
                          SizedBox(height: 15,),
                          sectionTotal(providerShopCart?.shopCart?.totalCart,openCreateOrder,providerCheckOut.shippingPrice)
                             ],
                      ),
                    ):notConnectionInternet(),
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



  void reduceQuota(int newValue) {
    providerCheckOut.quotaValue = newValue ?? 0;
  }

  void calculateTotalForPaymentFree(){
    var total = calculateTotal(providerShopCart?.shopCart?.totalCart?.total??'0', providerCheckOut.shippingPrice,providerShopCart?.shopCart?.totalCart?.discountShipping??'0');
    total == "0.0" ? providerCheckOut.isTotalPaymentFree = true : providerCheckOut.isTotalPaymentFree = false;
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
    if(providerCheckOut.paymentSelected!.id== Constants.paymentCreditCard){
      if(providerCheckOut.creditCardSelected==null){
        msgError = Strings.errorSelectedCreditCard;
        return false;
      }
    }
    if(providerCheckOut.paymentSelected!.id== Constants.paymentPSE){
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
    providerCheckOut.isValidateDiscount = false;
    providerCheckOut.isValidateGift = !providerCheckOut.isValidateGift;
  }

  openCreateOrder(){
    if(validateCheckOut()){
      if(providerCheckOut.isTotalPaymentFree){
        //SI el valor total es 0, la orden se crea con medio de pago efectivo id 2
        createOrder(2,
            providerCheckOut.addressSelected!.id.toString(), "","",providerCheckOut.shippingPrice,providerShopCart?.discountShipping??'0',0);
      }else{
        actionsByTypePayment(providerCheckOut.paymentSelected!,providerCheckOut.quotaValue);
      }
    }else{
      utils.showSnackBar(context, msgError);
    }
  }

  openPaymentMethods(Function refreshPriceShipping){
    Navigator.push(context, customPageTransition(PaymentMethodsPage())).then((value)async{
      if(providerCheckOut.paymentSelected!.id== Constants.paymentCreditCard){
        Navigator.push(context, customPageTransition(MyCreditCards(isActiveSelectCard: true,)));
      }else if(providerCheckOut.paymentSelected!.id== Constants.paymentPSE){
        var bank = await openSelectBank(context);
        if(bank!=null)
          providerCheckOut.bankSelected = bank;
      }
      refreshPriceShipping();
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
      providerCheckOut.isTotalPaymentFree = false;
      providerCheckOut.isValidateGift = false;
    }else{
      providerCheckOut.isTotalPaymentFree = false;
      deleteCoupon();
    }
  }

  actionsByTypePayment(PaymentMethod paymentMethod, int dues){
    switch (paymentMethod.id) {
      case Constants.paymentCreditCard:
          createOrder(providerCheckOut.paymentSelected!.id!,
              providerCheckOut.addressSelected!.id.toString(), "",
              providerCheckOut.creditCardSelected!.id.toString(),providerCheckOut.shippingPrice,providerShopCart?.discountShipping??'0',dues);
        break;
      case Constants.paymentCash:
        createOrder(
            providerCheckOut.paymentSelected!.id!,
            providerCheckOut.addressSelected!.id.toString(), "","",providerCheckOut.shippingPrice,providerShopCart?.discountShipping??'0',0);
        break;
      case Constants.paymentBaloto:
        createOrder(
            providerCheckOut.paymentSelected!.id!,
            providerCheckOut.addressSelected!.id.toString(), "","",providerCheckOut.shippingPrice,providerShopCart?.discountShipping??'0',0);
        break;
      case Constants.paymentEfecty:
        createOrder(
            providerCheckOut.paymentSelected!.id!,
            providerCheckOut.addressSelected!.id.toString(), "","",providerCheckOut.shippingPrice,providerShopCart?.discountShipping??'0',0);
        break;
      case Constants.paymentPSE:
        createOrder(
            providerCheckOut.paymentSelected!.id!,
            providerCheckOut.addressSelected!.id.toString(), providerCheckOut.bankSelected!.bankCode,"",providerCheckOut.shippingPrice,providerShopCart?.discountShipping??'0',0);
        break;
      case Constants.paymentADDI:
        createOrder(
            providerCheckOut.paymentSelected!.id!,
            providerCheckOut.addressSelected!.id.toString(), "","",providerCheckOut.shippingPrice, providerShopCart?.discountShipping??'0',0);
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
        Future callCart = providerShopCart!.getShopCart(providerCheckOut.paymentSelected?.id ?? 2);
        await callCart.then((msg) {
          if(providerCheckOut.isValidateDiscount) {
            calculateTotalForPaymentFree();
          }
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
        Future callCart = providerCheckOut.calculateShippingPrice( providerCheckOut.addressSelected!.id.toString(),providerCheckOut.paymentSelected?.id ?? 2);
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

  createOrder( int paymentMethodId,
      String addressId,
      String? bankId,
      String creditCardId,
      String shippingValue,
      String discountShipping,
      int dues) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerCheckOut.createOrder(paymentMethodId.toString(), addressId, bankId,creditCardId,shippingValue, discountShipping,dues);
        await callCart.then((msg) {
          if(paymentMethodId == Constants.paymentCreditCard){
            providerCheckOut.quotaValue = 0;
            Navigator.push(context, customPageTransition(OrderConfirmationPage()));
          }else if(paymentMethodId == Constants.paymentCash){
            Navigator.push(context, customPageTransition(OrderConfirmationPage()));
          }else if(paymentMethodId == Constants.paymentBaloto ||paymentMethodId == Constants.paymentEfecty){
            Navigator.push(context, customPageTransition(DetailTransactionPage()));
          }else if(paymentMethodId == Constants.paymentPSE){
            Navigator.push(context, customPageTransition(TransactionPSEPage()));
          }else if(paymentMethodId ==Constants.paymentADDI){
            Navigator.push(context, customPageTransition(TransactionADDIPage()));
          }
          utils.showSnackBarGood(context, msg);
          providerShopCart!.totalProductsCart = "0";
          providerCheckOut.isValidateDiscount = false;
          providerCheckOut.isTotalPaymentFree = false;
        }, onError: (error) {
          providerCheckOut.isLoading = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }


  serviceGetAddAddressUser() async {

    utils.checkInternet().then((value) async {
      if (value) {
        providerCheckOut.isLoading = true;
        Future callResponse = UserProvider.instance.getAddress(context, 0);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          GetAddressResponse data = GetAddressResponse.fromJson(decodeJSON);

          if (data.status ?? false) {
            for (var address in data.data!.addresses!) {
              if(address.principal ?? false){
                providerCheckOut.addressSelected = address;
              }
            }

          }
          providerCheckOut.isLoading = false;
          getShippingPrice();



        }, onError: (error) {
          providerCheckOut.isLoading = false;
          print("Ocurrio un error: $error");
        });
      } else {
        utils.showSnackBarError(context,Strings.loseInternet);
      }
    });
  }


}