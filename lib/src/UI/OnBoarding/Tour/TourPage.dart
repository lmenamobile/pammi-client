import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';

import 'WelcomePage.dart';

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
          child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    List<Widget> widgetsTour = [
      firstPageTour(context),
      secondPageTour(context),
      thirdPageTour(context)
    ];
    return Stack(
      children: <Widget>[
        Swiper(
          loop: false,
          itemBuilder: (BuildContext context, int index) {
            return widgetsTour[index];
          },
          onIndexChanged: (index) {
            this.position = index.toInt();
            setState(() {});
          },
          itemCount: widgetsTour.length,
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 70),
          child: _dotsIndicator(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 40),
          child: GestureDetector(
            child: Text(
             position==2? Strings.nextBtn: Strings.skip,
              style: TextStyle(
                fontFamily: Strings.fontBold,
                color: CustomColors.redTour,
                fontSize: 18,
              ),
            ),
            onTap: () {
              prefs.enableTour = false;
              Navigator.of(context).pushReplacement(PageTransition(
                  type: PageTransitionType.slideInLeft,
                  child: WelcomePage(),
                  duration: Duration(milliseconds: 700)));
            },
          ),
        ),
      ],
    );
  }

  Widget _dotsIndicator() {
    return DotsIndicator(
      dotsCount: 3,
      position: position.toDouble(),
      decorator: DotsDecorator(
        color: CustomColors.blueSplash.withOpacity(.4),
        activeColor: CustomColors.blueSplash,
        size: const Size.square(9.0),
        spacing: EdgeInsets.all(4),
        activeSize: const Size(9.0, 9.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  Widget firstPageTour(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(left: 20),
            child: Image(
              image: AssetImage("Assets/images/ic_tour1.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(height: 30,),
        Container(
          padding: EdgeInsets.only(left: 33, right: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                Strings.welcome,
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blueTitle),
              ),
              SizedBox(height: 9),
              Text(
                Strings.welcomeDescription,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.grayLetter),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget secondPageTour(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Image(
            image: AssetImage("Assets/images/ic_photo_2.png"),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 33),
        Container(
          padding: EdgeInsets.only(left: 33, right: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                Strings.welcome,
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blueTitle),
              ),
              SizedBox(height: 9),
              Text(
                Strings.welcomeDescription,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.grayLetter),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget thirdPageTour(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(right: 30),
            child: Image(
              image: AssetImage("Assets/images/ic_photo_3.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(height: 33),
        Container(
          padding: EdgeInsets.only(left: 33, right: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                Strings.welcome,
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blueTitle),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 9),
              Text(
                Strings.welcomeDescription,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.grayLetter),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      ],
    );
  }
}
