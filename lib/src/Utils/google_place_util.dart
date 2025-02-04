
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/utils.dart';

import 'flutter_google_autocomplete.dart';



class GooglePlaces {
  final homeScaffoldKey = new GlobalKey<ScaffoldState>();
  final searchScaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleMapsPlaces _places =
  new GoogleMapsPlaces(apiKey: Constants.googleApyKey);
  Location? location;
  GooglePlacesListener _mapScreenState;

  GooglePlaces(this._mapScreenState);

  Future findPlace(BuildContext context) async {
    Prediction? p = await showGooglePlacesAutocomplete(
      context: context,
      location: location,
      apiKey: "google_map_key",
      language: 'es',
      components: [new Component(Component.country, "co")],
      onError: (res) {
        utils.showSnackBar(context, res.errorMessage!);
        /*homeScaffoldKey.currentState!
            .showSnackBar(new SnackBar(content: new Text(res.errorMessage!)));*/
      },
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(Prediction? p, ScaffoldState? scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      print("__");
      _mapScreenState.selectedLocation(lat, lng, detail.result.formattedAddress, detail.result.name);
    
    }
  }

  void updateLocation(double lat, double long) {
    location = new Location(lat: lat, lng: long);
  }
}

abstract class GooglePlacesListener {
  selectedLocation(double lat, double long, String? address, String name);
}