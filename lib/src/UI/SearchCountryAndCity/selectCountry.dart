import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Country.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';

import 'Widgets.dart';

class SelectCountryPage extends StatefulWidget {
  @override
  _SelectCountryPageState createState() => _SelectCountryPageState();
}

class _SelectCountryPageState extends State<SelectCountryPage> {
  final countryController = TextEditingController();
  bool selected = false;
  List<Country> countries = List();
  OnboardingProvider providerOnboarding;
  double widgetHeight = 0;

  @override
  void initState() {
    // _sertviceGetCountries("");

    super.initState();
  }

  List<String> items = ["uno", "Dos"];

  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      widgetHeight = constraints.maxHeight;
      return Scaffold(
        body: SafeArea(
          child: Container(
            color: CustomColors.white,
            child: _body(context),
          ),
        ),
      );
    });
  }

  Widget _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: GestureDetector(
            child: Image(
              width: 40,
              height: 40,
              image: AssetImage("Assets/images/ic_back.png"),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 35),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Strings.selectCountry,
                  style: TextStyle(
                      fontSize: 24,
                      color: CustomColors.blackLetter,
                      fontFamily: Strings.fontBold),
                ),
                SizedBox(height: 21),
                boxSearch(context),
                SizedBox(height: 21),
                Container(
                  height: MediaQuery.of(context).size.height - 180,
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: widgetHeight,
                          child: ListWheelScrollView(
                            itemExtent: 30,
                            children: items
                                .map((item) => Center(child: Text(item)))
                                .toList(),
                            magnification: 1.5,
                            useMagnifier: true,
                            physics: FixedExtentScrollPhysics(),
                            perspective: 0.0000000001,
                            onSelectedItemChanged: (index) => {},
                          )),
                      boxSelect(),
                    ],
                  ),
                ),
              ]),
        ),
      ],
    );
  }

  Widget boxSearch(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: CustomColors.grayBackground),
      child: Center(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Image(
                width: 20,
                height: 20,
                image: AssetImage("Assets/images/ic_seeker.png"),
              ),
            ),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  _sertviceGetCountries2(value);
                },
                controller: countryController,
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: CustomColors.blackLetter),
                decoration: InputDecoration(
                    hintText: Strings.search,
                    isDense: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 15,
                        color: CustomColors.grayLetter)),
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
        Future callUser =
            providerOnboarding.getCountries(context, search ?? "", 0);
        await callUser.then((countryResponse) {
          var decodeJSON = jsonDecode(countryResponse);
          CountriesResponse data = CountriesResponse.fromJsonMap(decodeJSON);

          if (data.code.toString() == "100") {
            this.countries = [];
            for (var country in data.data.countries) {
              this.countries.add(country);
            }

            setState(() {});

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
        Future callUser =
            providerOnboarding.getCountries(context, search ?? "", 0);
        await callUser.then((countryResponse) {
          var decodeJSON = jsonDecode(countryResponse);
          CountriesResponse data = CountriesResponse.fromJsonMap(decodeJSON);

          if (data.code.toString() == "100") {
            this.countries = [];
            for (var country in data.data.countries) {
              this.countries.add(country);
            }

            setState(() {});

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
