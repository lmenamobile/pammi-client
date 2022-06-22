import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

import '../WidgetsGeneric.dart';

class DialogCustomTwoOptions extends StatelessWidget {
  final String title, msgText, asset;

  const DialogCustomTwoOptions({required this.title, required this.msgText, required this.asset});

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
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                "Assets/images/$asset",
                fit: BoxFit.fill,
                height: 50,
                width: 50,
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
                    color: Colors.black.withOpacity(.7),
                    fontSize: 16,
                    fontFamily: Strings.fontRegular),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: btnCustom(null,
                            Strings.btnCancel,
                            CustomColors.grayBackground,
                            Colors.grey,
                            () => Navigator.pop(context, false)),
                  ),

                  SizedBox(
                    width: 15,
                    height: 20,
                  ),
                  Expanded(
                    child: btnCustom(null,
                        Strings.btnAccept, CustomColors.blueSplash, Colors.white,
                        () => Navigator.pop(context, true)),
                  ),
                ],
              ),
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
