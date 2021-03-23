import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wawamko/src/Models/Country.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/RegisterStepTwo.dart';
import 'package:wawamko/src/UI/selectCity.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class SelectCountryPage extends StatefulWidget {
  @override
  _SelectCountryPageState createState() => _SelectCountryPageState();
}

class _SelectCountryPageState extends State<SelectCountryPage> {
  final countryController = TextEditingController();
  bool selected = false;
  List<Country> countries = List();


  @override
  void initState() {
    _sertviceGetCountries("");
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
      return SingleChildScrollView(
        child: Stack(
          children: <Widget>[
        GestureDetector(
          child: Container(
            alignment: Alignment.topRight,
              child: Image(
                width: 80,
                height: 80,
                image: AssetImage("Assets/images/ic_arrow_menu.png"),
          ),
        ),
          onTap: (){
              Navigator.pop(context);
          },
    ),
    Container(
            margin: EdgeInsets.only(left: 29,top: 50),
              child: Image(
              width: 60,
              height: 60,
              image: AssetImage("Assets/images/ic_logo_l.png"),
    ),
    ),
            Padding(
              padding: EdgeInsets.only(top: 130,left: 39,right: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Strings.selectCountry,
                    style: TextStyle(
                      fontSize: 24,
                      color: CustomColors.blackLetter,
                      fontFamily: Strings.fontArialBold
                    ),
                  ),
                  SizedBox(height: 21),
                  boxSearch(context),
                  SizedBox(height: 21),
                  Container(

                    // margin: EdgeInsets.only(left: 23,right: 15),
                    child: ListView.builder(

                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 0),
                      itemCount: this.countries.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {

                        return  AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 800),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                  child: itemCountry(context, index,this.countries[index])//itemBookings(context, data, _openBookingDetail),
                              ),
                            )
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),


                ],
              ),
            )
    ]
    ),
      );
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
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Image(
                width: 20,
                height: 20,
                image: AssetImage("Assets/images/ic_seeker.png"),
              ),
            ),
            Expanded(
              child: TextField(
                onChanged: (value){
                  _sertviceGetCountries2(value);
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





  _sertviceGetCountries(String search) async {




    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser = OnboardingProvider.instance.getCountries(context, search ?? "", 0);
        await callUser.then((countryResponse) {

          var decodeJSON = jsonDecode(countryResponse);
          CountriesResponse data = CountriesResponse.fromJsonMap(decodeJSON);


          if(data.code.toString() == "100") {

          this.countries = [];
           for (var country in data.data.countries){
             this.countries.add(country);
           }

           setState(() {

           });

            Navigator.pop(context);
          } else {

            Navigator.pop(context);
            utils.showSnackBar(context, data.message);

          }
        }, onError: (error) {

          Navigator.pop(context);
          utils.showSnackBar(context, Strings.serviceError);


        });
      } else {
        Navigator.pop(context);
        utils.showSnackBar(context, Strings.internetError);


      }
    });
  }


  _sertviceGetCountries2(String search) async {




    utils.checkInternet().then((value) async {
      if (value) {
        //utils.startProgress(context);
        Future callUser = OnboardingProvider.instance.getCountries(context, search ?? "", 0);
        await callUser.then((countryResponse) {

          var decodeJSON = jsonDecode(countryResponse);
          CountriesResponse data = CountriesResponse.fromJsonMap(decodeJSON);


          if(data.code.toString() == "100") {

            this.countries = [];
            for (var country in data.data.countries){
              this.countries.add(country);
            }

            setState(() {

            });

            //Navigator.pop(context);
          } else {

            //Navigator.pop(context);
            utils.showSnackBar(context, data.message);

          }
        }, onError: (error) {

          //Navigator.pop(context);
          utils.showSnackBar(context, Strings.serviceError);


        });
      } else {
        //Navigator.pop(context);
        utils.showSnackBar(context, Strings.internetError);


      }
    });
  }


}
