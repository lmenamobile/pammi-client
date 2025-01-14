
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/CountryUser.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../../Providers/SupportProvider.dart';
import '../../Utils/share_preference.dart';
import 'Widgets.dart';

class SelectCountryPage extends StatefulWidget {
  @override
  _SelectCountryPageState createState() => _SelectCountryPageState();
}

class _SelectCountryPageState extends State<SelectCountryPage> {
  final countryController = TextEditingController();
  RefreshController _refreshCountries = RefreshController(initialRefresh: false);
  late ProviderSettings providerSettings;
  OnboardingProvider? providerOnBoarding;
  int pageOffset = 0;
  late SupportProvider supportProvider;
  final prefs = SharePreference();

  @override
  void initState() {
    supportProvider = Provider.of<SupportProvider>(context, listen: false);
    //providerSettings = Provider.of<ProviderSettings>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      providerSettings.ltsCountries.clear();
      getCountries("");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerOnBoarding = Provider.of<OnboardingProvider>(context);
    supportProvider = Provider.of<SupportProvider>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
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
          children: <Widget>[
            headerView(Strings.selectCountry,  ()=> Navigator.pop(context)),
            SizedBox(height: 21),
            boxSearch(context),
            SizedBox(height: 21),
            Expanded(
              child: SmartRefresher(
                controller: _refreshCountries,
                enablePullDown: true,
                enablePullUp: true,
                onLoading: _onLoadingToRefresh,
                footer: footerRefreshCustom(),
                header: headerRefresh(),
                onRefresh: _pullToRefresh,
                child:   providerSettings.ltsCountries.isEmpty
                    ? emptyData("ic_empty_location.png",
    Strings.sorry, Strings.emptyCountries)
                    : listItemsCountry()
                /*

                 */
              ),
            ),

          ],
        ),
        Visibility(
            visible: providerSettings.isLoading,
            child: LoadingProgress()),
      ],
    );
  }

  Widget boxSearch(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30 ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 26,vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(26)),
          border: Border.all(color: AppColors.gray4.withOpacity(.3),width: 1),
          color: Colors.transparent),
      child: Center(
        child: Row(
          children: <Widget>[
            Image(
              width: 20,
              height: 20,
              color: AppColors.blue,
              image: AssetImage("Assets/images/ic_seeker.png"),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: TextField(
                onSubmitted: (value) {
                  providerSettings.ltsCountries.clear();
                  pageOffset = 0;
                  getCountries(value);
                },
                textInputAction: TextInputAction.search,
                controller: countryController,
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: AppColors.blackLetter),
                decoration: InputDecoration(
                    hintText: "${Strings.search}..",
                    isDense: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 15,
                        color: AppColors.gray4)),
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
    getCountries(countryController.text);
    _refreshCountries.loadComplete();
  }

  Widget listItemsCountry() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10,left: 10,right: 10),
      itemCount: providerSettings.ltsCountries.length,
      itemBuilder: (BuildContext context, int index) {
        return itemCountry(
            providerSettings.ltsCountries[index], actionSelectCountry);
      },
    );
  }

  actionSelectCountry(CountryUser country) async {
    providerSettings.countrySelected = country;
    prefs.countryIdUser =  country.id.toString();
    serviceGetTerms();
    Navigator.pop(context);
    }

  getCountries(String search) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerSettings.getCountries(search.trim(), pageOffset);
        await callUser.then((msg) {}, onError: (error) {
   /*       CountryUser? countryUser = providerSettings.ltsCountries.firstWhere((country) => country.id == "CO", orElse: () => CountryUser(),);
            if(countryUser.id !=null){
              providerSettings.countrySelected = countryUser;
              prefs.countryIdUser =  countryUser.id.toString();
            }*/
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  serviceGetTerms() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSupport = supportProvider.getTermsAndConditions();
        await callSupport.then((list) {
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
