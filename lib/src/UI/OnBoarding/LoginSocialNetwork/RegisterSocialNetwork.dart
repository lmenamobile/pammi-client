import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/SearchCountryAndCity/SelectStates.dart';
import 'package:wawamko/src/UI/SearchCountryAndCity/selectCountry.dart';
import 'package:wawamko/src/Utils/Strings.dart';

import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import '../../../Providers/SupportProvider.dart';
import '../../../config/theme/colors.dart';
import '../../InterestCategoriesUser.dart';
import '../../SearchCountryAndCity/selectCity.dart';
import '../Widgets.dart';


class RegisterSocialNetworkPage extends StatefulWidget {
  final String? name, email, typeRegister;

  const RegisterSocialNetworkPage({required this.name, required this.email, required this.typeRegister});
  @override
  _RegisterSocialNetworkPageState createState() => _RegisterSocialNetworkPageState();
}

class _RegisterSocialNetworkPageState extends State<RegisterSocialNetworkPage> {
  final referredController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  ProviderSettings? providerSettings;
  late SupportProvider supportProvider;
  late OnboardingProvider providerOnBoarding;
  final departmentController = TextEditingController();
  String msgError = '';


  @override
  void initState() {
    supportProvider = SupportProvider();
    providerSettings = ProviderSettings();
    providerOnBoarding = OnboardingProvider();
    if(mounted){
      providerOnBoarding.stateTerms = false;
      providerOnBoarding.stateDates = false;
      providerOnBoarding.stateCentrals = false;
      providerSettings?.countrySelected = null;
      providerSettings?.stateCountrySelected = null;
      providerSettings?.citySelected = null;
      serviceGetTerms();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    providerOnBoarding = Provider.of<OnboardingProvider>(context);
    supportProvider = Provider.of<SupportProvider>(context);


    return Scaffold(
      backgroundColor: AppColors.blueSplash,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: AppColors.white,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 100,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  child: Image(fit: BoxFit.fill, height: 100, image: AssetImage("Assets/images/ic_header_signup.png"),),
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: GestureDetector(
                  child: Image(image: AssetImage("Assets/images/ic_back_w.png"), width: 40, height: 40,),
                  onTap: ()=> Navigator.pop(context),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  Strings.registration,
                  style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 18, color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15,),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 6,),
                        Text(
                          Strings.registrationFinish,
                          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: Strings.fontBold, fontSize: 24, color: AppColors.blackLetter),
                        ),
                        SizedBox(height: 6,),
                        Text(
                          Strings.registerMsg,
                          style: TextStyle(fontFamily: Strings.fontRegular, color: AppColors.gray7),
                        ),
                        SizedBox(height: 13),
                        Column(
                             children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 600),
                            childAnimationBuilder: (widget) => SlideAnimation(verticalOffset: 50, child: FadeInAnimation(child: widget,),),
                            children: <Widget>[
                              InkWell(onTap: ()=>openSelectCountry(), child: textFieldIconSelector("ic_country.png",false, Strings.country, countryController)),
                              InkWell(
                                  onTap: ()=>openSelectDepartment(),
                                  child: textFieldIconSelector("ic_country.png",false, Strings.department, departmentController)),
                              InkWell(onTap: ()=>openSelectCity(), child: textFieldIconSelector("ic_country.png",false, Strings.city, cityController)),

                              textFieldIconPhone(Strings.phoneNumber,providerSettings?.countrySelected?.callingCode??'',"ic_mobile.png",phoneController ),
                              customTextFieldIcon("ic_data.png",true, Strings.codeReferred, referredController, TextInputType.text, [ LengthLimitingTextInputFormatter(30)]),
                              itemCheck(
                                      () => providerOnBoarding.stateDates = !providerOnBoarding.stateDates,
                                  providerOnBoarding.stateDates,
                                  Text(Strings.AuthorizeDates, style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 12, color: AppColors.blackLetter),)
                              ),
                              SizedBox(height: 10),
                              itemCheck(
                                      () => providerOnBoarding.stateCentrals = !providerOnBoarding.stateCentrals,
                                  providerOnBoarding.stateCentrals,
                                  Text(
                                    Strings.authorizedCredit,
                                    style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 12, color: AppColors.blackLetter),
                                  )),
                              SizedBox(height: 10),
                              itemCheck(
                                      () => providerOnBoarding.stateContactCommercial = !providerOnBoarding.stateContactCommercial,
                                  providerOnBoarding.stateContactCommercial,
                                  Text(
                                Strings.contactCommercial,
                                style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 12, color: AppColors.blackLetter),
                              )),
                              SizedBox(height: 10),
                              itemCheck(
                                      () => providerOnBoarding.stateTerms = !providerOnBoarding.stateTerms,
                                  providerOnBoarding.stateTerms,
                                  termsAndConditions(supportProvider.lstTermsAndConditions.isNotEmpty ? supportProvider.lstTermsAndConditions[0].url.toString()  : "")
                              ),
                            ],
                          )),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                            child: btnCustomIcon("ic_next.png", Strings.next, AppColors.blueSplash, Colors.white, callStepTwoRegister))
                      ],
                    ),
                  SizedBox(height: 15,),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  void openSelectDepartment()async{
    if(providerSettings?.countrySelected!=null) {
      await Navigator.push(context, customPageTransition(SelectStatesPage(),PageTransitionType.rightToLeftWithFade));
      departmentController.text = providerSettings?.stateCountrySelected?.name??'';
    }else{
      utils.showSnackBar(context, Strings.countryEmpty);
    }
  }

  openSelectCountry()async{
     await Navigator.push(context, customPageTransition(SelectCountryPage(),PageTransitionType.rightToLeftWithFade  ));
     countryController.text = providerSettings?.countrySelected?.country??'';
  }

  void openSelectCity()async{
    if(providerSettings?.stateCountrySelected!=null) {
      await Navigator.push(context, customPageTransition(SelectCityPage(),PageTransitionType.rightToLeftWithFade));
      cityController.text = providerSettings?.citySelected?.name??'';
    }else{
      utils.showSnackBar(context, Strings.departmentEmpty);
    }
  }


  bool _validateEmptyFields() {
  if (countryController.text.isEmpty) {
      msgError = Strings.countryEmpty;
      return false;
    }else if (cityController.text.isEmpty) {
      msgError = Strings.cityEmpty;
      return false;
    }else if (phoneController.text.isEmpty) {
      msgError = Strings.phoneEmpty;
      return false;
    }else if (phoneController.text.length <= 7) {
      msgError = Strings.phoneInvalidate;
      return false;
    }
    return true;

  }

  callStepTwoRegister(){
    if(_validateEmptyFields()){
        serviceRegister();
    }else{
      utils.showSnackBar(context, msgError);
    }
  }

  serviceRegister() async {
   // print("VALOR ID CITY ${providerSettings?.citySelected?.id.toString()}");
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerOnBoarding.createAccountSocialNetwork(widget.name, widget.email, phoneController.text, providerSettings?.citySelected?.id.toString()??'', referredController.text,providerOnBoarding.stateContactCommercial,widget.typeRegister);
        await callUser.then((user) {
          Navigator.pushAndRemoveUntil(context, customPageTransition(InterestCategoriesUser(),PageTransitionType.fade), (route) => false);
        }, onError: (error) {
          utils.showSnackBar(context, error);
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
