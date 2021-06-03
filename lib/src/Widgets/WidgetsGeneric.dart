import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wawamko/src/Animations/animate_button.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/Dialogs/DialogCustomAlert.dart';

Widget titleBar(String title, String icon, Function action) {
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
            onTap: () => action(),
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

Widget btnCustom(String nameButton, Color colorBackground, Color colorText,
    Function action) {
  return Container(
    width: 200,
    height: 40,
    child: AnimateButton(
      pressEvent: action,
      body: Container(
        decoration: BoxDecoration(
            color: colorBackground,
            borderRadius: BorderRadius.all(Radius.circular(5))),
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

Widget btnCustomIcon(String asset,String nameButton, Color colorBackground, Color colorText,
    Function action) {
  return Container(
    height: 45,
    child: AnimateButton(
      pressEvent: action,
      body: Container(
        decoration: BoxDecoration(
            color: colorBackground,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nameButton,
                  style: TextStyle(
                    fontFamily: Strings.fontMedium,
                    color: colorText,
                  ),
                ),
                SizedBox(width: 10,),
                Image.asset("Assets/images/$asset",width: 20,)
              ],
            ),
        ),
      ),
    ),
  );
}

Widget btnCustomSize(double height, String nameButton, Color colorBackground,
    Color colorText, Function action) {
  return Container(
    width: double.infinity,
    height: height,
    child: AnimateButton(
      pressEvent: action,
      body: Container(
        decoration: BoxDecoration(
            color: colorBackground,
            borderRadius: BorderRadius.all(Radius.circular(5))),
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

Widget customTextFieldIcon(
    String icon,
    bool isActive,
    String hintText,
    TextEditingController controller,
    TextInputType inputType,
    List<TextInputFormatter> formatter) {
  return Container(
    margin: EdgeInsets.only(bottom: 20),
    padding: EdgeInsets.only(left: 10),
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: CustomColors.gray.withOpacity(.3), width: 1),
        color: CustomColors.white),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          width: 35,
          height: 35,
          fit: BoxFit.fill,
          image: AssetImage("Assets/images/$icon"),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 1,
          height: 25,
          color: CustomColors.grayLetter.withOpacity(.4),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            child: TextField(
              enabled: isActive,
              inputFormatters: formatter,
              keyboardType: inputType,
              controller: controller,
              style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  color: CustomColors.blackLetter),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: CustomColors.grayLetter.withOpacity(.4),
                  fontFamily: Strings.fontRegular,
                ),
                hintText: hintText,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

Widget alertMessageWithActions(String titleAlert, String image,
    String textAlert, Function action, Function actionNegative) {
  return WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(19)),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      "Assets/images/$image",
                      fit: BoxFit.fill,
                      height: 50,
                      width: 50,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      titleAlert,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: Strings.fontBold,
                          color: CustomColors.blackLetter,
                          fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      textAlert,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          color: CustomColors.grayLetter,
                          fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: btnCustomSize(
                              35,
                              Strings.btnYes,
                              CustomColors.blueSplash,
                              CustomColors.white,
                              action),
                          width: 100,
                        ),
                        Container(
                          child: btnCustomSize(
                              35,
                              Strings.btnNot,
                              CustomColors.gray2,
                              CustomColors.blackLetter,
                              actionNegative),
                          width: 100,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<bool> showCustomAlertDialog(
    BuildContext context, String title, String msg) async {
  bool state = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) =>
        DialogCustomAlert(title: title, msgText: msg),
  );
  return state;
}

Future<bool> showAlertActions(BuildContext context, String title, String msg,
    String asset, Function positive, Function negative) async {
  bool state = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) =>
        alertMessageWithActions(title, asset, msg, positive, negative),
  );
  return state;
}
