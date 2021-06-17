import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Models/Address/GetAddress.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Models/Country.dart';
import 'package:wawamko/src/Models/Support/QuestionsModel.dart'
    as questionModel;
import 'package:wawamko/src/UI/SearchCountryAndCity/SelectStates.dart';
import 'package:wawamko/src/UI/ProductsCampaigns.dart';
import 'package:wawamko/src/UI/detailProduct.dart';
import 'package:wawamko/src/UI/SearchCountryAndCity/selectCity.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';

import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/expancion_widget.dart';

GlobalVariables globalVariables = GlobalVariables();
NotifyVariablesBloc notifyVariables;



Widget customBoxEmailLogin(TextEditingController emailController,
    NotifyVariablesBloc notifyVariables, Function refresh) {
  return StreamBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(
              color: !notifyVariables.intLogin.validateEmail
                  ? CustomColors.gray.withOpacity(.3)
                  : CustomColors.blueSplash,
              width: 1),
          color: CustomColors.white),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                width: 35,
                height: 35,
                image: !notifyVariables.intLogin.validateEmail
                    ? AssetImage("Assets/images/ic_email.png")
                    : AssetImage("Assets/images/ic_email_blue.png"),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: 1,
                height: 25,
                color: CustomColors.grayLetter.withOpacity(.4),
              ),
              SizedBox(width: 5,),
              Expanded(
                child: Container(
                  child: TextField(
                    controller: emailController,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Strings.fontRegular,
                        color: CustomColors.blackLetter),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: CustomColors.grayLetter.withOpacity(.4),
                        fontSize: 16,
                        fontFamily: Strings.fontRegular,
                      ),
                      hintText: Strings.email,
                    ),
                    onChanged: (value) {
                      if (validateEmail(value)) {
                        notifyVariables.intLogin.validateEmail = true;
                        refresh();
                      } else {
                        notifyVariables.intLogin.validateEmail = false;
                        refresh();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  });
}

Widget customBoxEmailForgotPass(TextEditingController emailController,
    NotifyVariablesBloc notifyVariables, Function refresh) {
  return StreamBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(
              color: !notifyVariables.intForPass.validateEmail
                  ? CustomColors.gray.withOpacity(.3)
                  : CustomColors.blueSplash,
              width: 1),
          color: CustomColors.white),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                width: 35,
                height: 35,
                image: !notifyVariables.intForPass.validateEmail
                    ? AssetImage("Assets/images/ic_email.png")
                    : AssetImage("Assets/images/ic_email_blue.png"),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: 1,
                height: 25,
                color: CustomColors.grayLetter.withOpacity(.4),
              ),
              SizedBox(width: 5,),
              Expanded(
                child: Container(
                  child: TextField(
                    controller: emailController,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Strings.fontRegular,
                        color: CustomColors.blackLetter),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: CustomColors.grayLetter.withOpacity(.4),
                        fontSize: 16,
                        fontFamily: Strings.fontRegular,
                      ),
                      hintText: Strings.email,
                    ),
                    onChanged: (value) {
                      if (validateEmail(value)) {
                        notifyVariables.intForPass.validateEmail = true;
                        refresh();
                      } else {
                        notifyVariables.intForPass.validateEmail = false;
                        refresh();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  });
}

Widget customBoxEmailRegister(TextEditingController emailController,
    NotifyVariablesBloc notifyVariables, Function refresh) {
  return StreamBuilder(
      // stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                  color:  CustomColors.gray.withOpacity(.3),
                  width: 1),
              color: CustomColors.white),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 35,
                    height: 35,
                    image:AssetImage("Assets/images/ic_email_blue.png"),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 1,
                    height: 25,
                    color: CustomColors.grayLetter.withOpacity(.4),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Container(
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
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
                          hintText: Strings.email,
                        ),
                        onChanged: (value) {
                          if (validateEmail(value)) {
                            notifyVariables.intRegister.validateEmail = true;
                            refresh();
                          } else {
                            notifyVariables.intRegister.validateEmail = false;
                            refresh();
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        snapshot.hasError
            ? Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: Text(
                  "Email Invalido example@xxx.com",
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 13,
                      color: CustomColors.red),
                ),
              )
            : Container()
      ],
    );
  });
}

Widget btnCustomRoundedImage(Color backgroungButton, Color textColor,
    String textButton, Function action, BuildContext context, String image) {
  return SpringButton(
    SpringButtonType.OnlyScale,
    Container(
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: backgroungButton),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            textButton,
            style: TextStyle(
                fontSize: 14,
                fontFamily: Strings.fontRegular,
                color: textColor),
          ),
          SizedBox(width: 8),
          Image(
            width: 20,
            height: 20,
            image: AssetImage(image),
          )
        ],
      )),
    ),
    onTapUp: (_) {
      action();
    },
  );
}

Widget btnRoundedCustom(double height,Color backgroungButton, Color textColor, String textButton, Function action) {
  return SpringButton(
    SpringButtonType.OnlyScale,
    Container(
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: backgroungButton),
      child: Center(
        child: Text(
          textButton,
          style: TextStyle(
              fontSize: 13, fontFamily: Strings.fontRegular, color: textColor),
        ),
      ),
    ),
    onTapUp: (_) {
      action();
    },
  );
}

Widget btnCustomRounded(Color backgroungButton, Color textColor,
    String textButton, Function action, BuildContext context) {
  return SpringButton(
    SpringButtonType.OnlyScale,
    Container(
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: backgroungButton),
      child: Center(
        child: Text(
          textButton,
          style: TextStyle(
              fontSize: 16, fontFamily: Strings.fontRegular, color: textColor),
        ),
      ),
    ),
    onTapUp: (_) {
      action();
    },
  );
}

Widget btnCustomRoundedBorder(
    Color backgroungButton,
    Color textColor,
    String textButton,
    Function action,
    BuildContext context,
    Color colorBorder) {
  return SpringButton(
    SpringButtonType.OnlyScale,
    Container(
      height: 45,
      decoration: BoxDecoration(
          border: Border.all(color: colorBorder, width: 1.3),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: backgroungButton),
      child: Center(
        child: Text(
          textButton,
          style: TextStyle(
              fontSize: 16, fontFamily: Strings.fontRegular, color: textColor),
        ),
      ),
    ),
    onTapUp: (_) {
      action();
    },
  );
}

Widget btnCustomSemiRounded(Color backgroungButton, Color textColor,
    String textButton, Function action, BuildContext context) {
  return SpringButton(
    SpringButtonType.OnlyScale,
    Container(
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: backgroungButton),
      child: Center(
        child: Text(
          textButton,
          style: TextStyle(
              fontSize: 14, fontFamily: Strings.fontRegular, color: textColor),
        ),
      ),
    ),
    onTapUp: (_) {
      action();
    },
  );
}

Widget itemAddress(Address address, Function action, BuildContext context,
    Function updateAddress) {
  return GestureDetector(
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: CustomColors.greyBorder, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 47,
            width: 49,
            decoration: BoxDecoration(
                color: CustomColors.blueOne.withOpacity(.2),
                shape: BoxShape.circle),
            child: Center(
              child: Image(
                width: 25,
                height: 25,
                image: AssetImage("Assets/images/ic_location_blue.png"),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  address.address,
                  style: TextStyle(
                      fontFamily: Strings.fontBold,
                      fontSize: 16,
                      color: CustomColors.blackLetter),
                ),
                Text(
                  address.complement,
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 15,
                      color: CustomColors.grayLetter),
                ),
                Text(
                  address.name ?? "",
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 15,
                      color: CustomColors.grayLetter),
                )
              ],
            ),
          ),
          GestureDetector(
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("Assets/images/ic_remove.png"))),
            ),
            onTap: () {
              action();
            },
          )
        ],
      ),
    ),
    onTap: () {
      updateAddress();
    },
  );
}

Widget itemConnectTo(String logo, Function actionConnect) {
  return SpringButton(
    SpringButtonType.OnlyScale,
    Container(
      width: 46,
      height: 47,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: CustomColors.whiteBackGround),
      child: Center(
        child: Image(
          width: 35,
          height: 35,
          fit: BoxFit.fill,
          image: AssetImage(logo),
        ),
      ),
    ),
    onTapUp: (_) {
      actionConnect();
    },
  );
}

Widget customTextField(
    String icon,
    String hintText,
    TextEditingController controller,
    TextInputType inputType,
    List<TextInputFormatter> formatters) {
  return Container(
    padding: EdgeInsets.only(left: 10),
    height: 52,
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
          image: AssetImage(icon),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 1,
          height: 25,
          color: CustomColors.grayLetter.withOpacity(.4),
        ),
        SizedBox(width: 5,),
        Expanded(
          child: Container(
            width: 200,
            child: TextField(
              inputFormatters: formatters,
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

Widget customTextFieldAction(String icon, String hintText,
    TextEditingController controller, Function action) {
  return GestureDetector(
    child: Container(
      padding: EdgeInsets.only(left: 10),
      height: 52,
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
            image: AssetImage(icon),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: 1,
            height: 25,
            color: CustomColors.grayLetter.withOpacity(.4),
          ),
          SizedBox(width: 5,),
          Expanded(
            child: Container(
              width: 200,
              child: TextField(
                enabled: false,
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
          ),
          Image(
            width: 35,
            height: 35,
            fit: BoxFit.fill,
            image: AssetImage("Assets/images/ic_arrow.png"),
          ),
        ],
      ),
    ),
    onTap: () {
      action();
    },
  );
}








Widget itemProductFirstDestacado() {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: CustomColors.des1),
    child: Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15, top: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Tecnología",
                style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 13,
                    color: CustomColors.blue),
              ),
              Text(
                "AirPods Earphones",
                style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 19,
                    color: CustomColors.splashColor),
              ),
              SizedBox(height: 7),
              Text(
                "Hoy:",
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 11,
                    color: CustomColors.letterGray),
              ),
              SizedBox(height: 7),
              Text(
                r"$500.000",
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 16,
                    color: CustomColors.orange),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Image(
            width: 50,
            height: 50,
            image: AssetImage("Assets/images/ic_orange_arrow.png"),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Image(
            fit: BoxFit.fill,
            width: 125,
            height: 180,
            image: NetworkImage(
                "https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),
          ),
        )
      ],
    ),
  );
}

Widget itemProductDestacado() {
  return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: CustomColors.des2),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8, top: 11, right: 18),
            child: Row(
              children: <Widget>[
                Image(
                  image: NetworkImage(
                      "https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),
                  width: 75,
                  height: 100,
                  fit: BoxFit.fill,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Tecnología",
                        style: TextStyle(
                            fontSize: 9,
                            fontFamily: Strings.fontBold,
                            color: CustomColors.letterGray),
                      ),
                      Text(
                        "Audifonos Stereo Bluetooth",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: Strings.fontBold,
                            color: CustomColors.splashColor),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image(
              width: 35,
              height: 35,
              image: AssetImage("Assets/images/ic_orange_arrow.png"),
            ),
          )
        ],
      ));
}

Widget itemProduct(bool border, BuildContext context) {
  return GestureDetector(
    child: Container(
      margin: EdgeInsets.only(right: 10),
      // height: 300,
      width: 152,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
              color: border
                  ? CustomColors.gray.withOpacity(.3)
                  : CustomColors.white,
              width: 1.3),
          color: CustomColors.white),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: CustomColors.red.withOpacity(.8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "20%",
                    style: TextStyle(
                        fontFamily: Strings.fontBold,
                        fontSize: 8,
                        color: CustomColors.white),
                  ),
                  Text(
                    "DCT",
                    style: TextStyle(
                        fontFamily: Strings.fontBold,
                        fontSize: 4,
                        color: CustomColors.white),
                  ),
                ],
              ),
            ),
          ),
          Container(
            // color: CustomColors.green,
            width: double.infinity,
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Image(
              image: NetworkImage(
                  "https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),
              height: 81,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 100, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Tenis Adidas Mujer Moda Vl Court 2.0",
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: Strings.fontBold,
                        color: CustomColors.blackLetter),
                  ),
                ),
                Text(
                  r"$109.990 COP",
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: Strings.fontBold,
                      color: CustomColors.orange),
                ),
                SizedBox(height: 5),
                Text(
                  r"$109.990 COP",
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 10,
                      fontFamily: Strings.fontBold,
                      color: CustomColors.letterGray),
                ),
                SizedBox(height: 20),
              ],
            ),
          )
          //eSTRELLas
        ],
      ),
    ),
    onTap: () {
      Navigator.of(context).push(PageTransition(
          type: PageTransitionType.slideInLeft,
          child: DetailProductPage(),
          duration: Duration(milliseconds: 700)));
    },
  );
}

Widget itemDestacado(BuildContext context) {
  return GestureDetector(
    child: Container(
      margin: EdgeInsets.only(right: 10),
      // height: 300,
      width: 152,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          //border: Border.all(color: border ? CustomColors.gray.withOpacity(.3) : CustomColors.white ,width: 1.3),

          color: CustomColors.white),
      child: Stack(
        children: <Widget>[
          Container(
            // color: CustomColors.green,
            width: double.infinity,
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Image(
              image: NetworkImage(
                  "https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),
              height: 81,
            ),
          ),
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.only(top: 100, left: 15, right: 15),
            height: 1,
            width: double.infinity,
            color: CustomColors.grayBackground,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 110, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Tenis Adidas Mujer Moda Vl Court 2.0",
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: Strings.fontBold,
                        color: CustomColors.blackLetter),
                  ),
                ),
                Text(
                  r"$109.990 COP",
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: Strings.fontBold,
                      color: CustomColors.orange),
                ),
                SizedBox(height: 5),
                Text(
                  r"$109.990 COP",
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 10,
                      fontFamily: Strings.fontBold,
                      color: CustomColors.letterGray),
                ),
                SizedBox(height: 20),
              ],
            ),
          )
          //eSTRELLas
        ],
      ),
    ),
    onTap: () {
      Navigator.of(context).push(PageTransition(
          type: PageTransitionType.slideInLeft,
          child: DetailProductPage(),
          duration: Duration(milliseconds: 700)));
    },
  );
}

Widget itemFirsOfertas(BuildContext context) {
  return Container(
    width: double.infinity,
    child: Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 30),
          child: Center(
            child: Row(
              children: <Widget>[
                Container(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Ofertas del día",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Strings.fontRegular,
                            color: CustomColors.orange),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: Text(
                          "Altavoz inteligente para el hogar con el Asistente de Google ",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: Strings.fontBold,
                              color: CustomColors.blackLetter),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        r"$129.000",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Strings.fontBold,
                            color: CustomColors.orange),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    //width: 400,
                    height: 200,

                    child: Image(
                      width: 500,
                      fit: BoxFit.fitHeight,
                      image: NetworkImage(
                          "https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Image(
            width: 35,
            height: 35,
            image: AssetImage("Assets/images/ic_orange_arrow.png"),
          ),
        ),
      ],
    ),
  );
}

Widget itemHelpCenter(String question, Function action) {
  return GestureDetector(
    child: Container(
      margin: EdgeInsets.only(top: 19),
      padding: EdgeInsets.only(left: 24, right: 10, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border:
            Border.all(color: CustomColors.gray.withOpacity(.2), width: 1.5),
      ),
      child: Center(
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                      fontFamily: Strings.fontBold,
                      fontSize: 15,
                      color: CustomColors.blackLetter),
                ),
              ),
              Container(
                child: Image(
                  width: 30,
                  height: 30,
                  image: AssetImage("Assets/images/ic_arrow.png"),
                ),
              )
            ],
          ),
        ),
      ),
    ),
    onTap: () {
      action();
    },
  );
}

Widget itemHelpCenterExpanded(
    questionModel.Question question, BuildContext context) {
  return ExpansionWidget(
      tilePadding: EdgeInsets.zero,
      initiallyExpanded: false,
      iconColor: CustomColors.gray,
      title: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage("dataOrder.brand.banner"))),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: CustomColors.greyBorder, width: 1),
              color: CustomColors.white,
            ),
            padding: EdgeInsets.only(left: 15, right: 15, top: 18, bottom: 18),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      width: double.infinity,
                      child: Text(
                        question.question,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: Strings.fontBold,
                            fontSize: 15,
                            color: CustomColors.blackLetter),
                      )),
                ),
                SizedBox(
                  width: 12,
                  height: 1,
                ),
              ],
            ),
          )),
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(color: CustomColors.greyBorder, width: 1),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              color: CustomColors.white),
          child: Html(
            data: question.answer ?? "",
          ),
        ),
      ]);
}


Widget notifyInternet(String image, String title, String text,
    BuildContext context, Function action) {
  return Center(
    child: Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(
            width: 182,
            height: 182,
            image: AssetImage(image),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 22,
              color: CustomColors.blueGray,
            ),
          ),
          SizedBox(height: 3),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Strings.fontRegular,
              fontSize: 15,
              color: CustomColors.blueGray,
            ),
          ),
          SizedBox(height: 20),
          Padding(
              padding: EdgeInsets.only(left: 60, right: 60, bottom: 20),
              child: btnCustomRounded(CustomColors.blueSplash,
                  CustomColors.white, Strings.retry, action, context))
        ],
      ),
    ),
  );
}

Widget emptyAdd(String image, String title, String text, String titleButton,
    Function action, BuildContext context) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
          fit: BoxFit.fill,
          height: 200,
          width: 200,
          image: AssetImage(image),
        ),
        Padding(
          padding: EdgeInsets.only(left: 60, right: 60),
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
              btnCustomRounded(
                  CustomColors.blueSplash, CustomColors.white, titleButton, () {
                action();
              }, context),
              SizedBox(height: 25),
            ],
          ),
        )
      ],
    ),
  );
}

Widget emptyInfo(String image, String title, String text, String titleButton,
    BuildContext context) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Image(
          fit: BoxFit.fill,
          height: 200,
          width: 200,
          image: AssetImage(image),
        ),
        Padding(
          padding: EdgeInsets.only(left: 60, right: 60),
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
              SizedBox(height: 25),
            ],
          ),
        )
      ],
    ),
  );
}

Widget itemCarrito(BuildContext context) {
  return GestureDetector(
    child: Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(11)),
          color: CustomColors.white),
      child: Stack(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              child: Container(
                margin: EdgeInsets.only(right: 100),
                child: Row(
                  children: <Widget>[
                    Image(
                      image: NetworkImage(
                          "https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),
                      width: 75,
                      height: 75,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "HP",
                            style: TextStyle(
                                fontFamily: Strings.fontRegular,
                                color: CustomColors.grayLetter,
                                fontSize: 9),
                          ),
                          Text(
                            "Portátil ideapad s145-14api amd r3",
                            style: TextStyle(
                                fontFamily: Strings.fontBold,
                                color: CustomColors.blackLetter,
                                fontSize: 12),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "1 Producto",
                            style: TextStyle(
                                fontFamily: Strings.fontRegular,
                                color: CustomColors.grayLetter,
                                fontSize: 9),
                          ),
                          SizedBox(height: 12),
                          Text(
                            r"$ 1.899.900 COP",
                            style: TextStyle(
                                fontFamily: Strings.fontBold,
                                color: CustomColors.orange,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 9,
            left: 28,
            child: GestureDetector(
              child: Text(
                "Editar",
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.blueOne,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              child: Image(
                width: 30,
                height: 30,
                fit: BoxFit.fill,
                image: AssetImage("Assets/images/ic_close_table.png"),
              ),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 11,
            child: Container(
              width: 96,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SpringButton(
                    SpringButtonType.OnlyScale,
                    Image(
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                      image: AssetImage("Assets/images/ic_negative.png"),
                    ),
                    onTapUp: (_) {},
                  ),
                  Text(
                    "0",
                    style: TextStyle(
                        fontFamily: Strings.fontBold,
                        fontSize: 20,
                        color: CustomColors.blackLetter),
                  ),
                  SpringButton(
                    SpringButtonType.OnlyScale,
                    Image(
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                      image: AssetImage("Assets/images/ic_add.png"),
                    ),
                    onTapUp: (_) {},
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
    onTap: () {
      Navigator.of(context).push(PageTransition(
          type: PageTransitionType.slideInLeft,
          child: DetailProductPage(),
          duration: Duration(milliseconds: 700)));
    },
  );
}

Widget itemInfoShopCar() {
  return Container(
    width: double.infinity,
    height: 79,
    decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15))),
    child: Container(
      margin: EdgeInsets.only(left: 15, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              height: 55,
              padding: EdgeInsets.only(left: 14, right: 9),
              decoration: BoxDecoration(
                color: CustomColors.blueOne,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Total",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: Strings.fontRegular,
                            color: CustomColors.white),
                      ),
                      Text(
                        r"$ 1.899.900 COP",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: Strings.fontBold,
                            color: CustomColors.white),
                      ),
                    ],
                  ),
                  SizedBox(width: 30),
                  Container(
                    height: 40,
                    width: 67,
                    decoration: BoxDecoration(
                        color: CustomColors.white.withOpacity(.2),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                      child: Text(
                        "Pagar",
                        style: TextStyle(
                            fontFamily: Strings.fontBold,
                            fontSize: 14,
                            color: CustomColors.white),
                      ),
                    ),
                  )
                ],
              )),
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: CustomColors.gray2),
            child: Center(
              child: Image(
                width: 45,
                height: 45,
                fit: BoxFit.fill,
                image: AssetImage("Assets/images/ic_time.png"),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget itemBannerCampaign(BuildContext context) {
  return GestureDetector(
    child: Container(
      margin: EdgeInsets.only(bottom: 10, top: 5),
      height: 127,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Container(
              height: 127,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(11)),
                child: Image(
                    fit: BoxFit.fill,
                    image: AssetImage("Assets/images/banner.png")),
              )),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image(
              width: 42,
              height: 42,
              image: AssetImage("Assets/images/ic_orange_arrow.png"),
            ),
          ),
          Positioned(
              left: 22,
              bottom: 9,
              right: 190,
              child: Text(
                "Aqui nombre de la campaña",
                style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 15,
                    color: CustomColors.white),
              )),
        ],
      ),
    ),
    onTap: () {
      Navigator.of(context).push(PageTransition(
          type: PageTransitionType.slideInLeft,
          child: ProductsCampaignsPage(),
          duration: Duration(milliseconds: 700)));
    },
  );
}

Widget headerMenu(
    BuildContext context, String title, GlobalKey<ScaffoldState> _drawerKey) {
  return Container(
    padding: EdgeInsets.only(left: 21, right: 21),
    width: double.infinity,
    height: 90,
    decoration: BoxDecoration(
      color: CustomColors.white,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 10,
            child: GestureDetector(
              child: Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: CustomColors.blueActiveDots),
                child: Center(
                  child: Image(
                    image: AssetImage("Assets/images/ic_menu.png"),
                  ),
                ),
              ),
              onTap: () {
                _drawerKey.currentState.openDrawer();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            alignment: Alignment.topCenter,
            child: Text(
              title,
              style: TextStyle(
                  fontFamily: Strings.fontBold,
                  fontSize: 16,
                  color: CustomColors.blackLetter),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget textFieldCode(TextEditingController controller, String placeHolder,
    BuildContext context) {
  return Container(
    height: 56,
    padding: EdgeInsets.only(top: 15),
    width: 59,
    // margin: EdgeInsets.only(right: 27),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: CustomColors.grayBackground,
        border: Border.all(color: CustomColors.gray.withOpacity(.3), width: 1)),
    child: Padding(
      padding: const EdgeInsets.only(left: 10, top: 0),
      child: TextField(
          textInputAction: TextInputAction.done,
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: CustomColors.blackLetter, fontSize: 19),
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              hintText: placeHolder,
              hintStyle: TextStyle(
                  color: CustomColors.garyHint,
                  fontSize: 19,
                  fontFamily: Strings.fontRegular)),
          onChanged: (text) {
            if (text.isNotEmpty) {
              FocusScope.of(context).nextFocus();
            }
          },
          onEditingComplete: () => FocusScope.of(context).nextFocus()),
    ),
  );
}

Widget notifyUser(String image, String title, String text) {
  return Center(
    child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(
            width: 309,
            height: 238,
            image: AssetImage(image),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
                fontFamily: Strings.fontBold,
                fontSize: 19,
                color: CustomColors.blackLetter),
          ),
          SizedBox(height: 3),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Strings.fontRegular,
              fontSize: 13,
              color: CustomColors.blackLetter,
            ),
          ),
          SizedBox(height: 10)
        ],
      ),
    ),
  );
}

Widget textFieldAddress(String hint, String icon,
    TextEditingController controller, Function action) {
  return Container(
    width: double.infinity,
    height: 45,
    padding: EdgeInsets.only(left: 10, right: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        color: CustomColors.grayBackground,
        border: Border.all(color: CustomColors.greyBorder, width: 1)),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            width: 30,
            height: 30,
            image: AssetImage(icon),
          ),
          SizedBox(
            width: 6,
          ),
          Expanded(
              child: TextField(
                onTap: () {
                  action();
                },
                maxLines: 1,
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: CustomColors.blackLetter),
                controller: controller,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 15,
                      color: CustomColors.grayLetter2),
                  hintText: hint,
                  border: InputBorder.none,
                ),
                cursorColor: CustomColors.blueSplash,
              ),
          ),
          SizedBox(
            width: 6,
          ),
        ],
      ),
    ),
  );
}



class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}


Widget itemCategoryInteresting(Category category,Function actionSelect){
  return Container(
  child: GestureDetector(
    onTap: ()=>actionSelect(category),
    child: Column(
      children: [
        Container(
          height: 100,
          width: 100,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: category.isSelected?convertColor(category.color):Colors.white.withOpacity(.3)
                  ),
                ),
              ),
              Positioned(
                right: 12,
                bottom: 18,
                child: FadeInImage(
                  height:40,
                  image: NetworkImage(category.image),
                  placeholder: AssetImage("Assets/images/ic_sport.png"),
                  fit: BoxFit.fill,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10,),
        Text(
          category?.category??'',
          style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 16,
              color: CustomColors.white),
        )
      ],
    ),
  ),
  );
}
