import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';


class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final addresController = TextEditingController();
  final complementContrroller = TextEditingController();
  GlobalVariables singleton = GlobalVariables();
  NotifyVariablesBloc notifyVariables;

  LocationData location;
  var locationAddress = "";
  var lat = 0.0;
  var lon = -0.0;

  var latLocation = 0.0;
  var lonLocation = -0.0;


  var city = '';
  GoogleMapController mapController;
  CameraPosition _initialPosition;


  Completer<GoogleMapController> _controller = Completer();

  //static LatLng _center = const LatLng(singleton.latitude.toDouble(), -122.67);

  void _onCameraMove(CameraPosition position) {
    //  _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    // final OrderModel order = ModalRoute.of(context).settings.arguments;
    _controller.complete(controller);
    setState(() {
      /*_markers.add(Marker(
        markerId: MarkerId("domi"),
        position: LatLng(singleton.latitude,singleton.longitude),
        infoWindow: InfoWindow(
          title: "",
          snippet:"",

        ),
        icon: myIcon,
      ));*/

      /* _markers.add(Marker(
        markerId: MarkerId("store"),

        position: LatLng(widget.order.shop.latitude ?? 0.0,widget.order.shop.longitude ?? 0.0),
        infoWindow: InfoWindow(
          title: widget.order.shop.name ?? "",
          snippet: "",

        ),

        icon: storeIcon,
      ));*/
    });
  }

  @override
  void initState() {
    latLocation = singleton.latitude;
    lonLocation = singleton.longitude;
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: double.infinity,
        child: _body(context),
      ),
    );
  }



  Widget _body(BuildContext context) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.6,
                child: Stack(
                  children: <Widget>[
                    _map(context),
                    /* GoogleMap(
                        onMapCreated: _onMapCreated,

                        onCameraMove: _onCameraMove,
                        initialCameraPosition:CameraPosition(
                            target: LatLng(singleton.latitude,singleton.longitude),
                            zoom: 16.0
                        )// _initialPosition,

                    ),*/
                    Center(
                      child: Image(
                        fit: BoxFit.fill,
                        width: 35,
                        height: 35,
                        image: AssetImage("Assets/images/ic_location_red.png"),
                      ),
                    ),
                    notifyVariables.showHelpMap ? Positioned(
                      bottom: 94,
                      right: 50,
                      left: 50,
                      child: helperMap(),
                    ) : Container(),
                    Positioned(
                      bottom: 22,
                      left: 60,
                      right: 60,
                      child: btnConfirmAddress(
                          CustomColors.blueProfile, CustomColors.white,
                          Strings.confirm, () {_searchLocationByCoordinates(); }, context),
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      color: CustomColors.white
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(

                        height: 74,
                        width: double.infinity,

                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 20,
                              top: 20,
                              child: GestureDetector(
                                child: Image(
                                  width: 30,
                                  height: 30,
                                  image: AssetImage(
                                      "Assets/images/ic_blue_arrow.png"),

                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),

                            Center(
                              child: Container(
                                //alignment: Alignment.center,

                                child: Text(
                                  Strings.myAddress,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(

                                      fontSize: 15,
                                      fontFamily: Strings.fontArialBold,
                                      color: CustomColors.blackLetter
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 31),
                      Container(
                        width: double.infinity,


                        child: Padding(
                          padding: EdgeInsets.only(left: 40, right: 35),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              itemAddAddres(Strings.address,
                                  "Assets/images/ic_location_blue.png",
                                  Strings.address, addresController),
                              SizedBox(height: 20.5),
                              itemAddAddres(Strings.complement,
                                  "Assets/images/ic_home.png",
                                  Strings.complement, complementContrroller),
                              SizedBox(height: 35),

                            ],
                          ),
                        ),

                      ),
                      SizedBox(height: 20),

                    ],
                  ),
                ),


              ],
            ),


          ],
        ),


      ),
    );
  }


  Widget itemAddAddres(String labelTitle, String image, String hintText,
      TextEditingController controller) {
    return Container(
      width: double.infinity,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            labelTitle,
            style: TextStyle(
                fontSize: 15,
                fontFamily: Strings.fontArial,
                color: CustomColors.grayLetter
            ),
          ),

          Row(
            children: <Widget>[
              Image(
                image: AssetImage(image),
                width: 25,
                height: 25,
                fit: BoxFit.fill,

              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: controller,
                      style: TextStyle(
                          fontFamily: Strings.fontArial,
                          fontSize: 17,
                          color: CustomColors.blackLetter
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hintText,
                          hintStyle: TextStyle(
                              fontFamily: Strings.fontArial,
                              fontSize: 17,
                              color: CustomColors.grayLetter.withOpacity(.4)

                          )
                      ),
                    ),
                    Container(
                      height: 2,
                      color: CustomColors.blueActiveDots,
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget helperMap() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
          border: Border.all(color: CustomColors.orange, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: CustomColors.redBackground

      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 9,
            right: 9,
            child: GestureDetector(
              child: Image(
                width: 12,
                height: 12,
                image: AssetImage("Assets/images/ic_close_red.png"),
                fit: BoxFit.fill,
              ),
              onTap: () {
                notifyVariables.showHelpMap = false;
              },
            ),
          ),
          Center(
            child: Container(

              //width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: Image(
                      image: AssetImage("Assets/images/ic_pin.png"),
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,

                    ),
                    onTap: () {},
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      Strings.helpMap,
                      style: TextStyle(
                          fontSize: 11,
                          fontFamily: Strings.fontArial,
                          color: CustomColors.orange
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),


        ],
      ),

    );
  }


  Widget btnConfirmAddress(Color backgroungButton, Color textColor,
      String textButton, Function action, BuildContext context) {
    return SpringButton(
      SpringButtonType.OnlyScale,

      Container(
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            color: backgroungButton
        ),
        child: Center(
          child: Text(
            textButton,
            style: TextStyle(
                fontSize: 14,
                fontFamily: Strings.fontArial,
                color: textColor
            ),
          ),
        ),
      ),
      onTapUp: (_) {
        action();
      },
    );
  }


  //View map
  Widget _map(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      onCameraMove: (CameraPosition camerapos) {
        lat = camerapos.target.latitude;
        lon = camerapos.target.longitude;
      },
      onCameraIdle: () {
        _geocodeFromCorToAddress();
      },
      initialCameraPosition: CameraPosition(target: LatLng(latLocation, lonLocation),zoom: 16.5),
      compassEnabled: true,
      rotateGesturesEnabled: false,
      zoomGesturesEnabled: true,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      myLocationEnabled: false,
      onMapCreated: (controller) {
        setState(() {
          mapController = controller;
        });
      },
    );
  }

  _searchLocationByCoordinates() async {
    print("Query"+addresController.text);
    //final coordinates = new Coordinates(lat, lon);
    var addresses = await Geocoder.local.findAddressesFromQuery(addresController.text);

    var result = addresses.first;
    latLocation = result.coordinates.latitude;
    lonLocation = result.coordinates.longitude;
    print("Lat:"+"${result.coordinates.latitude}");
    print("Long:"+"${result.coordinates.longitude}");






  }

  //Geocode the coordinates to address
  void _geocodeFromCorToAddress() async {
    final coordinates = new Coordinates(lat, lon);

    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);

    var result = addresses.first;
    locationAddress = result.addressLine;
    var pos = locationAddress.indexOf(',');
    locationAddress = locationAddress.substring(0, pos);
    city = result.locality;
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
       // addresController.text = city;
        addresController.text = locationAddress;
        //bandLoadingText = false;
      });
    });
    setState(() {});
  }
}
