import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:wawamko/src/UI/listProductByCategorie.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

class ProductsByCategoriePage extends StatefulWidget {
  @override
  _ProductsByCategoriePageState createState() => _ProductsByCategoriePageState();
}

class _ProductsByCategoriePageState extends State<ProductsByCategoriePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteBackGround,
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
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: header(),
        ),
        Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(

              width: double.infinity,

              child:  ListView.builder(
                padding: EdgeInsets.only(top: 0,bottom: 20),
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  //return //itemCategorie();
                  return itemProductByCategorie();

                },


              ),
            )




        )

      ],
    );
  }


  Widget header(){
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
          color: CustomColors.white
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 20,
            top:50,
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
              margin: EdgeInsets.only(top: 30),
              //alignment: Alignment.center,

              child: Text(
                "Tecnología",
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
    );
  }

  Widget itemProductByCategorie(){
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: CustomColors.gray.withOpacity(.3),width: 1),
          color: CustomColors.white
        ),
        width: double.infinity,
        height: 63,
        margin: EdgeInsets.only(left: 20,right: 20,top: 20),
        padding: EdgeInsets.only(left: 30,right: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                "Computadores",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: Strings.fontArial,
                  color: CustomColors.blackLetter
                ),
              ),
            ),
            Image(
              width: 25,
              height: 25,
              fit: BoxFit.fill,
              image: AssetImage("Assets/images/ic_arrow.png"),
            )
          ],
        ),
      ),
      onTap: (){
        Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:ListProductByCategories(), duration: Duration(milliseconds: 700)));

      },
    );
  }
}
