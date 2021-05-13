import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wawamko/src/UI/WelcomePage.dart';
import 'package:wawamko/src/UI/login.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';


class TourPage extends StatefulWidget {
  TourPage({Key key}) : super(key: key);

  _FirstPageTourState createState() => _FirstPageTourState();
}

class _FirstPageTourState extends State<TourPage> {

  var position = 0;
  final prefs = SharePreference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: CustomColors.white,
          child: _body(context)
      ) ,
    );
  }

  Widget _body(BuildContext context){
    List<Widget> widgetsTour = [firstPageTour(context),secondPageTour(context),thirdPageTour(context)];
    return Stack(
      children: <Widget>[
        Swiper(
          loop: false,
          itemBuilder: (BuildContext context,int index){
            return widgetsTour[index];
          },
          //indicatorLayout: PageIndicatorLayout.COLOR,
          //autoplay: true,
          //pagination: SwiperPagination(),
          onIndexChanged: (index){
            this.position = index.toInt();
            setState(() {

            });
          },
          //control: SwiperControl(),
          itemCount: widgetsTour.length,
        ),



        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 60),
          child: _dotsIndicator(),
        ),

       Container(
         alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 20),
              child: GestureDetector(
                child: Text(
                  Strings.omitir,
                  style: TextStyle(
                    fontFamily: Strings.fontArial,
                    color: CustomColors.redTour,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                onTap: (){
                  prefs.enableTour = false;
                  Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInLeft, child: WelcomePage(), duration: Duration(milliseconds: 700)));

                },
              ),
            ),

      ],
    );
  }

  Widget _dotsIndicator(){
    return DotsIndicator(
      dotsCount: 3,
      position: position.toDouble(),
      decorator: DotsDecorator(
        color: CustomColors.blueSplash.withOpacity(.4),
        activeColor: CustomColors.blueSplash,
        size: const Size.square(9.0),
        spacing: EdgeInsets.all(4),
        //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        activeSize: const Size(9.0, 9.0),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }


  Widget firstPageTour(BuildContext context){
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              //color: CustomColors.red,
              margin: EdgeInsets.only(top: 0,left: 30),
              height: 331,//MediaQuery.of(context).size.height,
              width: 331,//MediaQuery.of(context).size.width,
              child: Image(

                image: AssetImage("Assets/images/ic_tour1.png"),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 33),
            Container(
              padding: EdgeInsets.only(left: 33,right: 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Strings.welcome,
                    style: TextStyle(
                        fontSize: 19,
                        fontFamily: Strings.fontArial,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.blueTitle
                    ),
                  ),
                  SizedBox(height: 9),
                  Text(
                    Strings.welcomeDescription,
                    style: TextStyle(
                        fontSize: 19,
                        fontFamily: Strings.fontArial,
                        fontWeight: FontWeight.normal,
                        color: CustomColors.grayLetter
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )


          ],
        ),

      ],
    );
  }



  Widget secondPageTour(BuildContext context){
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              //color: CustomColors.red,
              margin: EdgeInsets.only(left: 0,right: 0),
              height: 331,//MediaQuery.of(context).size.height,
              width: double.infinity,//MediaQuery.of(context).size.width,
              child: Image(
                image: AssetImage("Assets/images/ic_photo_2.png"),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 33),
            Container(
              padding: EdgeInsets.only(left: 33,right: 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Strings.welcome,
                    style: TextStyle(
                        fontSize: 19,
                        fontFamily: Strings.fontArial,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.blueTitle
                    ),
                  ),
                  SizedBox(height: 9),
                  Text(
                    Strings.welcomeDescription,
                    style: TextStyle(
                        fontSize: 19,
                        fontFamily: Strings.fontArial,
                        fontWeight: FontWeight.normal,
                        color: CustomColors.grayLetter
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )


          ],
        ),

      ],
    );
  }


  Widget thirdPageTour(BuildContext context){
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              //color: CustomColors.red,
              margin: EdgeInsets.only(left: 0,right: 30),
              height: 331,//MediaQuery.of(context).size.height,
              width: double.infinity,//MediaQuery.of(context).size.width,
              child: Image(
                image: AssetImage("Assets/images/ic_photo_3.png"),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 33),
            Container(
              padding: EdgeInsets.only(left: 33,right: 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Strings.welcome,
                    style: TextStyle(
                        fontSize: 19,
                        fontFamily: Strings.fontArial,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.blueTitle
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 9),
                  Text(

                    Strings.welcomeDescription,
                    style: TextStyle(

                        fontSize: 19,
                        fontFamily: Strings.fontArial,
                        fontWeight: FontWeight.normal,
                        color: CustomColors.grayLetter
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )


          ],
        ),

      ],
    );
  }





}