import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:encrypt/encrypt.dart' as cript;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Models/Claim/ReasonClose.dart';
import 'package:wawamko/src/Models/Order/MethodDevolution.dart';
import 'package:wawamko/src/Models/Claim/TypeClaim.dart';
import 'package:wawamko/src/Models/Claim/TypeReason.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Widgets/Dialogs/dialog_create_pqrs.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/confirmationSlide.dart';

class _Utils {
  final prefs = SharePreference();

  Map encryptPwdIv(String value) {
    var key = cript.Key.fromUtf8(Constants.key_encrypt);
    var iv = cript.IV.fromSecureRandom(16);
    var encrypter =
        cript.Encrypter(cript.AES(key, mode: cript.AESMode.ctr, padding: null));
    var iv16 = iv.base16;
    var encrypted = encrypter.encrypt(value, iv: iv);
    var encrypted16 = encrypted.base16;
    Map jsonEncrypted = {
      'iv': iv16,
      'encrypted': encrypted16,
    };
    print(iv16);
    print(encrypted16);
    return jsonEncrypted;
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  String getPlatform() {
    if (Platform.isAndroid) {
      return "a";
    } else if (Platform.isIOS) {
      return "i";
    }
    return "a";
  }

  double? getLatitude() {
    var singleton = GlobalVariables();
    if (singleton.latitude == 0.0 && singleton.longitude == 0.0) {
      return 4.6287835;
    }
    return singleton.latitude;
  }

  double? getLongitude() {
    var singleton = GlobalVariables();
    if (singleton.longitude == 0.0 && singleton.longitude == 0.0) {
      return -74.0695618;
    }
    return singleton.longitude;
  }

  Widget showSnackBar(BuildContext context, String message) {
    return Flushbar(
      animationDuration: Duration(milliseconds: 500),
      margin: EdgeInsets.only(left: 60, right: 60, bottom: 60),
      borderRadius: BorderRadius.all(Radius.circular(15)),
      backgroundColor: CustomColors.splashColor,
      icon: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Image(
          width: 40,
          height: 40,
          image: AssetImage("Assets/images/ic_error.png"),
        ),
      ),
      messageText: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            message,
            style:
                TextStyle(color: Colors.white, fontFamily: Strings.fontRegular),
          ),
        ),
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  double getSizeNavBar(){
    final prefs = SharePreference();
    if(prefs.sizeHeightHeader == 0.0){
      if (Platform.isAndroid) {
        return 25.0;
      }else{
        return 40.0;
      }
    }else{
      return prefs.sizeHeightHeader;
    }
  }

  String formatDate(DateTime date,String pattern,String locale){
    String dateReturn = '';
    final formatDateFirst = new DateFormat(pattern,locale);
    var num = date.millisecondsSinceEpoch/1000.toInt();
    var date2 = DateTime.fromMillisecondsSinceEpoch(num.toInt()*1000);
    dateReturn = formatDateFirst.format(date2);
    return dateReturn;
  }



  double getSizeHeader(){
    return getSizeNavBar() + 50.0;
  }

  showDialogCreatePqrs(BuildContext context,String idTicket,Function action) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>DialogCreatePqrs(idTicket: idTicket,action: action,)
    );
  }

  openWhatsapp({required BuildContext context,required String text,required String number}) async {
    var url = "https://api.whatsapp.com/send?phone=$number&text=$text";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Whatsapp not installed")));
    }
  }

  openEmail(String email,String subject){

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': subject
      }),
    );

    launch(emailLaunchUri.toString());
  }


  openDial(String number){
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: number,
    );

    launch(phoneLaunchUri.toString());
  }

  openUrl(String url){
    final Uri phoneLaunchUri = Uri(
      scheme: 'http',
      path: url,
    );

    launch(phoneLaunchUri.toString());
  }


  Widget showSnackBarGood(BuildContext context, String message) {
    return Flushbar(
      animationDuration: Duration(milliseconds: 500),
      margin: EdgeInsets.only(left: 60, right: 60, bottom: 60),
      borderRadius: BorderRadius.all(Radius.circular(15)),
      backgroundColor: CustomColors.greenValid,
      icon: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Image(
          width: 40,
          height: 40,
          image: AssetImage("Assets/images/ic_correct.png"),
        ),
      ),
      messageText: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            message,
            style:
                TextStyle(color: Colors.white, fontFamily: Strings.fontRegular),
          ),
        ),
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  Widget showSnackBarError(BuildContext context, String? message) {
    return IgnorePointer(
      child: Flushbar(
        animationDuration: Duration(milliseconds: 500),
        margin: EdgeInsets.only(left: 60, right: 60,bottom: 40),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        backgroundColor: CustomColors.red,
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Image(
            image: AssetImage("Assets/images/ic_error.png"),
            color: Colors.white,
          ),
        ),
        message: message,
        duration: Duration(seconds: 3),
      )..show(context),
    );
  }


  Future<bool?> startCustomAlertMessage(BuildContext context, String titleAlert, String image,
      String textAlert, Function action, Function actionNegative) async{
   return   await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => alertCustomMessage(context,
            titleAlert, image, textAlert, action, actionNegative));
  }

  startProgress(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => LoadingProgress());
  }

  startOpenSlideUp(BuildContext context, String? email, String? name) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ConfirmationSlidePage(
              email: email,
              name: name,
            ));
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  dynamic checkInternet2(Function func, BuildContext? context) {
    check().then((internet) {
      if (internet != null && internet) {
        func(true, context);
      } else {
        func(false, context);
      }
    });
  }

  Widget alertCustomMessage(BuildContext context,String titleAlert, String image, String textAlert,
      Function action, Function actionNegative) {
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
                  color: CustomColors.white,
                ),
                child: Stack(
                  children:[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Center(
                          child: Image.asset(
                            image,
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
                    Positioned(
                      right:10,
                      top: 15,
                      child:IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.close,
                            color: CustomColors.gray,
                          ),
                          onPressed: () => Navigator.pop(context))
                    )
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> listMonths() {
    List<String> lts = [];
    for (int i = 1; i <= 12; i++) {
      if (i <= 9) {
        lts.add("0$i");
      } else {
        lts.add('$i');
      }
    }
    return lts;
  }

  List<String> listYears() {
    List<String> lts = [];
    var aux = DateTime.now();
    for (int i = aux.year; i <= aux.year + 10; i++) {
      lts.add('$i');
    }
    return lts;
  }

  List<TypeReason> getLtsTypeReason =[

    TypeReason(typeReason: "Me arrepentí de la compra",valueTypeReason: "regretted"),
    TypeReason(typeReason: "Inconformidad con el pedido",valueTypeReason: "nonconformity"),
    TypeReason(typeReason: "No es lo que pedí",valueTypeReason: "unxespected"),
    TypeReason(typeReason: "Tiene daños",valueTypeReason: "damage"),
    TypeReason(typeReason: "Otra",valueTypeReason: "other")
];

  List<TypeClaim> getLtsTypeClaim = [
    TypeClaim(typeClaim: "Devolución",valueTypeClaim: "devolution"),
    TypeClaim(typeClaim: "Reembolso",valueTypeClaim: "repayment"),
    TypeClaim(typeClaim: "Garantia",valueTypeClaim: "warranty")
  ];

  List<ReasonClose> getLtsReasonClose= [
    ReasonClose(reasonClose: "Me equivoqué, no quería reclamar",valueReason: "equivocated"),
    ReasonClose(reasonClose: "Arreglé con el proveedor",valueReason: "agreementWithProvider"),
/*    ReasonClose(reasonClose: "Acepté una giftcard",valueReason: "acceptGiftcard"),
    ReasonClose(reasonClose: "Reversión de pago exitosa",valueReason: "revertPayment"),*/
  ];

  List<ReasonClose> getLtsReasonCloseByPamii= [
    ReasonClose(reasonClose: "Rechazado por proveedor",valueReason: "rejectedByProvider"),
    ReasonClose(reasonClose: "Me equivoqué, no quería reclamar",valueReason: "equivocated"),
    ReasonClose(reasonClose: "Arreglé con el proveedor",valueReason: "agreementWithProvider"),
    ReasonClose(reasonClose: "Acepté una giftcard",valueReason: "acceptGiftcard"),
    ReasonClose(reasonClose: "Reversión de pago exitosa",valueReason: "revertPayment"),
    ReasonClose(reasonClose: "Verificación de daño por la transportadora",valueReason: "verificationDamageByTransporter"),
    ReasonClose(reasonClose: "Verificación de daño por el cliente",valueReason: "verificationDamageByClient"),
    ReasonClose(reasonClose: "El producto nunca llego",valueReason: "productNotFound"),
    ReasonClose(reasonClose: "Reclamo no cerrado por el cliente",valueReason: "claimUnclosed"),
  ];

  List<MethodDevolution> getLtsMethodDevolution = [
    MethodDevolution(methodDevolution: "Punto fisico de servientrega",valueMethodDevolution: "physicalPoint"),
    MethodDevolution(methodDevolution: "A domicilio",valueMethodDevolution: "domicile")
  ];

}

final utils = _Utils();
