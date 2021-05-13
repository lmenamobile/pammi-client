import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wawamko/src/Models/Country.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class SelectCityPage extends StatefulWidget {

  final States state;
  SelectCityPage({Key key,this.state}) : super(key: key);

  @override
  _SelectCityPageState createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  final countryController = TextEditingController();
  bool selected = false;
  List<City>cities = List();
  bool loading = true;

  @override
  void initState() {
    _serviceGetCities("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: CustomColors.white,
          child: _body(context),
        ),
      ),
    );
  }
  Widget _body(BuildContext context){
    return Stack(
      children: <Widget>[
        Positioned(
          top: 20,
          left: 20,
          child: GestureDetector(
            child: Image(
              width: 40,
              height: 40,
              image: AssetImage("Assets/images/ic_back.png"),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
        ),
        Positioned(
          top: 70,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            child: Stack(
                children: <Widget>[


                  Padding(
                    padding: EdgeInsets.only(top: 8,left: 39,right: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Strings.selectCity,
                          style: TextStyle(
                              fontSize: 24,
                              color: CustomColors.blackLetter,
                              fontFamily: Strings.fontArialBold
                          ),
                        ),
                        SizedBox(height: 21),
                        boxSearch(context),
                        SizedBox(height: 21),
                        !this.loading ? this.cities.isEmpty ? Container(  child: Center(child: notifyUser("Assets/images/ic_from_empty.png", Strings.titleAmSorry, Strings.cobertCity),)) : Container(
                          // margin: EdgeInsets.only(left: 23,right: 15),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(top: 0),
                            itemCount: cities?.length ?? 0,//productsInShopCar.length ?? 0,//this.productsZones?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {

                              return  AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 800),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                        child: itemCity(context, index,this.cities[index])//itemBookings(context, data, _openBookingDetail),
                                    ),
                                  )
                              );
                            },
                          ),
                        ):Container(),
                        SizedBox(height: 37),
                        //  Padding(padding: EdgeInsets.only(left: 50,right: 50), child: btnCustomRounded(CustomColors.blueActiveDots,CustomColors.white,"Continuar",(){Navigator.pop(context);},context)),
                        //SizedBox(height: 73),
                      ],
                    ),
                  )
                ]
            ),
          ),
        ),

      ],
    );
  }

  _serviceGetCities(String search) async {

    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser = OnboardingProvider.instance.getCities(context, search, 0, widget.state);
        await callUser.then((cityResponse) {

          var decodeJSON = jsonDecode(cityResponse);
          CitiesResponse data = CitiesResponse.fromJsonMap(decodeJSON);


          if(data.code.toString() == "100") {

            this.cities = [];

            if (data.data != null){
              for (var city in data.data.cities){
                this.cities.add(city);
              }
            }



            Navigator.pop(context);
            this.loading = false;
            setState(() {

            });


          } else {
            Navigator.pop(context);
            this.loading = false;


            utils.showSnackBar(context, data.message);
            setState(() {

            });

          }
        }, onError: (error) {
          Navigator.pop(context);
          this.loading = false;

          utils.showSnackBar(context, Strings.serviceError);
          setState(() {

          });


        });
      } else {
        Navigator.pop(context);
        this.loading = false;
        utils.showSnackBar(context, Strings.internetError);
        setState(() {

        });


      }
    });
  }


  _serviceGetCities2(String search) async {

    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = OnboardingProvider.instance.getCities(context, search, 0, widget.state);
        await callUser.then((cityResponse) {

          var decodeJSON = jsonDecode(cityResponse);
          CitiesResponse data = CitiesResponse.fromJsonMap(decodeJSON);


          if(data.code.toString() == "100") {

            this.cities = [];

            if (data.data != null){
              for (var city in data.data.cities){
                this.cities.add(city);
              }
            }


            setState(() {

            });


          } else {


            //utils.showSnackBar(context, data.message);

          }
        }, onError: (error) {


          utils.showSnackBar(context, Strings.serviceError);


        });
      } else {

        utils.showSnackBar(context, Strings.internetError);


      }
    });
  }

  Widget boxSearch(BuildContext context){
    return Container(
      height: 47,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: CustomColors.grayBackground
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            Image(
              width: 40,
              height: 40,
              image: AssetImage(""),
            ),
            Expanded(
              child: TextField(
                onChanged: (value){
                  _serviceGetCities2(value);
                },
                controller: countryController,
                style: TextStyle(
                    fontFamily: Strings.fontArial,
                    fontSize: 15,
                    color: CustomColors.blackLetter
                ),
                decoration: InputDecoration(
                    hintText: "Buscar",
                    isDense: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontFamily: Strings.fontArial,
                        fontSize: 15,
                        color: CustomColors.grayLetter
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );

  }
}
