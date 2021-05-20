import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';

import 'package:wawamko/src/UI/HomePage.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';

import 'TourPage.dart';
import 'WelcomePage.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final prefs = SharePreference();
  GlobalVariables singleton = GlobalVariables();
  OnboardingProvider providerOnboarding;
  AnimationController _controller;
  Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomColors.redTour,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: -380,
          left: -290,
          right: -40,
          child: Container(
            height: 700,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: CustomColors.redSplash2),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: _animation,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 70, right: 70),
              child: Image(
                height: 60,
                image: AssetImage("Assets/images/ic_logo_email.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Positioned(
          top: -400,
          left: -150,
          right: 20,
          child: Container(
            height: 600,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: CustomColors.redSplash2),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      _serviceAccesToken();
      getPermissionGps();
    });
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _controller.forward();
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  getPermissionGps() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        openApp();
        return;
      }
    }
    _locationData = await location.getLocation();
    getLocation(_locationData);
  }

  void getLocation(LocationData locationData) async {
    singleton.latitude = locationData.latitude;
    singleton.longitude = locationData.longitude;
    openApp();
  }

  void openApp() {
    if (prefs.dataUser == "0") {
      if (prefs.enableTour == false) {
        Navigator.of(context).pushReplacement(PageTransition(
            type: PageTransitionType.slideInLeft,
            child: WelcomePage(),
            duration: Duration(milliseconds: 700)));
      } else {
        Navigator.of(context).pushReplacement(PageTransition(
            type: PageTransitionType.slideInLeft,
            child: TourPage(),
            duration: Duration(milliseconds: 700)));
      }
    } else {
      Navigator.of(context).pushReplacement(PageTransition(
          type: PageTransitionType.slideInLeft,
          curve: Curves.decelerate,
          duration: Duration(milliseconds: 500),
          child: MyHomePage()));
    }
  }

  _serviceAccesToken() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerOnboarding.generateAccesToken(context);
        await callUser.then((user) {
          var decodeJSON = jsonDecode(user);

          ResponseAccessToken data =
              ResponseAccessToken.fromJsonMap(decodeJSON);

          if (data.code.toString() == "100") {
            prefs.accessToken = data.data.accessToken;
          } else {
            //  Navigator.pop(context);
          }
        }, onError: (error) {
          // Navigator.pop(context);
        });
      } else {
        print("you has not internet");
      }
    });
  }
}