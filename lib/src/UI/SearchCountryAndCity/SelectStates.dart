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
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../../Providers/SupportProvider.dart';
import '../../Widgets/widgets.dart';

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
  late SupportProvider supportProvider;

  @override
  void initState() {
    supportProvider = Provider.of<SupportProvider>(context, listen: false);
    providerSettings = Provider.of<ProviderSettings>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      providerSettings.ltsStatesCountries.clear();
      providerSettings.ltsCities.clear();
      getStatesSearch("");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    supportProvider = Provider.of<SupportProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            header(context, Strings.selectState, CustomColors.red, ()=> Navigator.pop(context)),
            Expanded(
              child: SmartRefresher(
                controller: _refreshStates,
                enablePullDown: true,
                enablePullUp: true,
                onLoading: _onLoadingToRefresh,
                footer: footerRefreshCustom(),
                header: headerRefresh(),
                onRefresh: _pullToRefresh,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      SizedBox(height: 21),
                      boxSearchCountries(
                          searchStateController, searchState),
                      SizedBox(height: 21),
                      providerSettings.ltsStatesCountries.isEmpty
                          ? Expanded(
                            child: emptyData("ic_empty_location.png",
                            Strings.sorry, Strings.emptyStates),
                          )
                          : Expanded(child: listItemsStates())
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Visibility(visible: providerSettings.isLoading, child: LoadingProgress())
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
    pageOffset = 0;
    getStatesSearch(value);
  }

  actionSelectState(StatesCountry state) {
    providerSettings.stateCountrySelected = state;
    Navigator.pop(context);
  }

  getStatesSearch(String search) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerSettings.getStates(search.trim(), pageOffset, providerSettings.countrySelected!=null?providerSettings.countrySelected!.id:prefs.countryIdUser);
        await callUser.then((msg) {}, onError: (error) {
         // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

}
