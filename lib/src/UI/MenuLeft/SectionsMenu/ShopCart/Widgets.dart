import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/ShopCart/PackageProvider.dart';
import 'package:wawamko/src/Models/ShopCart/ProductShopCart.dart';
import 'package:wawamko/src/Models/ShopCart/TotalCart.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/ExpansionWidget.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

Widget itemProductCart(ProductShopCart product) {
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
                child: FadeInImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(product?.reference?.images[getRandomPosition(product?.reference?.images?.length)].url),
                  placeholder: AssetImage("Assets/images/spinner.gif"),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product?.reference?.brandAndProduct?.brandProvider?.brand?.brand??'',
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 12,
                    color: CustomColors.gray7,
                  ),
                ),
                Text(
                  product?.reference?.reference ?? '',
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
                    containerCustom(Icon(
                      Icons.remove,
                      color: CustomColors.black2,
                    )),
                    containerCustom(Text(
                      product?.qty??'0',
                      style: TextStyle(
                          fontFamily: Strings.fontBold,
                          fontSize: 15,
                          color: CustomColors.black2),
                    )),
                    containerCustom(Icon(
                      Icons.add,
                      color: CustomColors.black2,
                    ))
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
                  CustomColors.gray7, null)),
          Container(
            height: 40,
            width: 1,
            color: CustomColors.grayBackground,
          ),
          Expanded(
              child: customButton("ic_remove.png", Strings.deleteProduct,
                  CustomColors.redTour, null)),
        ],
      )
    ],
  );
}

Widget viewPrice(ProductShopCart product) {
  return product?.reference?.totalProductOffer != null
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatMoney(
                  product?.reference?.totalProductOffer?.price ??
                      '0'),
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontFamily: Strings.fontBold,
                color: CustomColors.gray7,
              ),
            ),
            Text(
              formatMoney(product?.reference?.price ?? '0'),
              style: TextStyle(
                fontFamily: Strings.fontBold,
                color: CustomColors.orange,
              ),
            )
          ],
        )
      : Text(
          formatMoney(product?.reference?.price ?? '0'),
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

Widget customButton(
    String icon, String text, Color colorText, Function action) {
  return InkWell(
    onTap: () => action(),
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

Widget cardListProductsByProvider(PackagesProvider provider) {
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
                  provider?.provider?.businessName ?? '',
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

Widget listProducts(List<ProductShopCart> ltsProducts) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ltsProducts == null ? 0 : ltsProducts.length,
      itemBuilder: (BuildContext context, int index) {
        return itemProductCart(ltsProducts[index]);
      },
    ),
  );
}

Widget itemSubtotalCart(TotalCart total){
  return Container(
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
                  fontSize: 15,
                  color: CustomColors.blackLetter,
                ),
              ),
              Text(
                formatMoney(total?.subtotal??'0'),
                style: TextStyle(
                  fontFamily: Strings.fontBold,
                  fontSize: 15,
                  color: CustomColors.blackLetter,
                ),
              ),
            ],
          ),
          customDivider(),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: CustomColors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                  child: Image.asset("Assets/images/ic_box.png",height: 40,),
                ),
              ),
              SizedBox(width: 20,),
              Expanded(
                  child: btnCustomSize(47,Strings.makePurchase,CustomColors.blueSplash,Colors.white,null))
            ],
          )
        ],
      ),
    ),
  );
}
