import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

import '../Widgets.dart';

Widget itemProductCatalog(Product product){
  return Container(
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
            child: product.references![0].images!.isEmpty?Image.asset("Assets/images/spinner.gif"):FadeInImage(
              fit: BoxFit.fill,
              image: NetworkImage(product.references?[0].images?[0].url??''),
              placeholder: AssetImage("Assets/images/spinner.gif"),
              imageErrorBuilder: (_,__,___){
                return Container();
              },
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
  );
}