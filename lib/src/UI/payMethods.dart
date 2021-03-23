import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:wawamko/src/UI/addTarjet.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
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
       // height: MediaQuery.of(context).size.height,

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
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20,left: 20,top: 20),
                  width: double.infinity,
                  child: ListView.builder(
                  padding: EdgeInsets.only(top: 0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 24,
                  itemBuilder: (BuildContext context, int index) {
                    return itemPayMethod();

                  }
                 )
                ),
                SizedBox(height: 30),
                Padding( padding: EdgeInsets.only(left: 52,right: 52), child: btnCustomRounded(CustomColors.orange, CustomColors.white, Strings.addTarjet,(){Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:AddTargetPage(), duration: Duration(milliseconds: 700)));}, context)),
                SizedBox(height: 30),
              ],
            )
          /*  Expanded(
              child: emptyAdd("Assets/images/ic_payment.png",Strings.dontMethodsPay,Strings.beginShop,Strings.addTarjet,(){Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:AddTargetPage(), duration: Duration(milliseconds: 700)));},context),
            )*/
          ],
        ),
      ),
    );
  }

  Widget itemPayMethod(){
    return GestureDetector(
      child: Container(

        margin: EdgeInsets.only(bottom: 10),
        height: 71,
        decoration: BoxDecoration(

          borderRadius: BorderRadius.all(Radius.circular(21)),
          border: Border.all(color: CustomColors.gray.withOpacity(.1),width: 1.3),
          color: CustomColors.white

        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.only(left: 20,right: 20),

            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image(
                    width: 70,
                    height: 70,
                    fit: BoxFit.fill,
                    image:AssetImage("Assets/images/ic_express.png")
                ),
                SizedBox(width: 17),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          "**** **** **** 3655",
                        style: TextStyle(
                          fontFamily: Strings.fontArialBold,
                          fontSize: 17,
                          color: CustomColors.blackLetter
                        ),
                      ),
                       Text(
                          Strings.masterCard,
                          style: TextStyle(
                            fontSize: 14,
                            color: CustomColors.purpleOpacity,
                            fontFamily: Strings.fontArial
                          ),


                      ),
                      
                    ],
                  ),
                ),
               GestureDetector(
                      child: Container(


                        child: Image(

                          width:20,
                          height: 20,
                          image: AssetImage("Assets/images/ic_garbage.png"),
                        ),
                      ),
                 onTap: (){
                        utils.startCustomAlertMessage(context, "Eliminar tarjeta", "Assets/images/ic_trash_big.png", "¿Seguro que deseas eliminar este medio de pago?", (){Navigator.pop(context);},(){Navigator.pop(context);});
                 },
                  ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }





}
