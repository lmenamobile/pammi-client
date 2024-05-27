

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/City.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../../Widgets/widgets.dart';
import 'Widgets.dart';

class SelectCityPage extends StatefulWidget {
  @override
  _SelectCityPageState createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  final cityController = TextEditingController();
  late ProviderSettings providerSettings;
  RefreshController _refreshCities = RefreshController(initialRefresh: false);
  int pageOffset = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      providerSettings.ltsCities.clear();
      getCitiesSearch("");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:_body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            headerView( Strings.selectCity,  ()=> Navigator.pop(context)),
            SizedBox(height: 21),
            boxSearchCountries(cityController, searchCities),
            SizedBox(height: 21),
            Expanded(
              child: SmartRefresher(
                controller: _refreshCities,
                enablePullDown: true,
                enablePullUp: true,
                onLoading: _onLoadingToRefresh,
                footer: footerRefreshCustom(),
                header: headerRefresh(),
                onRefresh: _pullToRefresh,
                child: providerSettings.ltsCities.isEmpty
                    ? emptyData("ic_empty_location.png",
                    Strings.sorry , Strings.emptyCities)
                    : listItemsCities(),
              ),
            ),
          ],
        ),
        Visibility(visible: providerSettings.isLoading, child: LoadingProgress())
      ],
    );
  }

  Widget listItemsCities() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10,left: 10,right: 10),
      itemCount: providerSettings.ltsCities.length,
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
    getCitiesSearch(cityController.text);
    _refreshCities.loadComplete();
  }

  searchCities(String value) {
    providerSettings.ltsCities.clear();
    pageOffset = 0;
    getCitiesSearch(value);
  }

  actionSelectCity(City city) {
    providerSettings.citySelected = city;
    Navigator.pop(context);
  }

  getCitiesSearch(String search) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerSettings.getCities(search.trim(), pageOffset, providerSettings.stateCountrySelected!);
        await callUser.then((msg) {}, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
