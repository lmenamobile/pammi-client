import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

import '../WidgetsGeneric.dart';

class DialogCustomAlert extends StatelessWidget {
  final String title, msgText;
  const DialogCustomAlert({@required this.title, @required this.msgText});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.close,
                            color: CustomColors.gray,
                          ),
                          onPressed: () => Navigator.pop(context, false)))
                ],
              ),
            ),
            Visibility(
              visible: title.isNotEmpty,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: Strings.fontMedium),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                msgText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.2,
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: Strings.fontRegular),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: btnCustom(null,Strings.btnAccept, CustomColors.blueSplash,
                  Colors.white, () => Navigator.pop(context, false)),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
