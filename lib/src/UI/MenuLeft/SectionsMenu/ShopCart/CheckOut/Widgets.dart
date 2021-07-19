import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

Widget sectionAddress() {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.yourOrder,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 19,
              color: CustomColors.blackLetter,
            ),
          ),
          customDivider(),
          Text(
            Strings.deliveryAddress,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              color: CustomColors.blackLetter,
            ),
          ),
          customDivider(),
          Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.mainAddress,
                    style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.gray7,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Dieccion del cliente",
                    style: TextStyle(
                      fontFamily: Strings.fontBold,
                      fontSize: 15,
                      color: CustomColors.blackLetter,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "descripcion direccion",
                    style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.gray7,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ),
  );
}

Widget sectionProducts() {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.products,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 19,
              color: CustomColors.blackLetter,
            ),
          ),
          customDivider(),
          itemProvider(),
          customDivider(),
        ],
      ),
    ),
  );
}

Widget itemProvider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2))
          ]),
          child: Center(
            child: FadeInImage(
              height: 40,
              fit: BoxFit.fill,
              image: NetworkImage(""),
              placeholder: AssetImage("Assets/images/spinner.gif"),
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Proveedor aca",
                style: TextStyle(
                  fontFamily: Strings.fontBold,
                  fontSize: 15,
                  color: CustomColors.gray7,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                Strings.brand,
                style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  color: CustomColors.gray7,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "aca va l marca",
                style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  color: CustomColors.gray7,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: CustomColors.gray7,
          size: 15,
        )
      ],
    ),
  );
}

Widget sectionPayment() {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.paymentMethod,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 19,
              color: CustomColors.blackLetter,
            ),
          ),
          customDivider(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  "Assets/images/ic_time.png",
                  width: 55,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  color: CustomColors.grayBackground,
                  height: 30,
                  width: 1,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.selectPayment,
                        style: TextStyle(
                          fontFamily: Strings.fontBold,
                          fontSize: 15,
                          color: CustomColors.gray7,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: CustomColors.gray7,
                  size: 15,
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget sectionDiscount() {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.discount,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 19,
              color: CustomColors.blackLetter,
            ),
          ),
          customDivider(),
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                itemCoupon(Strings.coupon),
                SizedBox(
                  width: 10,
                ),
                itemCoupon(Strings.card)
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: fieldCoupon(null, Strings.hintCard)),
          Container(
            width: 150,
            child: btnCustomSize(
                35, Strings.validate, CustomColors.orange, Colors.white, null),
          )
        ],
      ),
    ),
  );
}

Widget itemCoupon(String text) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: CustomColors.greyBorder)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 30,
            width: 1,
            color: CustomColors.greyBorder,
          ),
          Text(
            text,
            style: TextStyle(
                color: CustomColors.gray7, fontFamily: Strings.fontRegular),
          )
        ],
      ),
    ),
  );
}

Widget fieldCoupon(TextEditingController controller, String hintText) {
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
        Expanded(
          child: Container(
            child: TextField(
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              keyboardType: TextInputType.text,
              controller: controller,
              style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  color: CustomColors.blackLetter),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: CustomColors.gray7.withOpacity(.4),
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

Widget sectionTotal() {
  var styleRegular = TextStyle(fontFamily: Strings.fontRegular, fontSize: 15, color: CustomColors.blackLetter,);
  var styleBold = TextStyle(fontFamily: Strings.fontBold, fontSize: 19, color: CustomColors.blackLetter,);

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    )),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          itemTotal(styleRegular, Strings.subTotal, "1000"),
          itemTotal(styleRegular, Strings.delivery, "1000"),
          customDivider(),
          itemTotal(styleRegular, Strings.IVA, "1000"),
          itemTotal(styleRegular, Strings.coupon, "1000"),
          customDivider(),
          itemTotal(styleBold, Strings.total, "1000"),
          SizedBox(height: 20,),
          Align(
              alignment: Alignment.center,
              child: btnCustom(230,Strings.payment,CustomColors.blueSplash,Colors.white,null)),
          SizedBox(height: 20,),
        ],
      ),
    ),
  );
}

Widget itemTotal(TextStyle style,String text, String value) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        text,
        style: style,
      ),
      Text(
        formatMoney(value),
        style: style,
      ),
    ],
  );
}
