import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wawamko/src/Animations/animate_button.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/Dialogs/DialogAlertCustomImage.dart';
import 'package:wawamko/src/Widgets/Dialogs/DialogCustomAlert.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Widgets/Dialogs/DialogCustomTwoOptions.dart';
import 'package:wawamko/src/Widgets/Dialogs/DialogSelectBank.dart';
import 'package:wawamko/src/Widgets/Dialogs/DialogSelectCountry.dart';


customPageTransition(Widget page) {
  return PageTransition(
      curve: Curves.decelerate,
      child: page,
      type: PageTransitionType.rightToLeft,
      duration: Duration(milliseconds: 600));
}

customPageTransitionLeftToRight(Widget page) {
  return PageTransition(
      curve: Curves.decelerate,
      child: page,
      type: PageTransitionType.leftToRight,
      duration: Duration(milliseconds: 600));
}

/*Widget titleBar(String title, String icon, Function action) {
  return Container(
    width: double.infinity,
    height: 75,
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("Assets/images/ic_header_reds.png"),
            fit: BoxFit.fill)),
    child: Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 15,
            decoration: BoxDecoration(
              color: CustomColors.whiteBackGround,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15),
              )
            ),
          ),
        ),
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
<<<<<<< HEAD
}

Widget emptyView(String image, String title, String text) {
=======
}*/

Widget btnCustom(double? width,String nameButton, Color colorBackground, Color colorText,
    Function? action) {
  return Container(
    width: width??200,
    height: 40,
    child: AnimateButton(
      pressEvent: action,
      body: Container(
        decoration: BoxDecoration(
            color: colorBackground,
            borderRadius: BorderRadius.all(Radius.circular(26))),
        child: Center(
          child: Text(
            nameButton,
            style: TextStyle(
              fontFamily: Strings.fontMedium,
              color: colorText,
              fontSize: 14
            ),
          ),
        ),
      ),
    ),
  );
}

Widget btnCustomIcon(String asset, String nameButton, Color colorBackground,
    Color colorText, Function action) {
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
              SizedBox(
                width:20 ,
              ),
              Image.asset(
                "Assets/images/$asset",
                width: 20,
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget btnCustomIconLeft(String asset, String nameButton, Color colorBackground,
    Color colorText, Function action) {
  return Container(
    width: double.infinity,
    height: 40,
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
              Image.asset(
                "Assets/images/$asset",
                width: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                nameButton,
                style: TextStyle(
                  fontFamily: Strings.fontMedium,
                  color: colorText,
                ),
              ),
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
            borderRadius: BorderRadius.all(Radius.circular(26))),
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

Widget itemProductGeneric(Product product, Function openDetail){
  int position = getRandomPosition(product.references?.length??0);
  return InkWell(
    onTap: ()=>openDetail(product),
    child: Container(
      width: 160,
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
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: FadeInImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(product.references?[position].images?[0].url??''),
                    placeholder: AssetImage("Assets/images/spinner.gif"),
                    imageErrorBuilder: (_,__,___){
                      return Container();
                    },
                  ),
                ),
                customDivider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.brandProvider?.brand?.brand??'',
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 12,
                          color: CustomColors.gray7,
                        ),
                      ),
                      Text(
                        product.references?[position].reference??'',
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 13,
                          color: CustomColors.blackLetter,
                        ),
                      ),
                      Text(
                        formatMoney( product.references?[position].price??'0'),
                        style: TextStyle(
                          fontFamily: Strings.fontBold,
                          color: CustomColors.orange,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
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
    padding: EdgeInsets.only(left: 20,right: 20),
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        border: Border.all(color: CustomColors.gray.withOpacity(.3), width: 1),
        color: CustomColors.white),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          width: 18,
          height: 18,
          fit: BoxFit.fill,
          image: AssetImage("Assets/images/$icon"),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 1,
          height: 20,
          color: CustomColors.gray7.withOpacity(.3),
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

Widget textFieldIconSelector(
    String icon,
    bool isActive,
    String hintText,
    TextEditingController controller,
    ) {
  return Container(
    margin: EdgeInsets.only(bottom: 20),
    padding: EdgeInsets.only(left:20,right: 20),
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        border: Border.all(color: CustomColors.gray.withOpacity(.3), width: 1),
        color: CustomColors.white),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          width: 18,
          height: 18,
          fit: BoxFit.fill,
          image: AssetImage("Assets/images/$icon"),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 1,
          height: 25,
          color: CustomColors.gray7.withOpacity(.4),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            child: TextField(
              enabled: isActive,
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
        ),
        Icon(Icons.arrow_forward_ios_rounded,color: CustomColors.gray6,size: 20,),
        SizedBox(
          width: 5,
        ),
      ],
    ),
  );
}

Widget textFieldIconPhone(
    String hintText,
    String prefix,
    String icon,
    TextEditingController controller,
    ) {
  return Container(
    margin: EdgeInsets.only(bottom: 20),
    padding: EdgeInsets.only(left: 20),
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        border: Border.all(color: CustomColors.gray.withOpacity(.3), width: 1),
        color: CustomColors.white),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        /*Container(
          width: 35,
          child: Text(
            prefix,
            style:  TextStyle(
                fontFamily: Strings.fontRegular,
                color: CustomColors.gray7),
          ),
        ),*/
        Image(
          width: 18,
          height: 18,
          fit: BoxFit.fill,
          image: AssetImage("Assets/images/$icon"),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: 1,
          height: 25,
          color: CustomColors.gray7.withOpacity(.4),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            child: TextField(
              inputFormatters: [LengthLimitingTextInputFormatter(15),FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.phone,
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

Widget emptyData(
  String image,
  String title,
  String text,
) {
  return Container(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
          fit: BoxFit.fill,
          width: 200,
          image: AssetImage("Assets/images/$image"),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 22,
                    color: CustomColors.gray8),
              ),
              SizedBox(height: 5),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: CustomColors.gray8),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget emptyDataWithAction(String image, String title, String text, String titleButton, Function action) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image(
          fit: BoxFit.fill,
          width: 200,
          image: AssetImage("Assets/images/$image"),
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
                    color: CustomColors.gray8),
              ),
              SizedBox(height: 5),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: CustomColors.gray8),
              ),
              SizedBox(height: 23),
              btnCustom(null,titleButton, CustomColors.blueSplash, Colors.white, action),
              SizedBox(height: 25),
            ],
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
                          color: CustomColors.gray7,
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
                              Strings.btnNot,
                              CustomColors.gray2,
                              CustomColors.blackLetter,
                              actionNegative),
                          width: 100,
                        ),
                        Container(
                          child: btnCustomSize(
                              35,
                              Strings.btnYes,
                              CustomColors.blueSplash,
                              CustomColors.white,
                              action),
                          width: 100,
                        ),
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

Widget emptyView(String image, String title, String text) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            fit: BoxFit.fill,
            width: 200,
            image: AssetImage("Assets/images/$image"),
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
                      color: CustomColors.gray8),
                ),
              SizedBox(height: 5),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 15,
                      color: CustomColors.gray8),
                ),
                SizedBox(height: 23),
              ],
            ),
          )
        ],
      ),
    );
}

Future<dynamic> openSelectCountry(
    BuildContext context,) async {
  var state = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) =>DialogSelectCountry(),
  );
  return state;
}

Future<dynamic> openSelectBank(
    BuildContext context,) async {
  var state = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) =>DialogSelectBank(),
  );
  return state;
}


Future<bool?> showCustomAlertDialog(
    BuildContext context, String title, String msg) async {
  bool? state = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) =>
        DialogCustomAlert(title: title, msgText: msg),
  );
  return state;
}

Future<bool?> showAlertActions(BuildContext context, String title, String msg,
    String asset, Function positive, Function negative) async {
  bool? state = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) =>
        alertMessageWithActions(title, asset, msg, positive, negative),
  );
  return state;
}

Future<bool?> showDialogDoubleAction(BuildContext context, String title, String msg,
    String asset, String btnCustomTitle) async {
  bool? state = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) =>
    DialogCustomTwoOptions(title: title, msgText: msg, asset: asset,btnCustomTitle: btnCustomTitle,)
  );
  return state;
}

Widget headerRefresh(){
  return WaterDropHeader(waterDropColor: CustomColors.blueSplash, complete: Container(), failed: Container(), refresh: SizedBox(
    width: 25.0,
    height: 25.0,
    child:  CircularProgressIndicator(strokeWidth: 2.0),
  ));
}

Widget footerRefreshCustom(){
  return ClassicFooter( canLoadingText:"Cargar mas",noDataText: "", loadingText: "", idleText: "", idleIcon: null, height: 30);
}

Widget loadingWidgets(double size){
  return Container(
    child: Image.asset("Assets/images/spinner.gif",width: size,),
  );
}

Widget btnSheet( String btnTextAction,Function action){
  return TextButton(
    onPressed: ()=>action(),
    child:  Align(
      alignment: Alignment.centerLeft,
      child: Text(
        btnTextAction,
        style: TextStyle(
          fontFamily: Strings.fontRegular,
          color: CustomColors.gray7
        ),
      ),
    ),
  );
}

Widget notConnectionInternet(){
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "Assets/images/ic_internet.png",
          width: 200,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15,right: 15),
          child: Text(
            Strings.sorry,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: CustomColors.gray7,
                fontFamily: Strings.fontBold,
                fontSize: 20
            ),
          ),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 15,right: 15),
          child: Text(
            Strings.errorConnection,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: CustomColors.gray7,
                fontFamily: Strings.fontRegular,
                fontSize: 15
            ),
          ),
        ),
      ],
    ),
  );
}

Future<bool?> startAlertCustomImage(BuildContext context,String title, String text,String asset) async{
  return   await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => DialogAlertCustomImage(title: title,msgText: text,asset:asset ,));
}