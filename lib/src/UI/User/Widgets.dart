
import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget itemLabelReferred(){
  return Container(
      decoration: BoxDecoration(
        color: CustomColorsAPP.blueSplash,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Strings.linkEntrepreneur,
          style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 13,
              color: Colors.white),
        ),
        SizedBox(height: 5,),
        Text(
          Strings.shareYourCode,
          style: TextStyle(
              fontFamily: Strings.fontRegular,
              fontSize: 13,
              color: Colors.white),
        )
      ],
    ),
  );
}