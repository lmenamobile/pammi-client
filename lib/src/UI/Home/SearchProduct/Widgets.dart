import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

import '../Widgets.dart';

Widget boxSearch(TextEditingController searchController, Function searchElements) {
  return Container(
    width: double.infinity,
    height: 40,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: CustomColors.greyBorder),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Image(
            height: 20,
            color: CustomColors.gray7,
            image: AssetImage("Assets/images/ic_seeker.png"),
          ),
        ),
        Expanded(
          child: TextField(
            controller: searchController,
            onSubmitted: (value){
              searchElements(value);
            },
            textInputAction: TextInputAction.search,
            style: TextStyle(
                fontFamily: Strings.fontRegular,
                fontSize: 15,
                color: CustomColors.gray7),
            decoration: InputDecoration(
                hintText: Strings.search,
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: CustomColors.gray7)),
          ),
        )
      ],
    ),
  );
}

Widget itemProductSearch(Product product, Function openDetail){
  return InkWell(
    onTap: ()=>openDetail(product),
    child: Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
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
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              child: FadeInImage(
                fit: BoxFit.fill,
                image: NetworkImage(product.references?[0].images?[0].url??''),
                placeholder: AssetImage("Assets/images/spinner.gif"),
              ),
            ),
            customDivider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brandProvider?.brand?.brand??'',
                    style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 12,
                      color: CustomColors.gray7,
                    ),
                  ),
                  Text(
                    product.references?[0].reference??'',
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 13,
                      color: CustomColors.blackLetter,
                    ),
                  ),
                  Text(
                    formatMoney( product.references?[0].price??'0'),
                    style: TextStyle(
                      fontFamily: Strings.fontBold,
                      color: CustomColors.orange,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
