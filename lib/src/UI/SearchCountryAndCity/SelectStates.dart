import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/StatesCountry.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/SearchCountryAndCity/Widgets.dart';
import 'package:wawamko/src/UI/SearchCountryAndCity/selectCity.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class SelectStatesPage extends StatefulWidget {
  @override
  _SelectStatesPageState createState() => _SelectStatesPageState();
}

class _SelectStatesPageState extends State<SelectStatesPage> {
  final searchStateController = TextEditingController();
  RefreshController _refreshStates = RefreshController(initialRefresh: false);
  late ProviderSettings providerSettings;
  int pageOffset = 0;
  final prefs = SharePreference();

  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context, listen: false);
    providerSettings.ltsCities.clear();
    super.initState();
  }

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
            controller: _refreshStates,
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
                              Strings.selectState,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: CustomColors.blackLetter,
                                  fontFamily: Strings.fontBold),
                            ),
                            SizedBox(height: 21),
                            boxSearchCountries(
                                searchStateController, searchState),
                            SizedBox(height: 21),
                            providerSettings.ltsStatesCountries.isEmpty
                                ? emptyData("ic_empty_location.png",
                                    Strings.sorry, Strings.emptyStates)
                                : listItemsStates()
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

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshStates.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerSettings.ltsStatesCountries.clear();
    searchStateController.clear();
    getStatesSearch("");
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getStatesSearch(searchStateController.text);
    _refreshStates.loadComplete();
  }

  Widget listItemsStates() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      itemCount: providerSettings.ltsStatesCountries.length,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return itemStateCountry(
            providerSettings.ltsStatesCountries[index], actionSelectState);
      },
    );
  }

  searchState(String value) {
    providerSettings.ltsStatesCountries.clear();
    getStatesSearch(value);
  }

  actionSelectState(StatesCountry state) {
    providerSettings.stateCountrySelected = state;
    //Navigator.pushReplacement(context, customPageTransition(SelectCityPage()));
    Navigator.push(context, customPageTransition(SelectCityPage())).then((value) => {
    Navigator.pop(context)
    });
  }

  getStatesSearch(String search) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerSettings.getStates(search.trim(), 0, providerSettings.countrySelected!=null?providerSettings.countrySelected!.id:prefs.countryIdUser);
        await callUser.then((msg) {}, onError: (error) {
         // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
