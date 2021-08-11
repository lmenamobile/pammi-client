import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  RefreshController _refreshCities = RefreshController(initialRefresh: false);
  int pageOffset = 0;

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
          margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
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
          child: SmartRefresher(
            controller: _refreshCities,
            enablePullDown: true,
            enablePullUp: true,
            onLoading: _onLoadingToRefresh,
            footer: footerRefreshCustom(),
            header: headerRefresh(),
            onRefresh: _pullToRefresh,
            child: Column(
              children: [
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
                            boxSearchCountries(cityController, searchCities),
                            SizedBox(height: 21),
                            providerSettings.ltsCities.isEmpty
                                ? emptyData("ic_empty_location.png",
                                   Strings.sorry , Strings.emptyCities)
                                : listItemsCities()
                          ]),
                    ),
                  ),
                ),
              ],
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

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshCities.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerSettings.ltsCities.clear();
    cityController.clear();
    getCitiesSearch("");
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getCitiesSearch(cityController.text??'');
    _refreshCities.loadComplete();
  }

  searchCities(String value) {
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
        Future callUser = providerSettings.getCities(
            search.trim(), 0, providerSettings.stateCountrySelected);
        await callUser.then((msg) {}, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
