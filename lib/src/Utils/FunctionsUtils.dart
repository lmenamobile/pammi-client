
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:share/share.dart';

Color convertColor(String color){
  var auxColor = "0xff"+color;
  return Color(int.parse(auxColor));
}

bool platformIsAndroid(){
  bool value = false;
  if(Platform.isAndroid){
    value = true;
  }
  return value;
}

/*Share url*/
openShareLink(String url) {
  Share.share(url);
}

int getRandomPosition(int lengthList){
  if(lengthList>0){
    Random random = new Random();
    return random.nextInt(lengthList);
  }else{
    return 0;
  }
}