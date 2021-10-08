import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';



class CoupondsPage extends StatefulWidget {
  @override
  _CoupondsPageState createState() => _CoupondsPageState();
}

class _CoupondsPageState extends State<CoupondsPage> {
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
    return  SingleChildScrollView(
      child: Container(
        //height: MediaQuery.of(context).size.height,

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
                        Strings.coupons,
                        textAlign: TextAlign.center,
                        style: TextStyle(

                            fontSize: 15,
                            fontFamily: Strings.fontBold,
                            color: CustomColors.blackLetter
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(right: 20,left: 20,top: 20),
                width: double.infinity,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 24,
                    itemBuilder: (BuildContext context, int index) {
                      return itemCoupon();

                    }
                )
            ),
            /*Expanded(
              child: emptyInfo("Assets/images/ic_person.png",Strings.ups,Strings.emptyCupons,Strings.addTarjet,context),
            )*/
          ],
        ),
      ),
    );
  }

  Widget itemCoupon(){
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: CustomColors.white,

      ),
      child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 18,right: 120,bottom: 26,top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Wawamko_1",
                    style: TextStyle(
                      fontFamily: Strings.fontBold,
                      fontSize: 18,
                      color: CustomColors.blackLetter
                    ),
                  ),

                  Text(
                    "12/07/2020",
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 14,
                        color: CustomColors.gray8
                    ),
                  ),
                  Text(
                    "Lorem Ipsum is simply dummy text of the printing and",
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 13,
                        color: CustomColors.gray8
                    ),
                  )
                ],
              ),
            ),

            Positioned(
              bottom: 15,
              right: 7,
              child: Container(
                height: 22,
                width: 74,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: CustomColors.blueOne,
                ),
                child: Center(
                  child: Text(
                    "Canjeado",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.white
                    ),
                  )
                ),
              ),
            )
          ],
        ),

    );
  }



}
