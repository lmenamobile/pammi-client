import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import '../Widgets.dart';
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
      body: Container(color: AppColors.white, child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    List<Widget> widgetsTour = [firstPageTour(context), secondPageTour(context), thirdPageTour(context)];

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
                            setState(() {position = index;});
                          }),
                    ),
                  ),
                  dotsIndicator(position),
                  const SizedBox(height: 40),
                  GestureDetector(
                  child: Text(position == 2 ? Strings.nextBtn : Strings.skip, style: TextStyle(fontFamily: Strings.fontRegular, color: AppColors.blueTitle, fontSize: 18,),),
                  onTap: () {
                    prefs.enableTour = false;
                    Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.leftToRight, child: WelcomePage(), duration: Duration(milliseconds: 700)));
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
  }
