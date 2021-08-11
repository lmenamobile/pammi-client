import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/CountryUser.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/UI/SearchCountryAndCity/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';

import '../WidgetsGeneric.dart';

class DialogSelectCountry extends StatefulWidget {
  @override
  _DialogSelectCountryState createState() => _DialogSelectCountryState();
}

class _DialogSelectCountryState extends State<DialogSelectCountry> {
  RefreshController _refreshCountries = RefreshController(initialRefresh: false);
  ProviderSettings providerSettings;
  final prefs = SharePreference();
  int pageOffset = 0;

  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context, listen: false);
    providerSettings.ltsCountries.clear();
    getCountries("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  Strings.selectYourCountry,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: Strings.fontMedium),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                  child: customDivider()),
              Container(
                height: MediaQuery.of(context).size.height*.4,
                child: SmartRefresher(
                  controller: _refreshCountries,
                  enablePullDown: true,
                  enablePullUp: true,
                  onLoading: _onLoadingToRefresh,
                  footer: footerRefreshCustom(),
                  header: headerRefresh(),
                  onRefresh: _pullToRefresh,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                providerSettings.ltsCountries.isEmpty
                                    ? emptyData("ic_empty_location.png",
                                    Strings.emptyCountries, "")
                                    : listItemsCountry()
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget listItemsCountry() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      itemCount: providerSettings.ltsCountries.length,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return itemCountrySelect(
            providerSettings.ltsCountries[index], actionSelectCountry);
      },
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshCountries.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerSettings.ltsCountries.clear();
    getCountries("");
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    _refreshCountries.loadComplete();
  }

  actionSelectCountry(CountryUser country) {
    providerSettings.countrySelected = country;
    prefs.countryIdUser = providerSettings.countrySelected.id;
    Navigator.pop(context,true);
  }

  getCountries(String search) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerSettings.getCountries(search, pageOffset);
        await callUser.then((msg) {}, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
