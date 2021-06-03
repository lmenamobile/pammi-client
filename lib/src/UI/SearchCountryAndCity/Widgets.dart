
import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget boxSelect(){
  return  Center(
    child: Container(
      height: 35,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: CustomColors.blueSplash, width: 1.0),
          bottom: BorderSide(color:  CustomColors.blueSplash, width: 1.0),
        ),
      ),
    ),
  );
}