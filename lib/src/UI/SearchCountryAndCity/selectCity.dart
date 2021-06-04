import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/City.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';


import 'Widgets.dart';

class SelectCityPage extends StatefulWidget {
  @override
  _SelectCityPageState createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  final cityController = TextEditingController();
  ProviderSettings providerSettings;

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
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
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Strings.selectCity,
                      style: TextStyle(
                          fontSize: 24,
                          color: CustomColors.blackLetter,
                          fontFamily: Strings.fontBold),
                    ),
                    SizedBox(height: 21),
                    boxSearchCountries(cityController,searchCities),
                    SizedBox(height: 21),
                    providerSettings.ltsCities.isEmpty
                        ? emptyData(
                        "ic_empty_location.png", Strings.emptyCities, "")
                        : listItemsCities()
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget listItemsCities() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      itemCount: providerSettings.ltsCities.length,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return cityItem(providerSettings.ltsCities[index], actionSelectCity);
      },
    );
  }

  searchCities(String value){
    providerSettings.ltsCities.clear();
    getCitiesSearch(value);
  }

  actionSelectCity(City city) {
    providerSettings.citySelected = city;
    Navigator.pop(context);
  }

  getCitiesSearch(String search) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerSettings.getCities(search, 0,providerSettings.stateCountrySelected);
        await callUser.then((msg) {}, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
