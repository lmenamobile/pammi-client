import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Strings.dart';

Widget titleBarWithDoubleAction(String title, String icon,String iconTwo, Function action,Function actionTwo) {
  return Container(
    width: double.infinity,
    height: 70,
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("Assets/images/ic_header_red.png"),
            fit: BoxFit.fill)),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          child: Image(
            width: 40,
            height: 40,
            color: Colors.white,
            image: AssetImage("Assets/images/$icon"),
          ),
          onTap: () => action(),
        ),
        Center(
          child: Container(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: Strings.fontRegular,
                  color: Colors.white),
            ),
          ),
        ),
        GestureDetector(
          child: Image(
            width: 40,
            height: 40,
            color: Colors.white,
            image: AssetImage("Assets/images/$iconTwo"),
          ),
          onTap: () => action(),
        ),
      ],
    ),
  );
}