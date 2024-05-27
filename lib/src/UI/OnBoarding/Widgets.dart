import 'package:dots_indicator/dots_indicator.dart';
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
        color: CustomColorsAPP.blackLetter,
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
              color: CustomColorsAPP.blueActiveDots,
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


Widget customBoxPassword(Color color ,String hintText,bool validatePassword, String icPadlock, String icPadlockTwo,
    TextEditingController passwordController,bool obscureTextPass, Function validatePwdLogin,Function showPassword) {

  return Container(
    height: 52,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        border: Border.all(color: color, width: 1),
        color: CustomColorsAPP.white),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 25,
              height: 25,
              fit: BoxFit.fill,
              image: validatePassword ? AssetImage(icPadlock) : AssetImage(icPadlockTwo),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 1,
              height: 25,
              color: CustomColorsAPP.gray7.withOpacity(.4),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Container(
                child: TextField(
                  obscureText: obscureTextPass,
                  controller: passwordController,
                  style: TextStyle(fontSize: 16, fontFamily: Strings.fontRegular, color: CustomColorsAPP.blackLetter),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: CustomColorsAPP.gray7.withOpacity(.4), fontSize: 16, fontFamily: Strings.fontRegular,),
                    hintText: hintText,
                  ),
                  onChanged: (value) {
                    validatePwdLogin(value);
                  },
                ),
              ),
            ),
            GestureDetector(
              child: Image(
                width: 35,
                height: 35,
                image: obscureTextPass == false ? AssetImage("Assets/images/ic_showed.png") : AssetImage("Assets/images/ic_show.png"),
              ),
              onTap: () {
                print("ontap");
                showPassword();
                print("ontap $obscureTextPass");
              },
            )
          ],
        ),
      ),
    ),
  );
}

//tour page
Widget dotsIndicator(int position) {
  return DotsIndicator(
    dotsCount: 3,
    position: position,
    decorator: DotsDecorator(
      color: CustomColorsAPP.grayDot,
      activeColor: CustomColorsAPP.redDot,
      size: const Size.square(9.0),
      spacing: EdgeInsets.all(8),
      activeSize: const Size(9.0, 9.0),
      activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
  );
}

Widget firstPageTour(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 45),
      Image(
        width: double.infinity,
        height: 350,
        image: AssetImage("Assets/images/img_tour1.png"),
        fit: BoxFit.cover,
      ),
      const SizedBox(height: 25),
      Container(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              Strings.welcome,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 48, fontFamily: Strings.fontBold, color: CustomColorsAPP.blueTitle),
            ),
            SizedBox(height: 20),
            Text(
              Strings.welcomeDescription,
              style: TextStyle(fontSize: 18, fontFamily: Strings.fontRegular, color: CustomColorsAPP.black1),
              textAlign: TextAlign.center,
            ),
            //SizedBox(height: 20),
          ],
        ),
      ),
    ],
  );
}


Widget secondPageTour(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 45),
      Image(
        width: double.infinity,
        height: 350,
        image: AssetImage("Assets/images/img_tour2.png"),
        fit: BoxFit.cover,
      ),
      const SizedBox(height: 25),
      Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              Strings.titleTour1,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 48, fontFamily: Strings.fontBold, color: CustomColorsAPP.blueTitle),),
            SizedBox(height: 20),
            Text(
              Strings.descTour1,
              style: TextStyle(fontSize: 18, fontFamily: Strings.fontRegular, color: CustomColorsAPP.black1), textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget thirdPageTour(BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 45),
      Image(
        width: double.infinity,
        height: 350,
        image: AssetImage("Assets/images/img_tour3.png"),
        fit: BoxFit.cover,
      ),
      const SizedBox(height: 25),
      Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              Strings.titleTour2,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 48, fontFamily: Strings.fontBold, color: CustomColorsAPP.blueTitle),),
            SizedBox(height: 20),
            Text(
              Strings.descTour2,
              style: TextStyle(fontSize: 18, fontFamily: Strings.fontRegular, color: CustomColorsAPP.black1), textAlign: TextAlign.center,),
            //SizedBox(height: 20),
          ],
        ),
      ),
    ],
  );
}