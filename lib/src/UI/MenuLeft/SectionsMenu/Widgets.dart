import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Models/Product/ProductFavorite.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget itemProductFavorite(ProductFavorite  product, Function openDetail,Function removeFavorite){
  return InkWell(
    onTap: ()=>openDetail(product.reference?.brandAndProduct?.id.toString()),
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
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: product.reference!.images!.isEmpty?Image.asset("Assets/images/spinner.gif"):
                  isImageYoutube(product.reference?.images?[0].url??'',FadeInImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(product.reference?.images?[0].url??''),
                    placeholder: AssetImage("Assets/images/spinner.gif"),
                  )),
                ),
                customDivider(),
                Align(
                  alignment: Alignment.centerLeft,
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
                        product.reference?.reference??'',
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 13,
                          color: CustomColors.blackLetter,
                        ),
                      ),
                      Text(
                        formatMoney( product.reference?.price??'0'),
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
            Positioned(
                top: 3,
                right: 3,
                child: favorite(true,product.reference?.id.toString()??'',removeFavorite))
          ],
        ),
      ),
    ),
  );
}

Widget favorite(bool isFavorite,String idReference,Function callFavorite){
  return InkWell(
    onTap: ()=>callFavorite(idReference),
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: isFavorite?Colors.transparent:CustomColors.gray5),
          boxShadow: [
            BoxShadow(
              color: isFavorite?CustomColors.redTour.withOpacity(0.2):CustomColors.gray5.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ]
      ),
      child: Center(
        child: Icon(
          Icons.favorite,
          size: 20,
          color: isFavorite?CustomColors.redTour:CustomColors.gray5,
        ),
      ),
    ),
  );
}