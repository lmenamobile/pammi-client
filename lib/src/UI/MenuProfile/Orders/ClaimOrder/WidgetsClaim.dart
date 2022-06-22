
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget itemReasonClaim(String label,String labelSelected){
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      boxShadow: [
        BoxShadow(
          color: label!=labelSelected?Colors.grey.withOpacity(0.2):CustomColors.blue.withOpacity(.3),
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
              label,
              style: TextStyle(
                  color: Colors.black, fontFamily: Strings.fontMedium,fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget headerClaim(String title,String subtitle){
  return Container(
    width: double.infinity,
    height: 180,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10
            )
        )
    ),
    child: Center(
      child: Column(
        mainAxisSize:MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
                color: CustomColors.blackLetter, fontFamily: Strings.fontMedium,fontSize: 16),
          ),
          Text(
            subtitle,
            style: TextStyle(
                color: CustomColors.blue, fontFamily: Strings.fontMedium,fontSize: 16),
          ),
        ],
      ),
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