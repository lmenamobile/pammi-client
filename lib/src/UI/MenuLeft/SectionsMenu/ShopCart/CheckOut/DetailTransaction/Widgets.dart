
import 'package:flutter/material.dart';

import 'package:wawamko/src/Models/ShopCart/PackageProvider.dart';
import 'package:wawamko/src/Models/ShopCart/ProductShopCart.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Widgets/ExpansionWidget.dart';

Widget containerText(String text) {
  return Container(
    decoration: BoxDecoration(
        color: AppColors.whiteBackGround,
        borderRadius: BorderRadius.all(Radius.circular(5))),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: Strings.fontBold,
            fontSize: 22,
            color: AppColors.blackLetter),
      ),
    ),
  );
}

Widget imageAvatar(String icon) {
  return Container(
    width: 60,
    height: 60,
    decoration:
        BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
      BoxShadow(
          color: Colors.black.withOpacity(.4),
          blurRadius: 7,
          offset: Offset(2, 3))
    ]),
    child: Center(
      child: Image.asset("Assets/images/$icon"),
    ),
  );
}

Widget cardItems(PackagesProvider provider) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          provider.provider?.businessName ?? '',
          style: TextStyle(
              fontFamily: Strings.fontBold, color: AppColors.gray7),
        ),
        SizedBox(
          height: 8,
        ),
        //listProducts(provider.products)
      ],
    ),
  );
}

/*Widget itemProduct(Reference? reference) {
  return Container(
    margin: EdgeInsets.only(bottom: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reference?.reference ?? '',
          style: TextStyle(
              fontFamily: Strings.fontRegular, color: AppColors.gray7),
        ),
        Text(
          formatMoney(reference?.price ?? '0'),
          style: TextStyle(
              fontFamily: Strings.fontRegular, color: AppColors.gray7),
        ),
      ],
    ),
  );
}*/

/*Widget listProducts(List<ProductShopCart>? ltsProducts) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ltsProducts == null ? 0 : ltsProducts.length,
      itemBuilder: (_, int index) {
        if (ltsProducts![index].reference != null) {
          return itemProduct(ltsProducts[index].reference);
        } else {
          return itemProduct(
              ltsProducts[index].offer!.promotionProducts![0].reference);
        }
      },
    ),
  );
}*/

Widget listProductsOrder(List<PackagesProvider>? packagesProvider) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: packagesProvider == null ? 0 : packagesProvider.length,
      itemBuilder: (_, int index) {
        return cardItems(packagesProvider![index]);
      },
    ),
  );
}

Widget containerExpansion(List<PackagesProvider>? packagesProvider) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: ExpansionWidget(
        initiallyExpanded: true,
        iconColor: AppColors.gray7,
        title: Container(
          decoration: BoxDecoration(
              color: AppColors.whiteBackGround,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.assignment,color: AppColors.gray7),
                SizedBox(width: 8,),
                Text(
                  Strings.buys,
                  style: TextStyle(
                      fontFamily: Strings.fontBold, color: AppColors.gray7),
                ),
              ],
            ),
          ),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [listProductsOrder(packagesProvider)],
          )
        ],
      ),
    ),
  );
}
