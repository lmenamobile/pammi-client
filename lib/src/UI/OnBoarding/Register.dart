import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/SearchCountryAndCity/SelectStates.dart';
import 'package:wawamko/src/UI/SearchCountryAndCity/selectCountry.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'RegisterStepTwo.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();

  UserModel userModel = UserModel();
  GlobalVariables globalVariables = GlobalVariables();
  NotifyVariablesBloc notifyVariables;
  ProviderSettings providerSettings;
  OnboardingProvider providerOnBoarding;
  String msgError = '';

  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context,listen: false);
    providerOnBoarding = Provider.of<OnboardingProvider>(context,listen: false);
    providerOnBoarding.stateTerms = false;
    providerOnBoarding.stateDates = false;
    providerOnBoarding.stateCentrals = false;
    providerSettings.countrySelected = null;
    providerSettings.stateCountrySelected = null;
    providerSettings.citySelected = null;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    cityController.text = providerSettings?.citySelected?.name;

    return Scaffold(
      backgroundColor: CustomColors.blueSplash,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: CustomColors.white,
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
                  child: Image(
                    fit: BoxFit.fill,
                    height: 100,
                    image: AssetImage("Assets/images/ic_header_signup.png"),
                  ),
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: GestureDetector(
                  child: Image(
                    image: AssetImage("Assets/images/ic_back_w.png"),
                    width: 40,
                    height: 40,
                  ),
                  onTap: ()=> Navigator.pop(context),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  Strings.register,
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 18,
                      color: CustomColors.white),
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
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          Strings.createAccount,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: Strings.fontBold,
                              fontSize: 24,
                              color: CustomColors.blackLetter),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          Strings.registerMsg,
                          style: TextStyle(
                              fontFamily: Strings.fontRegular,
                              color: CustomColors.gray7),
                        ),
                        SizedBox(height: 13),
                         Column(
                              children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 600),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              verticalOffset: 50,
                              child: FadeInAnimation(
                                child: widget,
                              ),
                            ),
                            children: <Widget>[
                              customTextFieldIcon("ic_data.png",true, Strings.nameUser,
                                  nameController, TextInputType.text, [ LengthLimitingTextInputFormatter(30)]),
                              customTextFieldIcon("ic_data.png",true, Strings.lastName,
                                  lastNameController, TextInputType.text, [LengthLimitingTextInputFormatter(30)]),
                              InkWell(
                                onTap: ()=>openSelectCountry(),
                                  child: customTextFieldIcon("ic_country.png",false, Strings.country, countryController, TextInputType.text, [])),
                              InkWell(
                                  onTap: ()=>openSelectCityByState(),
                                  child: customTextFieldIcon("ic_country.png",false, Strings.city, cityController, TextInputType.text, [])),
                              customTextFieldIcon("ic_telephone.png", true, Strings.phoneNumber,
                                  phoneController, TextInputType.number, [LengthLimitingTextInputFormatter(15),FilteringTextInputFormatter.digitsOnly]),
                              SizedBox(height: 30),
                            ],
                          )),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                            child: btnCustomIcon("ic_next.png", Strings.next, CustomColors.blueSplash, Colors.white, callStepTwoRegister))
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

  openSelectCountry()async{
     await Navigator.push(context, customPageTransition(SelectCountryPage()));
     countryController.text = providerSettings?.countrySelected?.country;
  }

  openSelectCityByState(){
    if(providerSettings?.countrySelected!=null) {
       Navigator.push(context, customPageTransition(SelectStatesPage()));
    }else{
      utils.showSnackBar(context, Strings.countryEmpty);
    }
  }


  bool _validateEmptyFields() {
    if (nameController.text.isEmpty) {
      msgError = Strings.emptyName;
      return false;
    }else if (lastNameController.text.isEmpty) {
      msgError = Strings.emptyLastName;
      return false;
    }else if (countryController.text.isEmpty) {
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
      userModel.name = nameController.text;
      userModel.lastName = lastNameController.text;
      userModel.numPhone = phoneController.text;
      userModel.cityId = providerSettings.citySelected.id;
      Navigator.push(context,customPageTransition(RegisterStepTwoPage(user: userModel)));
    }else{
      utils.showSnackBar(context, msgError);
    }
  }
}
