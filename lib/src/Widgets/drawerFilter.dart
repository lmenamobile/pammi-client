import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/colors.dart';


class DrawerFilterPage extends StatefulWidget {
  @override
  _DrawerFilterPageState createState() => _DrawerFilterPageState();
}

class _DrawerFilterPageState extends State<DrawerFilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white.withOpacity(.7),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: _body(context),
      ),
    );
  }



  Widget _body(BuildContext context){
    return FadeInRight(
      child: Container(

        child: Stack(
          children: <Widget>[
            Positioned(
              top: 33,
              left: 21,
              child: GestureDetector(
                child: Container(
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: CustomColors.blueActiveDots
                  ),
                  child: Center(
                    child: Image(
                      image: AssetImage("Assets/images/ic_menu_x.png"),
                    ),
                  ),
                ),
                onTap: (){

                  Navigator.pop(context);



                  // Navigator.pop(context);
                },

              ),
            ),

            Container(
              width: 286,
              margin: EdgeInsets.only(left: 23,top: 68,right: 52),
              decoration: BoxDecoration(
                  color: CustomColors.grayMenu,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),topRight: Radius.circular(30))
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(width: double.infinity,height: 30,color: CustomColors.red,),
                    Container(width: double.infinity,height: 30,color: CustomColors.red,),
                    Container(width: double.infinity,height: 30,color: CustomColors.red,),
                    Container(width: double.infinity,height: 30,color: CustomColors.red,),
              Container(width: double.infinity,height: 30,color: CustomColors.red,),
                    Container(width: double.infinity,height: 30,color: CustomColors.red,),
                    Container(width: double.infinity,height: 30,color: CustomColors.red,)
                    , Container(width: double.infinity,height: 30,color: CustomColors.red,)


                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );

  }
}
