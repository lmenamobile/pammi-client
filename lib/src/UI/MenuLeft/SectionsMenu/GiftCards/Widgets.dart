import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget categoryItem(Category category){
  return Container(
    margin: EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      color: CustomColorsAPP.grayBackground
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: convertColor(category.color!),
                    boxShadow: [
                      BoxShadow(
                          color: convertColor(category.color!).withOpacity(.4),
                          blurRadius: 7,
                          offset: Offset(2, 3))
                    ]),
                child: Center(
                  child: FadeInImage(
                    height: 30,
                    fit: BoxFit.fill,
                    image: NetworkImage(category.image!),
                    placeholder: AssetImage("Assets/images/spinner.gif"),
                    imageErrorBuilder: (_,__,___){
                      return Container();
                    },
                  ),
                ),
              ),
              SizedBox(width: 15,),
              Text(
                category.category??'',
                style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  color: CustomColorsAPP.blackLetter
                ),
              ),
            ],
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: category.isSelected?CustomColorsAPP.orange:Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: category.isSelected?CustomColorsAPP.orange:CustomColorsAPP.gray7)
            ),
          )
        ],
      ),
    ),
  );
}