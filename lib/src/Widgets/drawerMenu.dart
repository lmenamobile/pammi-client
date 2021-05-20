import 'dart:io';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:wawamko/src/UI/Featured.dart';
import 'package:wawamko/src/UI/HelpSupport.dart';
import 'package:wawamko/src/UI/HomePage.dart';
import 'package:wawamko/src/UI/MyOrders.dart';
import 'package:wawamko/src/UI/dayOferts.dart';
import 'package:wawamko/src/UI/profile.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../UI/Onboarding/login.dart';




class DraweMenuPage extends StatefulWidget {

  final rollOverActive;

  DraweMenuPage({Key key,this.rollOverActive}) : super(key: key);

  _DraweMenuPageState createState() => _DraweMenuPageState();
}

class _DraweMenuPageState extends State<DraweMenuPage> {

 var hideMenu = false;
 SharePreference _prefs = SharePreference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.white.withOpacity(.5),
        body: Container(

          width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: _body(context)
        ),

    );
  }

  Widget _body(BuildContext context){
    return  FadeInLeft(

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
                        padding: EdgeInsets.only(top: 12,bottom: 12),
                        decoration: BoxDecoration(
                          color: CustomColors.grayMenu,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),topRight: Radius.circular(30))
                        ),
                        child: SingleChildScrollView(

                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                             itemProfile(context),

                             SizedBox(height: 23),
                             itemMenu(context,"Assets/images/ic_start.png", (){widget.rollOverActive != "start" ?  pushToPage(MyHomePage()) :Navigator.pop(context);},Strings.start),

                             itemMenu(context,"Assets/images/ic_ offers_day.png", (){widget.rollOverActive != "ofertsDay" ? pushToPage(DayOferstPage()) : Navigator.pop(context);}, Strings.dayOferts),

                             itemMenu(context,"Assets/images/ic_featured.png", (){widget.rollOverActive != "featured" ?  pushToPage(FeaturedPage()) :Navigator.pop(context);},Strings.destacados ),

                             itemMenu(context,"Assets/images/ic_news.png", (){widget.rollOverActive != "myOrders" ?  pushToPage(MyOrdersPage()) :Navigator.pop(context);},Strings.myOrders ),

                             itemMenu(context,"Assets/images/ic_wishes.png", (){},Strings.wishes ),

                             itemMenu(context,"Assets/images/ic_ notification.png", (){},Strings.notifications ),
                             SizedBox(height: 25),
                             itemMenu(context,"Assets/images/ic_support.png", (){widget.rollOverActive != "support" ?  pushToPage(SupportHelpPage()) :Navigator.pop(context);},Strings.supportservices ),
                             SizedBox(height: 17),
                             Padding(
                               padding: const EdgeInsets.only(left: 39,right: 39),
                               child: btnCustomRounded(CustomColors.orange, CustomColors.white,Strings.closeSesion, (){utils.startCustomAlertMessage(context, Strings.closeSesion, "Assets/images/ic_exit.png", Strings.closeSesionText, (){_prefs.dataUser = "0"; Navigator.pop(context);  Navigator.pop(context); Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInUp, child:LoginPage(), duration: Duration(milliseconds: 700))); }, (){Navigator.pop(context);});},context),
                             ),
                              SizedBox(height: 16),



                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ),


    );

  }

  Widget itemProfile(BuildContext context){
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        height: 63,
        margin: EdgeInsets.only(left: 6,right: 6,top: 6),
        child: Padding(
          padding: EdgeInsets.only(left: 25,right: 25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: CustomColors.grayBackground,

                ),
                child: Center(
                  child: Image(
                    fit: BoxFit.fill,
                    image: AssetImage("Assets/images/ic_default_perfil.png"),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Jhonathan Belmonte",
                      style: TextStyle(
                        fontFamily: Strings.fontBold,
                        fontSize: 12,
                        color: CustomColors.letterDarkBlue
                      ),
                    ),

                    Text(
                      Strings.seeProfile,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                          fontFamily: Strings.fontBold,
                          fontSize: 12,
                          color: CustomColors.yellow
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){

       widget.rollOverActive == "profile" ? Navigator.pop(context) : Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInLeft, child:ProfilePage(), duration: Duration(milliseconds: 700)));



      },
    );
  }

  Widget itemMenu(BuildContext context, String icon, Function action,String titleAction){
    return GestureDetector(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 30,right: 30),
        height: 63,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: CustomColors.grayBackground,
                border: Border.all(color:  CustomColors.gray.withOpacity(.3),width: 1),

              ),
              child: Center(
                child: Image(
                  width: 23,
                  height: 23,
                  fit: BoxFit.fill,
                  image: AssetImage(icon),
                ),
              ),
            ),

            SizedBox(width: 12),

            Text(
              titleAction,
              style: TextStyle(
                fontSize: 12,
                fontFamily: Strings.fontBold,
                color: CustomColors.blackLetter
              ),
            )
          
          ],
        ),
      ),
      onTap: (){
        action();
      },
    );
  }

 pushToPage(Widget page)async{
   var data = await Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInLeft, child:page, duration: Duration(milliseconds: 700)));

   if(data!=null){
     if(data){
       Navigator.pop(context);

     }

   }
 }

}
