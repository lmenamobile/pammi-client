import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:wawamko/src/UI/Onboarding/VerificationCode.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class ConfirmationSlidePage extends StatefulWidget {

  final String email,name;
  ConfirmationSlidePage({Key key,@required this.email,@required this.name}) : super(key: key);
  @override
  _ConfirmationSlidePageState createState() => _ConfirmationSlidePageState();
}

class _ConfirmationSlidePageState extends State<ConfirmationSlidePage> {
  SharePreference prefs = SharePreference();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.4),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context){
    return Stack(
      children: <Widget>[
        GestureDetector(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            color: CustomColors.blackLetter.withOpacity(.3),
          ),
          onTap: (){Navigator.pop(context);},
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SlideInUp(
            child: Container(

              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 40,right: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 36,),
                    Image(
                      width: 60,
                      height: 60,
                      color: CustomColors.blueSplash,
                      image: AssetImage("Assets/images/ic_accep_big.png"),
                    ),
                    SizedBox(height: 11),
                    Text(
                      Strings.welcome2,
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: Strings.fontRegular,
                        color: CustomColors.blackLetter
                      ),
                    ),
                    Text(
                      "¡"+widget.name+"!",
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: Strings.fontBold,
                          color: CustomColors.blackLetter
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                     // margin: EdgeInsets.only(left: 10,right: 10),
                      color: CustomColors.grayBackground,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(height: 20),
                    Text(
                        Strings.sendCode,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 17,
                        color: CustomColors.letterGray
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 50,right: 50),
                      child: btnCustomRounded(CustomColors.blueSplash, CustomColors.white, Strings.verifyCode, (){
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(context,customPageTransition(VerificationCodePage(email: widget.email,typeView: Constants.isViewRegister,)) , (route) => false);

                        },context),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        )

      ],
    );
  }
}
