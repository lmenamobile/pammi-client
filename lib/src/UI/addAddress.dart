import 'dart:async';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Models/Address/AddresModel.dart';
import 'package:wawamko/src/Models/Address.dart' as model;
import 'package:wawamko/src/Models/Address/GetAddress.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/UserProvider.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/google_place_util.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'SearchCountryAndCity/SelectStates.dart';

class AddAddressPage extends StatefulWidget {
  final flagAddress;
  model.Address? address;

  AddAddressPage({Key? key, this.flagAddress, this.address}) : super(key: key);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage>
    implements GooglePlacesListener {
  final complementController = TextEditingController();
  final nameAddressController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final prefs = SharePreference();
  GlobalVariables singleton = GlobalVariables();
  late NotifyVariablesBloc notifyVariables;

  late GooglePlaces googlePlaces;
  var location2 = loc.Location();
  LocationData? location;
  var focusNode = FocusNode();
  var editAddress = false;
  bool enableGeoCode = false;
  bool bandLoadingText = false;
  String? locationAddress = "";
  String? namePlace = "";
  var lat = 0.0;
  var lon = -0.0;
  double? latLocation = 0.0;
  double? lonLocation = -0.0;

  var cityPlace = "";
  String? city = '';

  late GoogleMapController mapController;
  CameraPosition? _initialPosition;

  Completer<GoogleMapController> _controller = Completer();
  ProviderSettings? providerSettings;

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
    CameraPosition updateCamera = CameraPosition(target: LatLng(latLocation!, lonLocation!), zoom: 16.5);
    mapController.moveCamera(CameraUpdate.newCameraPosition(updateCamera));
    setState(() {});
    _geocodeFirstFromCorToAddress();
  }

  loadFieldsAddress() {
    addressController.text = widget.address!.address!;
    complementController.text = widget.address!.complement!;
    nameAddressController.text = widget.address!.name!;
    latLocation = double.parse(widget.address!.latitude!);
    lonLocation = double.parse(widget.address!.longitude!);
  }

  @override
  void initState() {
    getPermissionGps();
    providerSettings = Provider.of<ProviderSettings>(context,listen: false);
    googlePlaces = new GooglePlaces(this);
    if (widget.flagAddress == "update") {
      loadFieldsAddress();
    } else {
      latLocation = singleton.latitude;
      lonLocation = singleton.longitude;
      _geocodeFirstFromCorToAddress();
    }
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    cityController.text = providerSettings?.citySelected?.name??'';
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
      height: 42,
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
                  openSuggestAddress();
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
        Future callResponse = UserProvider.instance.updateAddress(
            context,
            addressController.text ,
            latLocation.toString(),
            lonLocation.toString(),
            complementController.text ,
            nameAddressController.text,
            widget.address!);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          ChangeStatusAddressResponse data =
              ChangeStatusAddressResponse.fromJson(decodeJSON);

          if (data.status!) {
            Navigator.pop(context);
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context);
            setState(() {});
            utils.showSnackBarError(context, data.message);
          }
        }, onError: (error) {
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
        titleBar(Strings.addAddres, "ic_blue_arrow.png",
                () => Navigator.pop(context)),
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
                      SizedBox(height: 18),
                      textFieldAddress(
                          Strings.complement,
                          "Assets/images/ic_complement.png",
                          complementController, () {
                        editAddress = false;
                      }),
                      SizedBox(height: 18),
                      textFieldAddress(
                          Strings.nameAddress,
                          "Assets/images/ic_name_address.png",
                          nameAddressController, () {
                        editAddress = false;
                      }),
                      SizedBox(height: 18),
                      InkWell(
                          onTap: ()=>openSelectCityByState(),
                          child: textFieldIconSelector("ic_country.png",false, Strings.city, cityController)),
                      SizedBox(height: 18),
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

  Widget itemAddAddress(String labelTitle, String image, String hintText, TextEditingController controller) {
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

  Widget _map(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      onCameraMove: (CameraPosition camerapos) {
        FocusScope.of(context).unfocus();
        this.editAddress = false;
        lat = camerapos.target.latitude;
        lon = camerapos.target.longitude;
        latLocation = camerapos.target.latitude;
        lonLocation = camerapos.target.longitude;
      },
      onCameraIdle: () {
        setState(() {
          if (enableGeoCode) {
            bandLoadingText = true;
          }
        });
        _geocodeFromCorToAddress();
        enableGeoCode = true;
      },
      initialCameraPosition:
          CameraPosition(target: LatLng(latLocation!, lonLocation!), zoom: 16.5),
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

  openSelectCityByState()async{
    if(providerSettings?.countrySelected!=null||prefs.countryIdUser!="0") {
      providerSettings!.ltsStatesCountries.clear();
      await providerSettings!.getStates("", 0, providerSettings?.countrySelected!=null?providerSettings!.countrySelected!.id:prefs.countryIdUser);
      Navigator.push(context, customPageTransition(SelectStatesPage()));
    }else{
      utils.showSnackBar(context, Strings.countryEmpty);
    }
  }


  bool _validateFields() {
    if (this.addressController.text == "") {
      utils.showSnackBar(context, Strings.emptyAddress);
      return false;
    }
    if (this.complementController.text == "") {
      utils.showSnackBar(context, Strings.emptyComplement);
      return false;
    }

    if (this.nameAddressController.text == "") {
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
        Future callResponse = UserProvider.instance.addAddress(
            this.addressController.text,
            this.latLocation.toString(),
            this.lonLocation.toString(),
            complementController.text ,
            nameAddressController.text,
            providerSettings?.citySelected?.id?.toString()??''
        );
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          AddressResponse data = AddressResponse.fromJson(decodeJSON);
          if (data.status!) {
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
  void _geocodeFromCorToAddress() async {
    if (enableGeoCode) {

      var addresses = await GeocodingPlatform.instance.placemarkFromCoordinates(latLocation!,lonLocation!);
      var result = addresses.first;
      locationAddress = result.street;
      city = result.locality;
      namePlace = result.thoroughfare;
      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          addressController.text = locationAddress!;
          bandLoadingText = false;
        });
      });
    }
  }

  void _geocodeFirstFromCorToAddress() async {
    var addresses = await GeocodingPlatform.instance.placemarkFromCoordinates(latLocation!,lonLocation!);
    var result = addresses.first;
    locationAddress = result.street;
    city = result.locality;
    namePlace = result.thoroughfare;
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        addressController.text = locationAddress!;
      });
    });
  }

  @override
  selectedLocation(double lat, double lng, String? address, String name) {
    setState(() {


      locationAddress = address;
      if (lat != 0.0 && lng != 0.0 && address != '') {
        int indexChar = address!.indexOf(",");
        var addressSubtitle = address.replaceRange(0, indexChar + 2, "");
        addressController.text = name + " " + cityPlace;
        namePlace = name;
        cityPlace = addressSubtitle;
        city = cityPlace;

        print(namePlace! + "city" + cityPlace);

        latLocation = lat;
        lonLocation = lng;


        enableGeoCode = false;
        FocusScope.of(context).unfocus();
        mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(latLocation!, lonLocation!),
          zoom: 16.5,
          tilt: 37.0,
        )));

      }
    });
  }
}
