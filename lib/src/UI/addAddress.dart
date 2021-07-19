import 'dart:async';
import 'dart:convert';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Models/Address/AddresModel.dart';
import 'package:wawamko/src/Models/Address.dart' as model;
import 'package:wawamko/src/Models/Address/GetAddress.dart';
import 'package:wawamko/src/Providers/UserProvider.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/google_place_util.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class AddAddressPage extends StatefulWidget {
  final flagAddress;
  model.Address address;

  AddAddressPage({Key key, this.flagAddress, this.address}) : super(key: key);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage>
    implements GooglePlacesListener {
  final complementContrroller = TextEditingController();
  final nameAddressContrroller = TextEditingController();
  final addressController = TextEditingController();

  GlobalVariables singleton = GlobalVariables();
  NotifyVariablesBloc notifyVariables;

  GooglePlaces googlePlaces;
  var location2 = loc.Location();
  LocationData location;
  var focusNode = FocusNode();
  var editAddress = false;
  bool enableGeoCode = false;
  bool bandLoadingText = false;
  var locationAddress = "";
  var namePlace = "";
  var lat = 0.0;
  var lon = -0.0;
  var latLocation = 0.0;
  var lonLocation = -0.0;

  var cityPlace = "";

  var city = '';

  GoogleMapController mapController;
  CameraPosition _initialPosition;

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {});
  }

  getPermissionGps() async {
    loc.Location location = new loc.Location();
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
        print("OpenApp");
        return;
      }
    }

    if (widget.flagAddress != "update") {
      _locationData = await location.getLocation();
      getLocation(_locationData);
    }
  }

  void getLocation(LocationData locationData) async {
    latLocation = locationData.latitude;
    lonLocation = locationData.longitude;

    singleton.latitude = locationData.latitude;
    singleton.longitude = locationData.longitude;
    CameraPosition updateCamera =
        CameraPosition(target: LatLng(latLocation, lonLocation), zoom: 16.5);
    mapController.moveCamera(CameraUpdate.newCameraPosition(updateCamera));
    setState(() {});
    _geocodeFirstFromCorToAddress();
  }

  loadFieldsAddress() {
    addressController.text = widget.address.address;
    complementContrroller.text = widget.address.complement;
    nameAddressContrroller.text = widget.address.name;
    latLocation = double.parse(widget.address.latitude);
    lonLocation = double.parse(widget.address.longitude);
  }

  @override
  void initState() {
    //
    getPermissionGps();
    googlePlaces = new GooglePlaces(this);
    if (widget.flagAddress == "update") {
      loadFieldsAddress();
    } else {
      latLocation = singleton.latitude;
      lonLocation = singleton.longitude;
      _geocodeFirstFromCorToAddress();
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: _body(context),
        ),
      ),
    );
  }

  openSuggestAddress() {
    FocusScope.of(context).unfocus();
    googlePlaces.findPlace(context);
  }

  Widget boxAddress() {
    return Container(
      width: double.infinity,
      height: 42.7,
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: CustomColors.grayBackground,
          border: Border.all(color: CustomColors.greyBorder, width: 1)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 25,
              height: 25,
              image: AssetImage("Assets/images/ic_location_blue.png"),
            ),
            SizedBox(
              width: 6,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: TextField(
                  focusNode: focusNode,
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 15,
                      color: CustomColors.blackLetter),
                  onTap: () {
                    !editAddress ? openSuggestAddress() : print("is editing");
                  },
                  controller: addressController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 15,
                        color: CustomColors.grayLetter2),
                    hintText: Strings.address,
                    border: InputBorder.none,
                  ),
                  cursorColor: CustomColors.blueSplash,
                ),
              ),
            ),
            SizedBox(
              width: 6,
            ),
            GestureDetector(
              child: Container(
                height: 20,
                child: Text(
                  Strings.change,
                  style: TextStyle(
                      fontSize: 13,
                      color: CustomColors.blackLetter.withOpacity(.6),
                      fontFamily: Strings.fontRegular),
                ),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(focusNode);
                editAddress = true;
              },
            )
          ],
        ),
      ),
    );
  }

  serviceUpdateAddressUser() async {
    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);

        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => DialogLoadingAnimated()));
        Future callResponse = UserProvider.instance.updateAddress(
            context,
            addressController.text ?? "",
            latLocation.toString(),
            lonLocation.toString(),
            complementContrroller.text ?? "",
            nameAddressContrroller.text,
            widget.address);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          ChangeStatusAddressResponse data =
              ChangeStatusAddressResponse.fromJson(decodeJSON);

          if (data.status) {
            Navigator.pop(context);
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context);
            setState(() {});
            utils.showSnackBarError(context, data.message);
          }
        }, onError: (error) {
          print("Ocurrio un error: ${error}");

          Navigator.pop(context);
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  Widget _body(BuildContext context) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("Assets/images/ic_header_red.png"),
                  fit: BoxFit.fill)),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 15,
                top: 15,
                child: GestureDetector(
                  child: Image(
                    width: 40,
                    height: 40,
                    color: Colors.white,
                    image: AssetImage("Assets/images/ic_blue_arrow.png"),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Center(
                child: Container(
                  child: Text(
                    Strings.addAddres,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: Strings.fontRegular,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Stack(
                    children: <Widget>[
                      _map(context),
                      Center(
                        child: Image(
                          fit: BoxFit.fill,
                          width: 35,
                          height: 35,
                          image: AssetImage("Assets/images/ic_location_red.png"),
                        ),
                      ),
                      notifyVariables.showHelpMap
                          ? Positioned(
                        top: 50,
                        right: 50,
                        left: 50,
                        child: helperMap(),
                      )
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 21, right: 21, top: 24, bottom: 24),
                  decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: Column(
                    children: <Widget>[
                      boxAddress(),
                      SizedBox(height: 18.5),
                      textFieldAddress(
                          Strings.complement,
                          "Assets/images/ic_complement.png",
                          complementContrroller, () {
                        editAddress = false;
                      }),
                      SizedBox(height: 18.5),
                      textFieldAddress(
                          Strings.nameAddress,
                          "Assets/images/ic_name_address.png",
                          nameAddressContrroller, () {
                        editAddress = false;
                      }),
                      SizedBox(height: 18.5),
                      Padding(
                        padding: EdgeInsets.only(left: 70, right: 70),
                        child: btnCustomRounded(
                            CustomColors.blueSplash,
                            CustomColors.white,
                            widget.flagAddress == "update"
                                ? Strings.updateAddressButton
                                : Strings.addAddres, () {
                          widget.flagAddress == "update"
                              ? serviceUpdateAddressUser()
                              : serviceAddAddressUser();
                        }, context),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )

      ],
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
                fontFamily: Strings.fontRegular,
                color: CustomColors.gray7),
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
                          fontFamily: Strings.fontRegular,
                          fontSize: 17,
                          color: CustomColors.blackLetter),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hintText,
                          hintStyle: TextStyle(
                              fontFamily: Strings.fontRegular,
                              fontSize: 17,
                              color: CustomColors.gray7.withOpacity(.4))),
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
          color: CustomColors.redBackground),
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
                          fontFamily: Strings.fontRegular,
                          color: CustomColors.orange),
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
            color: backgroungButton),
        child: Center(
          child: Text(
            textButton,
            style: TextStyle(
                fontSize: 14,
                fontFamily: Strings.fontRegular,
                color: textColor),
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
        print("Move Camera");
        FocusScope.of(context).unfocus();
        this.editAddress = false;
        //this.showHelpMap = false;
        lat = camerapos.target.latitude;
        lon = camerapos.target.longitude;
        latLocation = camerapos.target.latitude;
        lonLocation = camerapos.target.longitude;

        print("Lat ${latLocation})");
        print("Lng ${lonLocation}");

        // _geocodeFromCorToAddress();
      },
      onCameraIdle: () {
        print("Iddle camera");
        setState(() {
          if (enableGeoCode) {
            bandLoadingText = true;
          }
        });
        _geocodeFromCorToAddress();
        enableGeoCode = true;
      },
      initialCameraPosition:
          CameraPosition(target: LatLng(latLocation, lonLocation), zoom: 16.5),
      compassEnabled: true,
      rotateGesturesEnabled: false,
      zoomGesturesEnabled: true,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      myLocationEnabled: false,
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
        ),
      },
      onMapCreated: (controller) {
        setState(() {
          mapController = controller;
        });
      },
    );
  }

  _searchLocationByCoordinates() async {
    print("Query" + addressController.text);
    //final coordinates = new Coordinates(lat, lon);
    var addresses =
        await Geocoder.local.findAddressesFromQuery(addressController.text);

    var result = addresses.first;
    latLocation = result.coordinates.latitude;
    lonLocation = result.coordinates.longitude;
    print("Lat:" + "${result.coordinates.latitude}");
    print("Long:" + "${result.coordinates.longitude}");
  }

  bool _validateFields() {
    if (this.addressController.text == "") {
      utils.showSnackBar(context, Strings.emptyAddress);
      return false;
    }
    if (this.complementContrroller.text == "") {
      utils.showSnackBar(context, Strings.emptyComplement);
      return false;
    }

    if (this.nameAddressContrroller.text == "") {
      utils.showSnackBar(context, Strings.emptyNameAddress);
      return false;
    }

    return true;
  }

  serviceAddAddressUser() async {
    if (!_validateFields()) {
      return;
    }

    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);

        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => DialogLoadingAnimated()));
        Future callResponse = UserProvider.instance.addAddress(
            context,
            this.addressController.text,
            this.latLocation.toString(),
            this.lonLocation.toString(),
            complementContrroller.text ?? "",
            nameAddressContrroller.text ?? "");
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          AddressResponse data = AddressResponse.fromJson(decodeJSON);
          if (data.status) {
            Navigator.pop(context);
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context);
            utils.showSnackBarError(context, data.message);
          }
        }, onError: (error) {
          print("Ocurrio un error: ${error}");
          Navigator.pop(context);
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  //Geocode the coordinates to address
  void _geocodeFromCorToAddress() async {
    if (enableGeoCode) {
      final coordinates = new Coordinates(lat, lon);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var result = addresses.first;
      locationAddress = result.addressLine;
      var pos = locationAddress.indexOf(',');
      locationAddress = locationAddress.substring(0, pos);

      city = result.locality;
      //var arrayName = result.
      namePlace = result.thoroughfare;
      latLocation = result.coordinates.latitude;
      lonLocation = result.coordinates.longitude;
      print("Result: ${result.addressLine} ");

      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          addressController.text = locationAddress;

          bandLoadingText = false;
        });
      });
      setState(() {});
    }
  }

  void _geocodeFirstFromCorToAddress() async {
    // if(enableGeoCode){
    final coordinates = new Coordinates(latLocation, lonLocation);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var result = addresses.first;
    locationAddress = result.addressLine;
    var pos = locationAddress.indexOf(',');
    locationAddress = locationAddress.substring(0, pos);

    city = result.locality;
    //var arrayName = result.
    namePlace = result.thoroughfare;
    latLocation = result.coordinates.latitude;
    lonLocation = result.coordinates.longitude;
    print("Result: ${result.addressLine} ");

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        addressController.text = locationAddress;

        //bandLoadingText = false;
      });
    });

    setState(() {});
  }

  @override
  selectedLocation(double lat, double lng, String address, String name,
      String photoReference) {
    setState(() {
      print("____________________!!!!");

      locationAddress = address;
      if (lat != 0.0 && lng != 0.0 && address != '') {
        //  allMarkers.clear();
        //Se adiciona marcador de destino que se selecciono en autocomplete
        // _addMarkerPositionGps(LatLng(lat, lng));
        int indexChar = address.indexOf(",");
        //var addressTitle = address.replaceRange(indexChar, address.length, "");
        var addressSubtitle = address.replaceRange(0, indexChar + 2, "");
        //photoPlace = photo;
        addressController.text = name + " " + cityPlace;
        namePlace = name;
        cityPlace = addressSubtitle;
        city = cityPlace;

        print(namePlace + "city" + cityPlace);

        latLocation = lat;
        lonLocation = lng;

        print("Lat ${latLocation})");
        print("Lng ${lonLocation}");
        enableGeoCode = false;
        FocusScope.of(context).unfocus();
        mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(latLocation, lonLocation),
          //bearing: location.heading,
          zoom: 16.5,
          tilt: 37.0,
        )));
        //photoReferencePlace = photoReference;
        //visibilityItemMap=true;
      }
    });
  }
}
