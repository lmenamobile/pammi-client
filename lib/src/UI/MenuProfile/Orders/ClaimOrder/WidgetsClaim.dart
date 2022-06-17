
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget itemReasonClaim(){
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
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
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              Strings.reasonClaim,
              style: TextStyle(
                  color: Colors.black, fontFamily: Strings.fontMedium,fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buttonNext(){
  return Container(
    decoration: BoxDecoration(
        color: CustomColors.blue,
      borderRadius: BorderRadius.all(Radius.circular(8))
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
      child: Icon(Icons.arrow_forward,color: Colors.white,),
    ),
  );
}