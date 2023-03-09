import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';

import 'WelcomePage.dart';

class TourPage extends StatefulWidget {
  TourPage({Key? key}) : super(key: key);

  _FirstPageTourState createState() => _FirstPageTourState();
}

class _FirstPageTourState extends State<TourPage> {
  var position = 0;
  final prefs = SharePreference();
  double heightView = 0;

  @override
  Widget build(BuildContext context) {
    heightView = MediaQuery.of(context).size.height * 0.83;
    return Scaffold(
      body: Container(color: CustomColors.white, child: _body(context)),
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
        Image(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.fill,
            image: AssetImage('Assets/images/img_bg_onboarding.png')),
        Column(
          children: [
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: CarouselSlider.builder(
                      itemCount: widgetsTour.length,
                      itemBuilder: (_, int itemIndex, int pageViewIndex) {
                        return widgetsTour[itemIndex];
                      },
                      options: CarouselOptions(
                          height: heightView,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          onPageChanged: (index, changeType) {
                            setState(() {
                              position = index;
                            });
                          }),
                    ),
                  ),
                  _dotsIndicator(),
                  const SizedBox(height: 40),
                  GestureDetector(
                  child: Text(
                  position == 2 ? Strings.nextBtn : Strings.skip,
                  style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  color: CustomColors.blueTitle,
                  fontSize: 18,
                  ),
                  ),
                  onTap: () {
                  prefs.enableTour = false;
                  Navigator.of(context).pushReplacement(PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: WelcomePage(),
                  duration: Duration(milliseconds: 700)));
                  },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ))
          ],
        ),



      ],
    );
  }

  Widget _dotsIndicator() {
    return DotsIndicator(
      dotsCount: 3,
      position: position.toDouble(),
      decorator: DotsDecorator(
        color: CustomColors.grayDot,
        activeColor: CustomColors.redDot,
        size: const Size.square(9.0),
        spacing: EdgeInsets.all(8),
        activeSize: const Size(9.0, 9.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  Widget firstPageTour(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 45),
        Image(
          width: double.infinity,
          height: 350,
          image: AssetImage("Assets/images/on1.png"),
          fit: BoxFit.fitHeight,
        ),
        const SizedBox(height: 25),
        Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                Strings.welcome,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 48,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blueTitle),
              ),
              SizedBox(height: 20),
              Text(
                Strings.welcomeDescription,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.black1),
                textAlign: TextAlign.center,
              ),
              //SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget secondPageTour(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 45),
        Image(
          width: double.infinity,
          height: 350,
          image: AssetImage("Assets/images/on1.png"),
          fit: BoxFit.fitHeight,
        ),
        const SizedBox(height: 25),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                Strings.titleTour1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 48,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blueTitle),
              ),
              SizedBox(height: 20),
              Text(
                Strings.descTour1,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.black1),
                textAlign: TextAlign.center,
              ),
              //SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget thirdPageTour(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 45),
        Image(
          width: double.infinity,
          height: 350,
          image: AssetImage("Assets/images/on1.png"),
          fit: BoxFit.fitHeight,
        ),
        const SizedBox(height: 25),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                Strings.titleTour2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 48,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blueTitle),
              ),
              SizedBox(height: 20),
              Text(
                Strings.descTour2,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.black1),
                textAlign: TextAlign.center,
              ),
              //SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
