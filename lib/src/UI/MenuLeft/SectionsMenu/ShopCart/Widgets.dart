import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/GiftCard.dart';
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

import '../../../../Providers/ProviderProducts.dart';

Widget itemProductCart(ProductShopCart product, Function updateQuantity, Function deleteProduct, Function saveProduct) {
  return Column(
    children: [
      Container(
        height: 1,
        width: double.infinity,
        color: CustomColors.grayBackground,
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
                    color: CustomColors.gray7,
                  ),
                ),
                Text(
                  product.reference?.reference ?? '',
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 13,
                    color: CustomColors.blackLetter,
                  ),
                ),
                viewPrice(product),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        if(int.parse(product.qty!)>1)
                          updateQuantity(int.parse(product.qty!)-1,product.reference?.id.toString(),true);
                      },
                      child: containerCustom(Icon(
                        Icons.remove,
                        color: CustomColors.black2,
                      )),
                    ),
                    containerCustom(Text(
                      product.qty??'0',
                      style: TextStyle(
                          fontFamily: Strings.fontBold,
                          fontSize: 15,
                          color: CustomColors.black2),
                    )),
                    InkWell(
                      onTap: (){
                        updateQuantity(int.parse(product.qty!)+1,product.reference?.id.toString(),true);
                        },
                      child: containerCustom(Icon(
                        Icons.add,
                        color: CustomColors.black2,
                      )),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
      Container(
        margin: EdgeInsets.only(top: 10),
        height: 1,
        width: double.infinity,
        color: CustomColors.grayBackground,
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: customButton("ic_save.png", Strings.saveProduct,
                  CustomColors.gray7, (){saveProduct(product.reference?.id.toString(), product.qty, product.id.toString());})),
          Container(
            height: 40,
            width: 1,
            color: CustomColors.grayBackground,
          ),
          Expanded(
              child: customButton("ic_remove.png", Strings.delete,
                  CustomColors.redTour, (){deleteProduct(product.id.toString());})),
        ],
      )
    ],
  );
}

Widget itemOfferCart(ProductShopCart product, ProductOfferCart offer,Function updateQuantity,Function deleteProduct,Function saveProduct) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 1,
        width: double.infinity,
        color: CustomColors.grayBackground,
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        product.offer?.name??'',
        style: TextStyle(
          fontFamily: Strings.fontBold,
          fontSize: 12,
          color: CustomColors.blackLetter,
        ),
      ),
      SizedBox(
        height: 2,
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
                  image: NetworkImage(offer.reference?.images?[0].url??''),
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
                    color: CustomColors.gray7,
                  ),
                ),
                Text(
                  offer.reference?.reference ?? '',
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 13,
                    color: CustomColors.blackLetter,
                  ),
                ),
                viewPriceOffer(offer),
                //update Quantity
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        if(int.parse(product.qty!)>1)
                          updateQuantity(int.parse(product.qty!)-1,offer.id.toString(),false);
                      },
                      child: containerCustom(Icon(
                        Icons.remove,
                        color: CustomColors.black2,
                      )),
                    ),
                    containerCustom(Text(
                      product.qty??'0',
                      style: TextStyle(
                          fontFamily: Strings.fontBold,
                          fontSize: 15,
                          color: CustomColors.black2),
                    )),
                    InkWell(
                      onTap: ()=>updateQuantity(int.parse(product.qty!)+1,offer.id.toString(),false),
                      child: containerCustom(Icon(
                        Icons.add,
                        color: CustomColors.black2,
                      )),
                    )
                  ],
                ),
                SizedBox(height: 5),
              ],
            ),
          )
        ],
      ),
      Container(
        height: 1,
        width: double.infinity,
        color: CustomColors.grayBackground,
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 40,
            width: 1,
            color: CustomColors.grayBackground,
          ),
          Container(
            width: 100,
              child: customButton("ic_remove.png", Strings.delete, CustomColors.redTour, (){deleteProduct(product.id.toString());})),
        ],
      )
    ],
  );
}

Widget itemGiftCart(ProductShopCart product,GiftCard? giftCard,Function updateQuantity,Function deleteProduct) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
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
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Text(
            giftCard?.name??'',
            style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 12,
              color: CustomColors.blackLetter,
            ),
          ),
          Row(
            children: [
              Container(
                width: 130,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Image.asset("Assets/images/ic_giftcard.png")),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatMoney(giftCard?.total??'0'),
                      style: TextStyle(
                        fontFamily: Strings.fontBold,
                        fontSize: 13,
                        color: CustomColors.orange,
                      ),
                    ),

                    Row(
                      children: [
                        InkWell(
                          onTap: (){
                            if(int.parse(product.qty!)>1)
                              updateQuantity(int.parse(product.qty!)-1,giftCard!.id.toString());
                          },
                          child: containerCustom(Icon(
                            Icons.remove,
                            color: CustomColors.black2,
                          )),
                        ),
                        containerCustom(Text(
                          product.qty??'0',
                          style: TextStyle(
                              fontFamily: Strings.fontBold,
                              fontSize: 15,
                              color: CustomColors.black2),
                        )),
                        InkWell(
                          onTap: ()=>updateQuantity(int.parse(product.qty!)+1,giftCard!.id.toString()),
                          child: containerCustom(Icon(
                            Icons.add,
                            color: CustomColors.black2,
                          )),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 100,
                child: customButton("ic_remove.png", Strings.delete,
                    CustomColors.redTour, (){deleteProduct(product.id.toString());}),
              ),
            ],
          )
        ],
      ),
    ),
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
            color: CustomColors.gray7,
          ),
        ),
        SizedBox(height: 8,),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5)
              ),
              border: Border.all(
                  color: CustomColors.gray2,
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
                          color: CustomColors.gray7,
                        ),
                      ),
                      Text(
                        reference.reference ?? '',
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 13,
                          color: CustomColors.blackLetter,
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
    child:CarouselSlider.builder(
      itemCount: promotionProducts==null?0:promotionProducts.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          itemOfferProductGift(promotionProducts![itemIndex].reference),
      options: CarouselOptions(
        viewportFraction: 1.0,
        enableInfiniteScroll: false
      ),
    ),
  );
}

Widget itemCardGiftProduct(ProductShopCart product,Function updateQuantity,Function deleteProduct,Function saveProduct){
  return Column(
    children: [
      sliderCardOffer(product, updateQuantity, deleteProduct, saveProduct),
      Align(
        alignment: Alignment.centerRight,
          child: sliderProductGift(product.offer!.promotionProducts))
    ],
  );
}

Widget sliderCardOffer(ProductShopCart product,Function updateQuantity,Function deleteProduct,Function saveProduct){
  return Container(
    height: 195,
    child:CarouselSlider.builder(
      itemCount: product.offer==null?0:product.offer!.baseProducts!.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: itemOfferCart(product, product.offer!.baseProducts![itemIndex], updateQuantity, deleteProduct, saveProduct),
          ),
      options: CarouselOptions(
          viewportFraction: 1.0,
          enableInfiniteScroll: false
      ),
    ),
  );
}

Widget itemProductSave(ProductShopCart product,Function addCart,Function deleteProduct) {
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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
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
                    isImageYoutube(product.reference?.images?[0].url??'', FadeInImage(
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
                        color: CustomColors.gray7,
                      ),
                    ),
                    Text(
                      product.reference?.reference ?? '',
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 13,
                        color: CustomColors.blackLetter,
                      ),
                    ),
                    viewPrice(product),
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 1,
            width: double.infinity,
            color: CustomColors.grayBackground,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: customButton("ic_shopping_white.png", Strings.addCartShop,
                      CustomColors.gray7, (){addCart(int.parse(product.qty!),product.reference?.id.toString());})),
              Container(
                height: 40,
                width: 1,
                color: CustomColors.grayBackground,
              ),
              Expanded(
                  child: customButton("ic_remove.png", Strings.delete,
                      CustomColors.redTour, (){deleteProduct(product.reference?.id.toString());})),
            ],
          )
        ],
      ),
    ),
  );
}

Widget viewPrice(ProductShopCart product) {
  return product.reference?.totalProductOffer != null
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: product.reference?.totalProductOffer?.status??false,
              child: Text(
                formatMoney(
                    product.reference?.totalProductOffer?.price ?? '0'),
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  fontFamily: Strings.fontBold,
                  color: CustomColors.gray7,
                ),
              ),
            ),
            Text(
              formatMoney(product.reference?.price ?? '0'),
              style: TextStyle(
                fontFamily: Strings.fontBold,
                color: CustomColors.orange,
              ),
            )
          ],
        )
      : Text(
          formatMoney(product.reference?.price ?? '0'),
          style: TextStyle(
            fontFamily: Strings.fontBold,
            color: CustomColors.orange,
          ),
        );
}

Widget viewPriceOffer(ProductOfferCart offer) {
  return offer.reference != null
      ? Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        formatMoney(offer.reference?.price ??
            '0'),
        style: TextStyle(
          fontFamily: Strings.fontBold,
          color: CustomColors.orange,
        ),
      )
    ],
  )
      : Text(
    formatMoney('0'),
    style: TextStyle(
      fontFamily: Strings.fontBold,
      color: CustomColors.orange,
    ),
  );
}

Widget containerCustom(Widget item) {
  return Container(
    width: 35,
    height: 35,
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: CustomColors.gray9,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    ),
    child: Center(
      child: item,
    ),
  );
}

Widget customButton(String icon, String text, Color colorText, Function action) {
  return InkWell(
    onTap: action as void Function()?,
    child: Container(
      width: double.infinity,
      height: 40,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "Assets/images/$icon",
              width: 25,
              color: colorText,
            ),
            Text(
              text,
              style:
                  TextStyle(fontFamily: Strings.fontRegular, color: colorText),
            )
          ],
        ),
      ),
    ),
  );
}

Widget cardListProductsByProvider(PackagesProvider provider,Function updateQuantity,Function delete,bool hasPrincipalAddress, Function save,ProviderProducts providerProducts) {
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
        iconColor: CustomColors.gray7,
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
                      color: CustomColors.blackLetter),
                ),
                Text(
                  Strings.provider,
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.gray7),
                ),
              ],
            ),
            Visibility(
              visible: false,
              child: Container(
                decoration: BoxDecoration(
                    color: CustomColors.blue.withOpacity(.7),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Strings.moreView,
                    style: TextStyle(
                        fontFamily: Strings.fontBold, color: CustomColors.blue),
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
              //TODO: Change position
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                        text: Strings.total + ' ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.gray7,
                          fontSize: 13,
                        ),
                      ),
                      TextSpan(
                        text: formatMoney((provider.cart?.total??0).toString()),
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          color: CustomColors.gray7,
                          fontSize: 13,
                        ),
                      ),
                    ]
                ),
              ),
              Visibility(
                visible: hasPrincipalAddress,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: Strings.delivery2 + ' ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColors.gray7,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: (provider.provider?.minPurchase??0) > 0
                                  ? (provider.freeShipping??0) == 0
                                  ? Strings.free
                                  : formatMoney((provider.shippingValue??0).toString())
                                  : formatMoney((provider.shippingValue??0).toString()),
                              style: TextStyle(
                                fontFamily: provider.freeShipping != 0
                                    ? Strings.fontRegular
                                    : Strings.fontBold,
                                color: CustomColors.gray7,
                                fontSize: 13,
                              ),
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !hasPrincipalAddress,
                child: Text(
                  Strings.principalConfigured,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: Strings.fontBold
                  ),
                ),
              ),
              SizedBox(height: 5),
              Visibility(
                visible: (provider.provider?.minPurchase??0) > 0 && (provider.freeShipping != 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.add + formatMoney((provider.freeShipping??0).toString()) + Strings.addTxt,
                      style: TextStyle(
                        fontSize: 13,
                        color: CustomColors.blueOne,
                        fontFamily: Strings.fontRegular,
                      ),
                    ),
                    SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: (provider.provider?.minPurchase??0) > 0
                          ? (provider.cart?.total??0) / (provider.provider?.minPurchase??0) 
                          : 0,
                      minHeight: 3,
                      color: CustomColors.blue6,
                      backgroundColor: CustomColors.gray9,
                    )
                  ],
                ),
              ),
              SizedBox(height: 8,),
              Visibility(
                visible:providerProducts?.limitedQuantityError == true ? false :true,
                child: Text(
                  Strings.quantityAvailable + " ${provider.products![0].reference?.qty != null ? provider.products![0].reference?.qty : provider.products?[0].offer?.promotionProducts?[0].reference?.qty}",
                  style: TextStyle(fontSize: 13, color: CustomColors.blue5, fontFamily: Strings.fontMedium,),
                ),
              ),
              //providerProducts?.units
              Visibility(
                visible:providerProducts?.limitedQuantityError == true ? true :false,
                child: Container(
                  decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(15),),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${Strings.youCanOnlyCarry} ${provider.products![0].reference?.qty != null ? provider.products![0].reference?.qty : provider.products?[0].offer?.promotionProducts?[0].reference?.qty} unidades",
                      style: TextStyle(fontSize: 14, fontFamily: Strings.fontRegular, color: CustomColors.blueDarkSplash,),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8,),

              listProducts(provider.products, updateQuantity,delete,save)
            ],
          )
        ],
      ),
    ),
  );
}

Widget listGiftCard(List<ProductShopCart>? ltsProducts, Function updateQuantity, Function delete) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ltsProducts == null ? 0 : ltsProducts.length,
      itemBuilder: (_, int index) {
      return itemGiftCart(ltsProducts![index], ltsProducts[index].giftCard, updateQuantity, delete);
      },
    ),
  );
}

Widget listProducts(List<ProductShopCart>? ltsProducts, Function updateQuantity, Function delete, Function save) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ltsProducts == null ? 0 : ltsProducts.length,
      itemBuilder: (BuildContext context, int index) {
        if(ltsProducts![index].reference!=null){
          return itemProductCart(ltsProducts[index], updateQuantity,delete,save);
        }else{
          return itemCardGiftProduct(ltsProducts[index], updateQuantity, delete, save);
        }

      },
    ),
  );
}

Widget itemSubtotalCart(TotalCart? total, Function openProductsSave, Function openCheckOut){
  return Column(
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
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
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.subtotal,
                    style: TextStyle(
                      fontFamily: Strings.fontBold,
                      fontSize: 16,
                      color: CustomColors.blue5,
                    ),
                  ),
                  Text(
                    formatMoney(total?.subtotal??'0'),
                    style: TextStyle(
                      fontFamily: Strings.fontBold,
                      fontSize: 16,
                      color: CustomColors.blue5,
                    ),
                  ),
                ],
              ),
              customDivider(),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: ()=>openProductsSave(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: CustomColors.blue5,
                       shape: BoxShape.circle
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                        child: Image.asset("Assets/images/ic_box.png",height: 40,),
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                      child: btnCustomSize(47,Strings.makePurchase,CustomColors.redDot,Colors.white,openCheckOut))
                ],
              )
            ],
          ),
        ),
      ),

    ],
  );
}


