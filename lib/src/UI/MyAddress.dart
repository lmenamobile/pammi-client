import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:wawamko/src/UI/addAddress.dart';
import 'package:wawamko/src/UI/addTarjet.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class MyAddressPage extends StatefulWidget {
  @override
  _MyAddressPageState createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
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
                        Strings.myAddress ,
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
              child: emptyAdd("Assets/images/ic_receive.png", Strings.questionAddress, Strings.beginAddAddress, Strings.addAddres,(){Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:AddAddressPage(), duration: Duration(milliseconds: 700)));}, context),
            )
          ],
        ),
      ),
    );
  }
}
