import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wawamko/src/Models/Address.dart';
import 'package:wawamko/src/Models/PaymentMethod.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Models/ShopCart/PackageProvider.dart';
import 'package:wawamko/src/Models/ShopCart/ProductOfferCart.dart';
import 'package:wawamko/src/Models/ShopCart/ProductShopCart.dart';
import 'package:wawamko/src/Models/ShopCart/TotalCart.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/ExpansionWidget.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../../../../../Utils/Constants.dart';
import '../Widgets.dart';

Widget sectionAddress(Address? address) {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.yourOrder,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 19,
              color: CustomColorsAPP.blackLetter,
            ),
          ),
          customDivider(),
          Text(
            Strings.deliveryAddress,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              color: CustomColorsAPP.blackLetter,
            ),
          ),
          customDivider(),
          Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Image.asset("Assets/images/ic_map.png"),
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.mainAddress,
                      style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        color: CustomColorsAPP.gray7,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    address==null?Row(
                      children: [
                        Text(
                          Strings.selectYouAddress,
                          style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: CustomColorsAPP.gray7,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: CustomColorsAPP.gray7,size: 15,
                        )
                      ],
                    ):
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.address??'',
                          style: TextStyle(
                            fontFamily: Strings.fontBold,
                            fontSize: 15,
                            color: CustomColorsAPP.blackLetter,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          address.complement??'',
                          style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: CustomColorsAPP.gray7,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}

Widget sectionProducts(List<PackagesProvider>? packagesProvider) {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.products,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 19,
              color: CustomColorsAPP.blackLetter,
            ),
          ),
          customDivider(),
          listProductsCheckOut(packagesProvider)

        ],
      ),
    ),
  );
}

Widget itemProvider(PackagesProvider provider) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2))
          ]),
          child: Center(
            child: FadeInImage(
              height: 40,
              fit: BoxFit.fill,
              image: NetworkImage(""),
              placeholder: AssetImage("Assets/images/spinner.gif"),
              imageErrorBuilder: (_,__,___){
                return Container();
              },
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.provider?.businessName??'',
                style: TextStyle(
                  fontFamily: Strings.fontBold,
                  fontSize: 15,
                  color: CustomColorsAPP.gray7,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                Strings.brand,
                style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  color: CustomColorsAPP.gray7,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "aca va l marca",
                style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  color: CustomColorsAPP.gray7,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: CustomColorsAPP.gray7,
          size: 15,
        )
      ],
    ),
  );
}

Widget sectionPayment(PaymentMethod? payment, Function quotaSelect, int quota, List<int> quotaList) {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.paymentMethod,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 19,
              color: CustomColorsAPP.blackLetter,
            ),
          ),
          customDivider(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Visibility(
                      visible: payment==null,
                      child: Text(
                        Strings.selectPayment,
                        style: TextStyle(
                          fontFamily: Strings.fontBold,
                          fontSize: 15,
                          color: CustomColorsAPP.gray7,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: payment!=null,
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              width: 55,
                              child: SvgPicture.network(payment?.image??''),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              color: CustomColorsAPP.grayBackground,
                              height: 30,
                              width: 1,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  payment?.methodPayment??'',
                                  style: TextStyle(
                                    fontFamily: Strings.fontBold,
                                    fontSize: 15,
                                    color: CustomColorsAPP.gray7,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: CustomColorsAPP.gray7,
                  size: 15,
                )
              ],
            ),
          ),
          customDivider(),

          Visibility(
            visible: payment?.id == Constants.paymentCreditCard ? true : false,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6,bottom: 20),
                  child: Text(
                    "Selecciona el número de cuotas",
                    style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 15, color: CustomColorsAPP.gray7,),
                  ),
                ),

            Container(
              height: 48,
              padding: EdgeInsets.only(left: 10,right: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.all(Radius.circular(5)), border: Border.all(color: Colors.grey.withOpacity(0.3),)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: DropdownButton(
                  focusColor: Colors.white,
                  dropdownColor: Colors.white,
                  menuMaxHeight:160,
                  value: quota,
                  elevation: 1,
                  items: quotaList.map((element) {
                    return DropdownMenuItem(
                      value: element,
                      child: Container(alignment: Alignment.centerLeft, child: Text("$element", style: TextStyle(fontFamily:Strings.fontRegular, color: Colors.grey,fontSize: 16))),
                    );
                  }).toList(),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color:Colors.grey,),
                  underline: Container(height: 1, color: Colors.transparent,),
                  style: TextStyle(fontFamily: Strings.fontRegular, color: Colors.grey,fontSize: 16),
                  onChanged: (newValue) {
                    quotaSelect(newValue);
                  },
                ),
              ),
            ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget contSlider(Function reduceQuota, Function increaseQuota, int value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        icon: Icon(Icons.remove),
        onPressed: (){
          reduceQuota();
        },
      ),
      SizedBox(width: 20),
      Text(
        '$value',
        style: TextStyle(
          fontFamily: Strings.fontRegular,
          fontSize: 18,
          color: CustomColorsAPP.blackLetter,
        ),
      ),
      SizedBox(width: 20),
      IconButton(
        icon: Icon(Icons.add),
        onPressed: (){
          increaseQuota();
        },
      ),
    ],
  );
}

Widget sectionDiscount(
    bool isValidateGift,
    bool isValidateDiscount,
    Function changeValue,TextEditingController controllerCoupon,TextEditingController controllerGift,Function applyDiscount,
    Function deleteDiscount) {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.discount,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 19,
              color: CustomColorsAPP.blackLetter,
            ),
          ),
          customDivider(),
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                itemCoupon("ic_coupon.png",Strings.coupon,!isValidateGift,changeValue),
                SizedBox(
                  width: 10,
                ),
                itemCoupon("ic_gift_cards.png",Strings.card,isValidateGift,changeValue)
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: isValidateGift?fieldCoupon(controllerGift, Strings.hintCard):fieldCoupon(controllerCoupon, Strings.hintCoupon)),
          Container(
            width: 150,
            child: isValidateDiscount?btnCustomSize(35, Strings.remove, CustomColorsAPP.redTour, Colors.white, deleteDiscount):btnCustomSize(35, Strings.validate, CustomColorsAPP.orange, Colors.white, applyDiscount),
          )
        ],
      ),
    ),
  );
}

Widget itemCoupon(String icon,String text, bool isValidate, Function change) {
  return InkWell(
    onTap: ()=>change(),
    child: Container(
      decoration: BoxDecoration(
        color: isValidate?CustomColorsAPP.blue.withOpacity(.4):CustomColorsAPP.grayThree,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: isValidate?CustomColorsAPP.blue:CustomColorsAPP.greyBorder)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          children: [
            Container(
              height: 20,
              width: 20,
              child: Image.asset("Assets/images/$icon",),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 30,
              width: 1,
              color: isValidate?CustomColorsAPP.blue:CustomColorsAPP.greyBorder,
            ),
            Text(
              text,
              style: TextStyle(
                  color: isValidate?CustomColorsAPP.blue:CustomColorsAPP.gray7, fontFamily: Strings.fontRegular),
            )
          ],
        ),
      ),
    ),
  );
}

Widget fieldCoupon(TextEditingController controller, String hintText) {
  return Container(
    margin: EdgeInsets.only(bottom: 20),
    padding: EdgeInsets.only(left: 10),
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: CustomColorsAPP.gray.withOpacity(.3), width: 1),
        color: CustomColorsAPP.white),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            child: TextField(
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              keyboardType: TextInputType.text,
              controller: controller,
              style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  color: CustomColorsAPP.blackLetter),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: CustomColorsAPP.gray7.withOpacity(.4),
                  fontFamily: Strings.fontRegular,
                ),
                hintText: hintText,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

Widget sectionTotal( TotalCart? totalCart, Function createOrder, String shipping) {
  var styleRegular = TextStyle(fontFamily: Strings.fontRegular, fontSize: 15, color: CustomColorsAPP.blackLetter,);
  var styleBold = TextStyle(fontFamily: Strings.fontBold, fontSize: 19, color: CustomColorsAPP.blackLetter,);

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    )),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          itemTotal(styleRegular, Strings.subTotal, totalCart?.subtotal??'0', ),
          itemTotal(styleRegular, Strings.delivery, shipping, ),
          itemTotal(styleRegular, Strings.discountShipping, totalCart?.discountShipping??'0', isDiscount: true),
          customDivider(),
          itemTotal(styleRegular, Strings.IVA, totalCart?.iva??'0', ),
          itemTotal(styleRegular, Strings.coupon, totalCart?.discountCoupon??'0', ),
          itemTotal(styleRegular, Strings.giftCard, totalCart?.discountGiftCard??'0', ),
          customDivider(),
          itemTotal(styleBold, Strings.total, calculateTotal(totalCart?.total??'0',shipping, totalCart?.discountShipping??'0')),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nota: ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: Strings.fontBold
                ),
              ),
              Expanded(
                child: Text(
                  Strings.note,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: Strings.fontRegular
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          Align(
              alignment: Alignment.center,
              child: btnCustom(230,Strings.payment,CustomColorsAPP.blueSplash,Colors.white,createOrder)),
          SizedBox(height: 20,),
        ],
      ),
    ),
  );
}

Widget itemTotal(TextStyle style,String text, String value, {bool isDiscount = false}) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        text,
        style: style,
      ),
      Text(
        !isDiscount
            ? formatMoney(value)
            : '- ${formatMoney(value)}',
        style: style,
      ),
    ],
  );
}

Widget cardListProductsCheckOut(PackagesProvider provider) {
  return Container(
    margin: EdgeInsets.only(bottom: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: ExpansionWidget(
        initiallyExpanded: true,
        iconColor: CustomColorsAPP.gray7,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.provider?.businessName ?? '',
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: Strings.fontBold,
                      color: CustomColorsAPP.blackLetter),
                ),
                Text(
                  Strings.provider,
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      color: CustomColorsAPP.gray7),
                ),
              ],
            ),
            Visibility(
              visible: false,
              child: Container(
                decoration: BoxDecoration(
                    color: CustomColorsAPP.blue.withOpacity(.7),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Strings.moreView,
                    style: TextStyle(
                        fontFamily: Strings.fontBold, color: CustomColorsAPP.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              listProducts(provider.products)
            ],
          )
        ],
      ),
    ),
  );
}

Widget listProducts(List<ProductShopCart>? ltsProducts) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ltsProducts == null ? 0 : ltsProducts.length,
      itemBuilder: (BuildContext context, int index) {
        if(ltsProducts![index].reference!=null){
          return itemProductCart(ltsProducts[index]);
        }else{
          return itemCardGiftProduct(ltsProducts[index]);
        }

      },
    ),
  );
}

Widget itemProductCart(ProductShopCart product) {
  return Column(
    children: [
      Container(
        height: 1,
        width: double.infinity,
        color: CustomColorsAPP.grayBackground,
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        children: [
          Container(
            width: 130,
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                child: product.reference!.images!.isEmpty?Image.asset("Assets/images/spinner.gif"):
                isImageYoutube(product.reference?.images?[0].url??'',FadeInImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(product.reference?.images?[0].url??''),
                  placeholder: AssetImage("Assets/images/spinner.gif"),
                  imageErrorBuilder: (_,__,___){
                    return Container();
                  },
                )),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.reference?.brandAndProduct?.brandProvider?.brand?.brand??'',
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 12,
                    color: CustomColorsAPP.gray7,
                  ),
                ),
                Text(
                  product.reference?.reference ?? '',
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 13,
                    color: CustomColorsAPP.blackLetter,
                  ),
                ),
                viewPrice(product),

              ],
            ),
          )
        ],
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget itemOfferCart(ProductShopCart product, ProductOfferCart offer) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 1,
        width: double.infinity,
        color: CustomColorsAPP.grayBackground,
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        product.offer?.name??'',
        style: TextStyle(
          fontFamily: Strings.fontBold,
          fontSize: 12,
          color: CustomColorsAPP.blackLetter,
        ),
      ),
      Row(
        children: [
          Container(
            width: 130,
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                child: offer.reference!.images!.isEmpty?Image.asset("Assets/images/spinner.gif"):FadeInImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(offer.reference?.images?[getRandomPosition(offer.reference?.images?.length??0)].url??''),
                  placeholder: AssetImage("Assets/images/spinner.gif"),
                  imageErrorBuilder: (_,__,___){
                    return Container();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.reference?.brandAndProduct?.brandProvider?.brand?.brand??'',
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 12,
                    color: CustomColorsAPP.gray7,
                  ),
                ),
                Text(
                  offer.reference?.reference ?? '',
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 13,
                    color: CustomColorsAPP.blackLetter,
                  ),
                ),
                viewPriceOffer(offer),
              ],
            ),
          )
        ],
      ),
    ],
  );
}

Widget itemOfferProductGift(Reference? reference){
  return Container(

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.giftProducts,
          style: TextStyle(
            fontFamily: Strings.fontBold,
            fontSize: 12,
            color: CustomColorsAPP.gray7,
          ),
        ),
        SizedBox(height: 8,),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5)
              ),
              border: Border.all(
                color: CustomColorsAPP.gray2,
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  width: 70,
                  child: Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      child: reference!.images!.isEmpty?Image.asset("Assets/images/spinner.gif"):FadeInImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(reference.images?[getRandomPosition(reference.images?.length??0)].url??''),
                        placeholder: AssetImage("Assets/images/spinner.gif"),
                        imageErrorBuilder: (_,__,___){
                          return Container();
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reference.brandAndProduct?.brandProvider?.brand?.brand??'',
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 12,
                          color: CustomColorsAPP.gray7,
                        ),
                      ),
                      Text(
                        reference.reference ?? '',
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 13,
                          color: CustomColorsAPP.blackLetter,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget sliderProductGift(List<ProductOfferCart>? promotionProducts){
  return Container(
    width: 230,
    height: 110,
    child: CarouselSlider.builder(
      itemCount: promotionProducts==null?0:promotionProducts.length,
      itemBuilder: (_, int itemIndex, int pageViewIndex) =>
          itemOfferProductGift(promotionProducts![itemIndex].reference),
      options: CarouselOptions(
        autoPlay: false
      ),
    ),
  );
}

Widget itemCardGiftProduct(ProductShopCart product){
  return Column(
    children: [
      sliderCardOffer(product,),
      Align(
          alignment: Alignment.centerRight,
          child: sliderProductGift(product.offer!.promotionProducts))
    ],
  );
}

Widget sliderCardOffer(ProductShopCart product){
  return Container(
    height: 160,
    child: CarouselSlider.builder(
      itemCount: product.offer==null?0:product.offer!.baseProducts!.length,
      itemBuilder: (_, int itemIndex, int pageViewIndex) =>
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: itemOfferCart(product, product.offer!.baseProducts![itemIndex])),
      options: CarouselOptions(
          autoPlay: false,
      ),
    ),
  );
}

Widget listProductsCheckOut(List<PackagesProvider>? packagesProvider) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount:packagesProvider == null
          ? 0
          : packagesProvider.length,
      itemBuilder: (_, int index) {
        return cardListProductsCheckOut(packagesProvider![index]);
      },
    ),
  );
}
