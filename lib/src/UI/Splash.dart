import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:location/location.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';

import 'package:wawamko/src/UI/HomePage.dart';
import 'package:wawamko/src/UI/TourPage.dart';
import 'package:wawamko/src/UI/login.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}



class _SplashPageState extends State<SplashPage> {

  final prefs = SharePreference();
  GlobalVariables singleton = GlobalVariables ();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomColors.splashColor,
        child: _body(context),

      ),
    );
  }




  Widget _body(BuildContext context){

    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image(
            image: AssetImage("Assets/images/splash.png"),
            fit: BoxFit.fill,
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

    super.initState();
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


  void openApp(){

    if (prefs.dataUser == "0") {
      if (prefs.enableTour == false) {
        Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInLeft, child:LoginPage(), duration: Duration(milliseconds: 700)));
        // Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInLeft, curve: Curves.decelerate, duration: Duration(milliseconds: 600), child: WelcomePage()));
      }else{
        Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInLeft, child: TourPage(), duration: Duration(milliseconds: 700)));

      }
    } else {
      Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInLeft, curve: Curves.decelerate, duration: Duration(milliseconds: 500), child: MyHomePage()));

      // }
    }
  }

  _serviceAccesToken() async {
    utils.checkInternet().then((value) async {
      if (value) {
        //utils.startProgress(context);
        Future callUser = OnboardingProvider.instance.generateAccesToken(context);
        await callUser.then((user) {

          var decodeJSON = jsonDecode(user);

          ResponseAccessToken data = ResponseAccessToken.fromJsonMap(decodeJSON);

          if(data.code.toString() == "100") {
            // Navigator.pop(context);
            prefs.accessToken = data.data.accessToken;



            // Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child: HomePage(), duration: Duration(milliseconds: 700)));
            //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BaseNavigationPage()), (Route<dynamic> route) => false);
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
