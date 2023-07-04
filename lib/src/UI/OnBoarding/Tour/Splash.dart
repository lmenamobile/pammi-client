
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as GPS;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/Home/HomePage.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'TourPage.dart';
import 'WelcomePage.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin, WidgetsBindingObserver {
  final prefs = SharePreference();
  GlobalVariables singleton = GlobalVariables();
  late OnboardingProvider providerOnboarding;
  late AnimationController _controller;
  late Animation<double> _animation;
  var location = GPS.Location();
  bool stateGps = false;
  bool permissionGps = false;
  bool bandGps = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    callAccessToken();

    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);

    _controller.addStatusListener((AnimationStatus status) async {
      if(status==AnimationStatus.completed){
        bool result = await getPermissionGps();
      }
    });
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _controller.forward();
    super.initState();
  }

  @override
  dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    prefs.sizeHeightHeader = MediaQuery.of(context).padding.top;
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
       /* Positioned(
          bottom: -380,
          left: -290,
          right: -40,
          child: Container(
            height: 700,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: CustomColors.redSplash2),
          ),*/
        Container(
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: _animation,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 70, right: 70),
              child: Image(
                height: 60,
                image: AssetImage("Assets/images/ic_logo.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        /*Positioned(
          top: -400,
          left: -150,
          right: 20,
          child: Container(
            height: 600,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: CustomColors.redSplash2),
          ),
        ),*/
      ],
    );
  }



  Future<bool> getPermissionGps() async {
    bool _serviceEnabled;
    LocationPermission _permissionGranted;
    Position _position;

    try {
      _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await Geolocator.openLocationSettings();
        if (!_serviceEnabled) {
          return false;
        }
      }

      _permissionGranted = await Geolocator.checkPermission();
      if (_permissionGranted == LocationPermission.denied ||
          _permissionGranted == LocationPermission.deniedForever) {
        _permissionGranted = await Geolocator.requestPermission();
        if (_permissionGranted != LocationPermission.whileInUse &&
            _permissionGranted != LocationPermission.always) {
          openApp();
          return false;
        }
      }

      _position = await Geolocator.getCurrentPosition();
      getLocation(_position);
      return true;
    } catch (e) {
      var y = e.toString();
      openApp();
      return false;
    }
  }

  void getLocation(Position position) async {
    singleton.latitude = position.latitude ?? 0;
    singleton.longitude = position.longitude ?? 0;
    openApp();
  }

/*
  Future<bool> getPermissionGps() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    try{
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return false;
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          openApp();
          return true;
        }
      }
      bandGps = true;
      _locationData = await location.getLocation();
      bandGps = false;
      getLocation(_locationData);
      return true;
    }on PlatformException catch (e){
      var y = e.message;
      openApp();
      return false;
    }
  }

  void getLocation(LocationData locationData) async {
    singleton.latitude = locationData.latitude??0;
    singleton.longitude = locationData.longitude??0;
    openApp();
  }
  */
  void openApp() async{
   // GPS.LocationData locationData;
    //locationData = await location.getLocation();
    //getLocation(locationData);
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
