import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:wawamko/src/UI/addTarjet.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class PayMethodsPage extends StatefulWidget {
  @override
  _PayMethodsPageState createState() => _PayMethodsPageState();
}

class _PayMethodsPageState extends State<PayMethodsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: _body(context),
      ),
    );
  }
  Widget _body(BuildContext context){
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,

        child: Column(
          mainAxisSize: MainAxisSize.max,

          children: <Widget>[
            SizedBox(height: 30),
            Container(
              height: 74,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                  color: CustomColors.white
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 20,
                    top:20,
                    child: GestureDetector(
                      child: Image(
                        width: 30,
                        height: 30,
                        image: AssetImage("Assets/images/ic_blue_arrow.png"),

                      ),
                      onTap: (){Navigator.pop(context);},
                    ),
                  ),

                  Center(
                    child: Container(
                      //alignment: Alignment.center,

                      child: Text(
                        Strings.methodsPay,
                        textAlign: TextAlign.center,
                        style: TextStyle(

                            fontSize: 15,
                            fontFamily: Strings.fontArialBold,
                            color: CustomColors.blackLetter
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
              child: emptyMethods(),
            )
          ],
        ),
      ),
    );
  }


  Widget emptyMethods(){
    return Container(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
       // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Image(
            fit: BoxFit.fill,
            height: 200,
            width:200,
            image: AssetImage("Assets/images/ic_payment.png"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 60,right: 60),
            child: Column(
              children: <Widget>[
                Text(
                  Strings.dontMethodsPay,
                  textAlign: TextAlign.center,
                  style: TextStyle(

                      fontFamily: Strings.fontArialBold,
                      fontSize: 22,
                      color: CustomColors.blueGray

                  ),
                ),

                SizedBox(height: 5),
                Text(
                  Strings.beginShop,
                  textAlign: TextAlign.center,
                  style: TextStyle(

                      fontFamily: Strings.fontArial,
                      fontSize: 15,
                      color: CustomColors.blueGray

                  ),
                ),
                SizedBox(height: 23),
                btnCustomRounded(CustomColors.orange, CustomColors.white, Strings.addTarjet,(){ Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:AddTargetPage(), duration: Duration(milliseconds: 700)));}, context),
                SizedBox(height: 25),
              ],
            ),

          )
        ],
      ),
    );

  }

}
