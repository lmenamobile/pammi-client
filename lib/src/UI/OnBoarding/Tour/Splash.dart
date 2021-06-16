
import 'package:flutter/material.dart';
import 'package:location/location.dart' as GPS;
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/Home/HomePage.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
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
    callAccessToken();
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
      if(await Permission.location.isGranted){
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
      bool status = await showCustomAlertDialog(context,Strings.titleGPS,Strings.textInformationGPS);
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
  }

  void openApp() async{
    GPS.LocationData locationData;
    locationData = await location.getLocation();
    getLocation(locationData);
    if (prefs.dataUser == "0") {
      if (prefs.enableTour == false) {
        Navigator.pushReplacement(context, customPageTransition(WelcomePage()));
      } else {
        Navigator.of(context).pushReplacement(customPageTransition(TourPage()));
      }
    } else {
      Navigator.pushReplacement(context, customPageTransition(MyHomePage()));
    }
  }

  callAccessToken() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerOnboarding.getAccessToken();
        await callUser.then((token) {

        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
