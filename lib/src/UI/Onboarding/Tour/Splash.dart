import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart' as GPS;
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/HomePage.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import 'TourPage.dart';
import 'WelcomePage.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin, WidgetsBindingObserver {
  final prefs = SharePreference();
  GlobalVariables singleton = GlobalVariables();
  OnboardingProvider providerOnboarding;
  AnimationController _controller;
  Animation<double> _animation;
  var location = GPS.Location();
  bool stateGps = false;
  bool permissionGps = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _serviceAccesToken();
    Future.delayed(Duration(milliseconds: 2000), () {validatePermissions();});
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _controller.forward();
    super.initState();
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    if(AppLifecycleState.resumed==state){
      if( await location.serviceEnabled() && await Permission.location.isGranted){
        openApp();
      }
    }
  }


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

  validatePermissions()async{
    stateGps = await location.serviceEnabled();
    if(stateGps) {
      final status = await Permission.location.request();
      statusPermissionsGPS(status);
    }else{
      print("gps desactivado");
    }
  }

  statusPermissionsGPS(PermissionStatus status)async {
    switch (status) {
      case PermissionStatus.granted:
        openApp();
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.undetermined:
        openAppSettings();
        break;
    }
  }

  void getLocation(GPS.LocationData locationData) async {
    singleton.latitude = locationData.latitude;
    singleton.longitude = locationData.longitude;
    openApp();
  }

  void openApp() async{
    GPS.LocationData locationData;
    locationData = await location.getLocation();
    getLocation(locationData);
    if (prefs.dataUser == "0") {
      if (prefs.enableTour == false) {
        Navigator.pushReplacement(context, customPageTransition(WelcomePage()));
      } else {
        Navigator.pushReplacement(context, customPageTransition(TourPage()));
      }
    } else {
      Navigator.pushReplacement(context, customPageTransition(MyHomePage()));
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
          } else {}
        }, onError: (error) {});
      } else {
        print("you has not internet");
      }
    });
  }
}
