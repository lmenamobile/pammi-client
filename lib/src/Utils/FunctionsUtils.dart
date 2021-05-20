
import 'package:flutter/material.dart';

Color convertColor(String color){
  var auxColor = "0xff"+color;
  return Color(int.parse(auxColor));
}