
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import '../../Animations/animate_button.dart';
import '../../Utils/share_preference.dart';

class DialogPermissionGallery extends StatelessWidget {
  final BuildContext contextContainer;

  final prefs = SharePreference();
  final String message;

  DialogPermissionGallery(this.contextContainer, this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 35, right: 35),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
              margin: EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 55, right: 30, left: 30),
                      alignment: Alignment.center,
                      child: Text(
                        "Espera",
                        style: TextStyle(
                          color: Colors.black,
                          //fontFamily: Strings.fontBold,
                          fontSize: 20.0,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 15, right: 30, left: 30),
                      alignment: Alignment.center,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:Colors.black,
                        //  fontFamily: CustomString.fontRegular,
                          fontSize: 15.0,
                        ),
                      )),
                  SizedBox(
                    width: 10,
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                          child: Container(
                            height: 45,
                            child: AnimateButton(
                              pressEvent: () async {
                                Navigator.pop(context);
                              },
                              body: Container(
                                  height: 45,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, //
                                        color: Colors
                                            .white //                  <--- border width here
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: Offset(
                                            1, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'no',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                    //  fontFamily: CustomString.fontSemi,
                                      fontSize: 16.0,
                                    ),
                                  )),
                            ),
                          )),
                      SizedBox(width: 15),
                      Expanded(
                          child: Container(
                            height: 45,
                            child: AnimateButton(
                              pressEvent: () async {
                                Navigator.pop(context);
                                AppSettings.openAppSettings();
                              },
                              body: Container(
                                  height: 45,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, //
                                        color: Colors
                                            .lightBlue //                  <--- border width here
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.lightBlue.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: Offset(
                                            1, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Permitir',
                                    //AppLocalizations.of(context).allow,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                     // fontFamily: CustomString.fontSemi,
                                      fontSize: 16.0,
                                    ),
                                  )),
                            ),
                          )),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                    height: 30,
                  ),
                ],
              )),
          Container(
            alignment: Alignment.center,
            width: 100,
            height: 100,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Image(
                width: 60,
                height: 60,
                image: AssetImage("assets/images/ic_lazy.png")),
          )
        ],
      ),
    );
  }

}
