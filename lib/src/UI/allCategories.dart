import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wawamko/src/UI/productsByCategorie.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class AllCategoriesPage extends StatefulWidget {
  @override
  _AllCategoriesPageState createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {

  final searchController = TextEditingController();
  
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
          child: headerCategories(),
        ),
        Positioned(
          top: 170,
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
                  return itemCategorie();

                },


            ),
          )
        )

      ],
    );
  }
  Widget headerCategories(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25)),
        color: CustomColors.white
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 37,left: 28,right: 28),
        child: Container(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Image(
                      image: AssetImage("Assets/images/ic_blue_arrow.png"),
                      fit: BoxFit.fill,
                      width: 30,
                      height: 30,
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                   Image(
                      width: 110,
                      height: 35,
                      image: AssetImage("Assets/images/ic_logo_black.png"),
                      fit: BoxFit.fill,

                  ),
                  GestureDetector(
                    child: Image(
                      width: 30,
                      height: 30,
                      image: AssetImage("Assets/images/ic_shopping_blue-1.png"),
                    ),
                  )
                ],
              ),
              SizedBox(height: 25),
              boxSearch(context),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget boxSearch(BuildContext context){
    return Container(
      height: 47,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: CustomColors.grayBackground
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Image(
                width: 20,
                height: 20,
                image: AssetImage("Assets/images/ic_seeker.png"),
              ),
            ),
            Expanded(
              child: TextField(
                controller: searchController,
                style: TextStyle(
                    fontFamily: Strings.fontArial,
                    fontSize: 15,
                    color: CustomColors.blackLetter
                ),
                decoration: InputDecoration(
                    hintText: "Buscar",
                    isDense: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontFamily: Strings.fontArial,
                        fontSize: 15,
                        color: CustomColors.grayLetter
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );

  }
  Widget itemCategorie(){
    return GestureDetector(
      child: Container(
        height: 63,
        padding: EdgeInsets.only(left: 10,right: 10),
        width: double.infinity,
        margin: EdgeInsets.only(top: 20,left: 20,right: 20),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.all(Radius.circular(9)),
          border: Border.all(color: CustomColors.gray.withOpacity(.3),width: 1),
        ),
        child: Center(
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: <Widget>[
              Image(
                width: 55,
                height: 55,
                image: AssetImage("Assets/images/ic_sport.png"),
              ),
             SizedBox(width: 10),
             Expanded(
               child: Text(
                 "Tecnologia",
                 style: TextStyle(
                   fontFamily: Strings.fontArial,
                   fontSize: 14,
                   color: CustomColors.blackLetter
                 ),
               ),
             ),
             Image(
               width: 30,
               height: 30,
               image: AssetImage("Assets/images/ic_arrow.png"),
             )
           ],
          ),
        ),
      ),
      onTap: (){
        Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:ProductsByCategoriePage(), duration: Duration(milliseconds: 700)));
      },
    );
  }

}
