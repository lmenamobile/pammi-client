import 'package:flutter/material.dart';
import 'package:wawamko/src/Animations/animate_button.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Widgets/Dialogs/DialogCustomAlert.dart';

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

Widget btnCustom(String nameButton, Color colorBackground, Color colorText,Function action){
  return Container(
    width: 200,
    height: 40,
    child: AnimateButton(
      pressEvent: action,
      body: Container(
        decoration: BoxDecoration(
            color: colorBackground,
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Center(
          child: Text(
            nameButton,
            style: TextStyle(
              fontFamily: Strings.fontMedium,
              color: colorText,
            ),
          ),
        ),
      ),
    ),
  );
}

Future<bool> showCustomAlertDialog(BuildContext context,String title,String msg) async {
  bool state = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => DialogCustomAlert(title: title, msgText: msg),
  );
  return state;
}