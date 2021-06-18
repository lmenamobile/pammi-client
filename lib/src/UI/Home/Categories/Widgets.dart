import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Models/SubCategory.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget itemCategoryRow(Category category, Function openSubcategory){
  return InkWell(
    onTap: ()=>openSubcategory(category),
    child: Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(9)),
        border: Border.all(color: CustomColors.grayBackground,width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: convertColor(category.color),
                      boxShadow: [
                        BoxShadow(
                            color: convertColor(category.color).withOpacity(.4),
                            blurRadius: 7,
                            offset: Offset(2, 3))
                      ]),
                  child: Center(
                    child: FadeInImage(
                      height: 25,
                      fit: BoxFit.fill,
                      image: NetworkImage(category.image),
                      placeholder: AssetImage("Assets/images/spinner.gif"),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  category.category,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 13,
                    color: CustomColors.blackLetter,
                  ),
                )
              ],
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: CustomColors.gray4,
            )
          ],
        ),
      ),
    ),
  );
}

Widget itemSubCategoryRow(SubCategory subCategory, Function openProductsSubcategory){
  return InkWell(
    onTap: ()=>openProductsSubcategory(subCategory),
    child: Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(9)),
        border: Border.all(color: CustomColors.grayBackground,width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                subCategory.subcategory,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  fontSize: 13,
                  color: CustomColors.blackLetter,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: CustomColors.gray4,
            )
          ],
        ),
      ),
    ),
  );
}

Widget itemProductCategory(Product product, Function openDetail){
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
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: FadeInImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(product?.references[0]?.images[0]?.url),
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
                        product?.brandProvider?.brand?.brand??'',
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 12,
                          color: CustomColors.grayLetter,
                        ),
                      ),
                      Text(
                        product?.references[0]?.reference??'',
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 13,
                          color: CustomColors.blackLetter,
                        ),
                      ),
                      Text(
                        formatMoney( product?.references[0]?.price??'0'),
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
                child: favorite(true))
          ],
        ),
      ),
    ),
  );
}

Widget favorite(bool isFavorite){
  return Container(
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
  );
}