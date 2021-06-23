
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/CountryUser.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import 'Widgets.dart';

class SelectCountryPage extends StatefulWidget {
  @override
  _SelectCountryPageState createState() => _SelectCountryPageState();
}

class _SelectCountryPageState extends State<SelectCountryPage> {
  final countryController = TextEditingController();
  RefreshController _refreshCountries = RefreshController(initialRefresh: false);
  ProviderSettings providerSettings;
  OnboardingProvider providerOnBoarding;
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
    providerOnBoarding = Provider.of<OnboardingProvider>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                color: CustomColors.white,
                child: _body(context),
              ),
              Visibility(
                  visible: providerSettings.isLoading,
                  child: LoadingProgress()),
            ],
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
        Expanded(
          child: SmartRefresher(
            controller: _refreshCountries,
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
                              Strings.selectCountry,
                              style: TextStyle(
                                  fontSize: 24,
                                  color: CustomColors.blackLetter,
                                  fontFamily: Strings.fontBold),
                            ),
                            SizedBox(height: 21),
                            boxSearch(context),
                            SizedBox(height: 21),
                            providerSettings.ltsCountries.isEmpty
                                ? emptyData("ic_empty_location.png",
                                    Strings.emptyCountries, "")
                                : listItemsCountry()
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
                onSubmitted: (value) {
                  providerSettings.ltsCountries.clear();
                  getCountries(value);
                },
                textInputAction: TextInputAction.search,
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
                        color: CustomColors.gray7)),
              ),
            )
          ],
        ),
      ),
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
    countryController.clear();
    getCountries("");
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getCountries(countryController.text??'');
    _refreshCountries.loadComplete();
  }

  Widget listItemsCountry() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      itemCount: providerSettings.ltsCountries.length,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return itemCountry(
            providerSettings.ltsCountries[index], actionSelectCountry);
      },
    );
  }

  actionSelectCountry(CountryUser country) {
    providerSettings.countrySelected = country;
    Navigator.pop(context);
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
