import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget itemCheck(Function action,bool isSelect,Widget text){
  return Row(
    children: [
      GestureDetector(
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(5)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(isSelect?"Assets/images/ic_check2.png":"Assets/images/ic_check.png"))),
        ),
        onTap: ()=>action(),
      ),
      SizedBox(width: 10),
      Expanded(
        child: text,
      )
    ],
  );
}

Widget termsAndConditions(String url){
  return RichText(
    textAlign: TextAlign.left,
    text: TextSpan(
      style: TextStyle(
        height: 1.5,
        fontSize: 12,
        color: CustomColors.blackLetter,
      ),
      children: <TextSpan>[
        TextSpan(
            text: Strings.termsAndPolitics,
            style: TextStyle(
              fontFamily: Strings.fontRegular,
            )),
        TextSpan(
          text: Strings.terms,
          style: TextStyle(
              fontFamily: Strings.fontRegular,
              color: CustomColors.blueActiveDots,
              decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () => launch(url),
        ),
       /* TextSpan(
            text: Strings.politicsText,
            style: TextStyle(
              fontFamily: Strings.fontRegular,
            )),*/
       /* TextSpan(
          text: Strings.politics,
          style: TextStyle(
              fontFamily: Strings.fontRegular,
              color: CustomColors.blueActiveDots,
              decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () => launch(
                "https://pamii-dev.s3.us-east-2.amazonaws.com/wawamko/system/Cliente_Politica_De_Tratamiento_De_Datos_Personales.pdf"),
        ),*/
      ],
    ),
  );
}