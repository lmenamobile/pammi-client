import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Country.dart';
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
  bool selected = false;
  ProviderSettings providerSettings;
  OnboardingProvider providerOnboarding;
  double widgetHeight = 0;

  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context, listen: false);
    providerSettings.ltsCountries.clear();
    getCountries();
    super.initState();
  }

  List<String> items = ["uno", "Dos"];

  @override
  Widget build(BuildContext context) {
    providerOnboarding = Provider.of<OnboardingProvider>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      widgetHeight = constraints.maxHeight;
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                color: CustomColors.white,
                child: _body(context),
              ),
              Visibility(
                  visible: providerSettings.isLoading, child: LoadingProgress()),
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
                providerSettings.ltsCountries.isEmpty?emptyData("ic_empty_location.png", Strings.emptyCountries, ""):Container(
                  height: MediaQuery.of(context).size.height - 180,
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: widgetHeight,
                          child: ListWheelScrollView(
                            itemExtent: 30,
                            children: providerSettings.ltsCountries
                                .map((country) => Center(child: itemCountry(country, null)))
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



  getCountries() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerSettings.getCountries("", 0);
        await callUser.then((msg) {

        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
