import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget titleBar(String title,String icon,Function action){
  return Container(
    width: double.infinity,
    height: 70,
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("Assets/images/ic_header_red.png"),
            fit: BoxFit.fill)),
    child: Stack(
      children: <Widget>[
        Positioned(
          left: 15,
          top: 15,
          child: GestureDetector(
            child: Image(
              width: 40,
              height: 40,
              color: Colors.white,
              image: AssetImage("Assets/images/$icon"),
            ),
            onTap: ()=>action(),
          ),
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
      ],
    ),
  );
}

Widget emptyView(String image, String title, String text) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
          fit: BoxFit.fill,
          width: 200,
          image: AssetImage(image),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 22,
                    color: CustomColors.blueGray),
              ),
              SizedBox(height: 5),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: CustomColors.blueGray),
              ),
              SizedBox(height: 23),
            ],
          ),
        )
      ],
    ),
  );
}