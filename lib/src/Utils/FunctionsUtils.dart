import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:wawamko/src/Utils/Constants.dart';

import 'Strings.dart';

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

String addValues(String a, String b) {
  return (double.parse(a) + double.parse(b)).toString();
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
