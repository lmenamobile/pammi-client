library flutter_google_places_autocomplete.src;

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'Constants.dart';

class GooglePlacesAutocompleteWidget extends StatefulWidget {


  final String apiKey;
  final String hint;
  final Location? location;
  final num? offset;
  final num? radius;
  final String? language;
  final List<String>? types;
  final List<Component>? components;
  final bool? strictbounds;
  final ValueChanged<PlacesAutocompleteResponse>? onError;
  final lenghtList = 0;

  GooglePlacesAutocompleteWidget(
      {required this.apiKey,
        this.hint = "Buscar.",
        this.offset,
        this.location,
        this.radius,
        this.language,
        this.types,
        this.components,
        this.strictbounds,
        this.onError,
        Key? key})
      : super(key: key);

  @override
  State<GooglePlacesAutocompleteWidget> createState() {
    return new _GooglePlacesAutocompleteOverlayState();
  }

  static GooglePlacesAutocompleteState? of(BuildContext context) => context.findAncestorStateOfType<GooglePlacesAutocompleteState>();
}

class _GooglePlacesAutocompleteOverlayState
    extends GooglePlacesAutocompleteState {

  final singleton = GlobalVariables();
  var _focusAddress = FocusNode();

  Widget headerAddress(BuildContext context,String title){
    return Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Assets/images/ic_header_reds.png"),
            fit: BoxFit.fitWidth
          )
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 9,
                color: CustomColors.blueSplash,
              ),
            ),
            Positioned(
              top: 16,
              left: 15,
              child: GestureDetector(
                child: Container(
                  width: 40,
                  height: 40,
                  child: Image(
                    image: AssetImage("Assets/images/ic_back_w.png"),
                  ),
                ),
                onTap: (){
                  FocusScope.of(context).unfocus();
                  //singleton.eventRefreshHome.broadcast();
                  Navigator.pop(context);
                  //singleton.eventRefreshCheckout.broadcast();
                },
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 25),
              child: Text(
                title,
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 17,
                    color: CustomColors.white

                ),
              ),
            )
          ],
        )

    );

  }

  bool hasFocus(){
    bool hasFocus = false;
    _focusAddress.addListener(() {
      if(!_focusAddress.hasFocus){
        hasFocus = false;
        print("Lose focus");
      }
      else {
        print("has focus");
        hasFocus = true;
      }
    });
    return hasFocus;
  }


  @override
  void initState() {
    hasFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    singleton.contextAutocomplete = context;

    _focusAddress.addListener(() {
      if(!_focusAddress.hasFocus){

      }
    });

    final header2 = Scaffold(
        backgroundColor: CustomColors.white,
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: CustomColors.white,
          child:  new Column(children: <Widget>[
            titleBar(Strings.selectYouAddress, "ic_blue_arrow.png",
                    () => Navigator.pop(context)),
            new Material(
              color: CustomColors.whiteBackGround,
              child: Container(
                  height: 41,

                  margin: EdgeInsets.only(left: 30,right: 30,top: 20),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: CustomColors.grayBackground.withOpacity(.7),
                    border: Border.all(color:CustomColors.greyBorder,width: 1),

                  ),
                  padding: EdgeInsets.only(left: 10,right: 5),
                  child: new Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Image(

                        image: AssetImage("Assets/images/ic_location_blue.png"),
                        width: 22,
                        height: 22,
                      ),
                      /* GestureDetector(
                      child: Container(

                        child: new Image(
                          width: 40,
                          height: 45,
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/ic_search.png"),
                        ),
                      ),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),*/
                      new Expanded(
                          child: new Padding(
                            child: _textField(),
                            padding: const EdgeInsets.only(bottom: 2,left: 10,right: 10),
                          )
                      ),

                      new Align(
                        alignment: Alignment.center,
                        child: new Visibility(
                          visible: singleton.bandLoadingAutocomplete ? true:false,
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            height: 30,
                            width: 30,
                            child:  SpinKitThreeBounce(
                              color: CustomColors.red,
                              size: 20.0,
                            ),
                          ),
                        ),
                      )


                    ],
                  )
              ),
            ),

          ]),
        ));


    var body;

    if (query!.text.isEmpty ||
        response == null ||
        response!.predictions.isEmpty || query!.text.length <= 3 || singleton.bandLoadingAutocomplete  ) {
      body = new Material(

        color: Colors.transparent,
        borderRadius: new BorderRadius.only(
            topLeft: new Radius.circular(5.0),
            topRight: new Radius.circular(5.0),
            bottomLeft: new Radius.circular(5.0),
            bottomRight: new Radius.circular(5.0)),
      );
    } else {

      body = !singleton.bandLoadingAutocomplete?Container(
        margin: EdgeInsets.only(top: 110),
        color: CustomColors.green,
        child: new SingleChildScrollView(
            child:  Container(
              //margin: EdgeInsets.only(top: 110),
              child: new Material(

                borderRadius: new BorderRadius.only(
                    bottomLeft: new Radius.circular(5.0),
                    bottomRight: new Radius.circular(5.0)),

                color: Colors.white,
                child: Container(
                    margin:EdgeInsets.only(top: 0),

                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.all(Radius.circular(15)),
                        color:Colors.white
                    ),
                    child:response!.predictions.length<=0?Container():ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: response!.predictions.length,
                      itemBuilder: (BuildContext context, int index){
                        var data = response!.predictions[index];
                        return index<0?Container():PredictionTile(
                          prediction: data,
                          onTap: Navigator.of(context).pop,
                        );
                      },
                    )

                  /*ListView(
                      shrinkWrap: true,
                        children: response.predictions
                            .map((p) => new PredictionTile(
                            prediction: p, onTap: Navigator.of(context).pop))
                            .toList())*/

                ),
              ),
            )),
      ):Container();
    }

    final container = new Container(
      //margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
        child: new Stack(children: <Widget>[
          header2,
          new Padding(padding: new EdgeInsets.only(top: 48.0), child: body),
        ]));

    if (Platform.isIOS) {
      return new Padding(
          padding: new EdgeInsets.only(top: 8.0), child: container);
    }
    return container;
  }




  Widget _textField() => new TextField(
    focusNode: _focusAddress,
    style: TextStyle(
        fontFamily: Strings.fontRegular,
        fontSize: 16,
        color: CustomColors.darkLetter
    ),
    controller: query,
    // onTap: (){FocusScope.of(context).requestFocus(focusNode);},
    autofocus: true,
    decoration: new InputDecoration(

      hintText: Strings.inputAddress,
      hintStyle: new TextStyle(
        fontFamily: Strings.fontRegular,
        fontSize: 16,
        color: CustomColors.darkLetter.withOpacity(.3),
      ),

      //fillColor: CustomColors.darkBlue,
      //filled: true,
      border: InputBorder.none,),
    onChanged: search,
  );
}

class GooglePlacesAutocompleteResult extends StatefulWidget {
  final ValueChanged<Prediction>? onTap;

  GooglePlacesAutocompleteResult({this.onTap});

  @override
  _GooglePlacesAutocompleteResult createState() =>
      new _GooglePlacesAutocompleteResult();
}

class _GooglePlacesAutocompleteResult
    extends State<GooglePlacesAutocompleteResult> {
  @override
  Widget build(BuildContext context) {
    final state = GooglePlacesAutocompleteWidget.of(context)!;
    assert(state != null);

    if (state.query!.text.isEmpty ||
        state.response == null ||
        state.response!.predictions.isEmpty) {
      final children = <Widget>[];

      return new Stack(children: children);
    }

    return new PredictionsListView(
        predictions: state.response!.predictions, onTap: widget.onTap);


  }
}

class PredictionsListView extends StatelessWidget {
  final List<Prediction> predictions;
  final ValueChanged<Prediction>? onTap;
  var lenghtList = 5;

  PredictionsListView({required this.predictions, this.onTap});

  @override
  Widget build(BuildContext context) {
    lenghtList = predictions.length;
    return predictions.length!=0?new ListView(
      children: predictions.map((Prediction p) =>
      new PredictionTile(
          prediction: p,
          onTap: onTap
      )
      ).toList(),
    ):new Container();
  }
}

class PredictionTile extends StatelessWidget {
  final Prediction prediction;
  final ValueChanged<Prediction>? onTap;

  late String addressTitle;
  late String addressSubtitle;

  PredictionTile({required this.prediction, this.onTap});


  @override
  Widget build(BuildContext context) {
    int indexChar = prediction.description!.indexOf(",");
    addressTitle = prediction.description!.replaceRange(indexChar, prediction.description!.length, "");
    addressSubtitle = prediction.description!.replaceRange(0, indexChar + 2, "");
    return prediction.description!.length!=0?Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Image(
                image: AssetImage("Assets/images/ic_location_blue.png"),
                width: 20,
                height: 20,
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  ListTile(

                    title: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: new Text(
                        addressTitle,
                        style: TextStyle(
                          color: CustomColors.blackLetter,
                          fontFamily: Strings.fontRegular,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: new Text(
                        addressSubtitle,
                        style: TextStyle(
                          color: CustomColors.gray,
                          fontFamily: Strings.fontRegular,
                          fontSize: 14.0,
                        ),
                      ),
                    ),

                    onTap: () {
                      if (onTap != null) {
                        print("prediction");
                        onTap!(prediction);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(height: 1,color: CustomColors.gray.withOpacity(.3),margin: EdgeInsets.only(left: 20,right: 20),)

      ],
    ):Container();
  }
}

Future<Prediction?> showGooglePlacesAutocomplete(
    {required BuildContext context,
      required String apiKey,
      String hint = "Buscar",
      num? offset,
      Location? location,
      num? radius,
      String? language,
      List<String>? types,
      List<Component>? components,
      bool? strictbounds,
      ValueChanged<PlacesAutocompleteResponse>? onError}) {
  final builder = (BuildContext ctx) => new GooglePlacesAutocompleteWidget(
    apiKey: apiKey,
    language: language,
    components: components,
    types: types,
    location: location,
    radius: radius,
    strictbounds: strictbounds,
    offset: offset,
    hint: hint,
    onError: onError,
  );

  return showDialog(context: context, builder: builder);
}

abstract class GooglePlacesAutocompleteState
    extends State<GooglePlacesAutocompleteWidget> {
  TextEditingController? query;
  PlacesAutocompleteResponse? response;
  late GoogleMapsPlaces _places;
  bool? searching;

  final singleton = GlobalVariables();

  @override
  void initState() {
    super.initState();

    query = new TextEditingController(text: "");
    _places = new GoogleMapsPlaces(apiKey: Constants.googleApyKey);
    searching = false;

  }



  Future<Null> doSearch(String value) async {
    utils.checkInternet2( _validateInternet, singleton.contextAutocomplete);
    setState(() {
      singleton.bandLoadingAutocomplete = true;
    });

    if (mounted && value.isNotEmpty) {
      setState(() {
        searching = true;
      });

      final res = await _places.autocomplete(value,
          offset: widget.offset,
          location: widget.location,
          radius: widget.radius,
          language: widget.language,
          components: widget.components!,
          );

      if (res.errorMessage?.isNotEmpty == true ||
          res.status == "REQUEST_DENIED") {
        setState(() {
          singleton.bandLoadingAutocomplete = false;
        });
        onResponseError(res);
      } else {
        setState(() {
          singleton.bandLoadingAutocomplete = false;
        });
        onResponse(res);
      }
    } else {
      setState(() {
        singleton.bandLoadingAutocomplete = false;
      });
      onResponse(null);
    }
  }

  Timer? _timer;

  Future<Null> search(String value) async {
    _timer?.cancel();
    _timer = new Timer(const Duration(milliseconds: 300), () {
      _timer!.cancel();
      doSearch(value);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _places.dispose();
    super.dispose();
  }

  @mustCallSuper
  void onResponseError(PlacesAutocompleteResponse res) {
    if (mounted) {
      if (widget.onError != null) {
        widget.onError!(res);
      }
      setState(() {
        response = null;
        searching = false;
      });
    }
  }

  void _validateInternet(bool isNetworkPresent, BuildContext context) {
    if (isNetworkPresent) {
      //_serviceSaveVehicle(context);
    } else {
      print('No internet');
      //utils.messageSnackBar(context, Strings.no_internet);
    }
  }

  @mustCallSuper
  void onResponse(PlacesAutocompleteResponse? res) {
    if (mounted) {
      setState(() {
        response = res;
        searching = false;
      });
    }
  }
}
