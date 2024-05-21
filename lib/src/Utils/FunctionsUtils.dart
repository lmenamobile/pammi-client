import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/WidgetsClaim.dart';
import 'package:wawamko/src/UI/OnBoarding/Login.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import 'Strings.dart';
SharePreference _prefs = SharePreference();

Widget isImageYoutube(String url,Widget itemImage){
  return url.contains("youtube")?Container(
      child: Image.asset("Assets/images/video.png",fit: BoxFit.fill,)):itemImage;
}

Widget isImageYoutubeAction(String url,Widget itemImage){
  return url.contains("youtube")?InkWell(
    onTap: ()=>launch(url),
      child: Container(
        width: 170,
        height: 170,
        child: Center(
          child: Container(
            width: 50,
              height: 50,
              child: Image.asset("Assets/images/video.png",fit: BoxFit.fill,)),
        ),
      )):itemImage;
}

Color convertColor(String color) {
  var auxColor = "0xff" + color;
  return Color(int.parse(auxColor));
}

bool platformIsAndroid() {
  bool value = false;
  if (Platform.isAndroid) {
    value = true;
  }
  return value;
}

/*Share url*/
openShareLink(String url) {
  Share.share(url);
}

int getRandomPosition(int lengthList) {
  if (lengthList > 0) {
    Random random = new Random();
    return random.nextInt(lengthList);
  } else {
    return 0;
  }
}

String calculateTotal(String total, String valueSend, String discountSend) {
  return (double.parse(total) + double.parse(valueSend) - double.parse(discountSend)).toString();
}

String getTypeDocument(String type) {
  switch (type) {
    case Strings.cedulaCiudadania:
      return Constants.cc;
    case Strings.passport:
      return Constants.passport;
    case Strings.cedulaExtranjeria:
      return Constants.ce;
    default:
      return Constants.cc;
  }
}

String getStatusOrder(String type) {
  switch (type) {
    case Strings.statusCreate:
      return Constants.create;
    case Strings.statusProcessing:
      return Constants.processing;
    case Strings.statusCancel:
      return Constants.cancel;
    case Strings.statusCompleted:
      return Constants.completed;
    case Strings.statusRestored:
      return Constants.restored;
    case Strings.statusSend:
      return Constants.send;
    case Strings.statusFinish:
      return Constants.finish;
    default:
      return Constants.create;
  }
}

String getStatusClaim(String type) {
  switch (type) {
    case Strings.statusOpen:
      return Constants.open;
    case Strings.statusClose:
      return Constants.close;
    case Strings.statusApproved:
      return Constants.approved;
    case Strings.statusReject:
      return Constants.reject;
    default:
      return Constants.open;
  }
}


Widget getCardByStatusClaim(String type,String reasonClose,Function openChatAdmin) {
  switch (type) {
    case Strings.statusOpen:
      return claimNotCheck(Strings.claimNotCheck, Strings.textClaimNotCheck,(){
        openChatAdmin();
      });
    case Strings.statusClose:
      return reasonClose == "agreementWithProvider" ? claimNotCheck(
          Strings.claimClos, Strings.claimClos,(){
        openChatAdmin();
      }) :
      reasonClose == "rejectedByProvider" ? claimNotCheck(
          Strings.claimReject, Strings.textClaimReject,(){openChatAdmin();}) :
      claimNotCheck(Strings.claimClos, Strings.claimClose,(){openChatAdmin();});
    case Strings.statusApproved:
      return claimNotCheck(Strings.claimCheck, Strings.textClaimCheck,(){
        openChatAdmin();
      });
    case Strings.statusReject:
      return claimNotCheck(Strings.claimReject, Strings.textClaimReject,(){
        openChatAdmin();
      });
    default:
      return Container();
  }
}

String getStatusPqrs(String type) {
  switch (type) {
    case Strings.open:
      return Strings.openShow;
    case Strings.close:
      return Strings.closeShow;
    case Strings.inProgress:
      return Strings.inProgressShow;
    default:
      return "";
  }
}

Color getStatusColorClaim(String type) {
  switch (type) {
    case Strings.statusOpen:
      return CustomColors.blue4;
    case Strings.statusClose:
      return CustomColors.orangeOne;
    case Strings.statusApproved:
      return CustomColors.greenOne;
    case Strings.statusReject:
      return CustomColors.redTwo;
    default:
      return CustomColors.blue4;
  }
}

Color getStatusColorOrder(String type) {
  switch (type) {
    case Strings.statusCreate:
      return CustomColors.blue4;
    case Strings.statusProcessing:
      return CustomColors.orangeOne;
    case Strings.statusCancel:
      return CustomColors.redTwo;
    case Strings.statusCompleted:
      return CustomColors.greenOne;
    case Strings.statusRestored:
      return CustomColors.yellowTwo;
    case Strings.statusSend:
      return CustomColors.blue5;
    case Strings.statusFinish:
      return CustomColors.greenOne;
    default:
      return CustomColors.blue4;
  }
}



Widget validateStatusClaim(BuildContext context,String messageState,String messageTime,String stateSubOrder,bool timeValidateClaim,Function makeClaim, String idPackage) {
  switch (stateSubOrder) {
    case Strings.statusCreate:
      return timeValidateClaim?btnNotMakeClaim(context,messageState):btnNotMakeClaim(context,messageTime);
    case Strings.statusCompleted:
      return timeValidateClaim?InkWell(
        onTap: ()=>makeClaim(idPackage),
          child: btnMakeClaim()):btnNotMakeClaim(context,messageTime);
    case Strings.statusSend:
      return timeValidateClaim?btnNotMakeClaim(context,messageState):btnNotMakeClaim(context,messageTime);
    default:
      return Container();
  }
}

String percentDiscount(String percent) {
  return (double.parse(percent)*100).round().toString()+'%';
}

String unitsDiscount(List products,List productsGift) {
  return (products.length+productsGift.length).toString()+'x'+products.length.toString();
}

String priceDiscount(String price,String percent) {
  var valueDiscount = double.parse(percent)*double.parse(price);
  var priceFinal = double.parse(price)-valueDiscount;
  return priceFinal.toString();
}

void validateSession(BuildContext context)async{
  bool? status = await showDialogDoubleAction(context, Strings.ups, Strings.userNotLogIn, "ic_error.png", Strings.yesLogin);
  if(status!)Navigator.of(context).push(customPageTransition(LoginPage()));
}

bool userIsLogged(){
  return _prefs.authToken=="0"?false:true;
}
