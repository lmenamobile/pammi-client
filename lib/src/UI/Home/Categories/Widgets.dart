import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Models/SubCategory.dart';
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
                      placeholder: AssetImage(""),
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
    onTap: ()=>openProductsSubcategory(),
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

Widget itemProductCategory(){
  return Container(
    width: 160,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          width: 100,
          height: 100,
          child: FadeInImage(
            fit: BoxFit.fill,
            image: NetworkImage("https://assets.adidas.com/images/h_840,f_auto,q_auto:sensitive,fl_lossy/4c70105150234ac4b948a8bf01187e0c_9366/Tenis_Samba_OG_Negro_B75807_01_standard.jpg"),
            placeholder: AssetImage(""),
          ),
        )
      ],
    ),
  );
}