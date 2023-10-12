import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/OnBoarding/DataProtectionPolicyPdfView.dart';
import 'package:wawamko/src/UI/OnBoarding/TermsAndConditionsView.dart';
import 'package:wawamko/src/UI/SearchCountryAndCity/SelectStates.dart';
import 'package:wawamko/src/UI/SearchCountryAndCity/selectCountry.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import '../../Utils/share_preference.dart';
import 'RegisterStepTwo.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final prefs = SharePreference();
  UserModel userModel = UserModel();
  GlobalVariables globalVariables = GlobalVariables();
  NotifyVariablesBloc? notifyVariables;
  ProviderSettings? providerSettings;
  late OnboardingProvider providerOnBoarding;
  String msgError = '';
  String assetPDFPath = "";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      providerOnBoarding.stateTerms = false;
      providerOnBoarding.stateDates = false;
      providerOnBoarding.stateCentrals = false;
      providerSettings!.countrySelected = null;
      providerSettings!.stateCountrySelected = null;
      providerSettings!.citySelected = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    providerOnBoarding = Provider.of<OnboardingProvider>(context);
    cityController.text = providerSettings?.citySelected?.name??'';

    return Scaffold(
      backgroundColor: Colors.white,
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
        header(context, Strings.register,CustomColors.red, ()=> Navigator.pop(context)),
        const SizedBox(height: 55,),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30),
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 6,),
                    Text(
                      "¡${Strings.createAccount}!",
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: Strings.fontBold, fontSize: 36, color: CustomColors.blueTitle),
                    ),
                    SizedBox(height: 17,),
                    Text(
                      Strings.registerMsg,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 18, color: CustomColors.black1),
                    ),
                    SizedBox(height: 52),
                    Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 600),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50,
                            child: FadeInAnimation(child: widget,),
                          ),
                          children: <Widget>[
                            customTextFieldIcon("ic_data.png",true, Strings.nameUser, nameController, TextInputType.text, [ LengthLimitingTextInputFormatter(30)]),
                            customTextFieldIcon("ic_data.png",true, Strings.lastName, lastNameController, TextInputType.text, [LengthLimitingTextInputFormatter(30)]),
                            InkWell(
                                onTap: ()=>openSelectCountry(),
                                child: textFieldIconSelector("ic_country.png",false, Strings.nationality, countryController)),
                            InkWell(
                                onTap: ()=>openSelectCityByState(),
                                child: textFieldIconSelector("ic_country.png",false, Strings.city, cityController)),
                            textFieldIconPhone(Strings.phoneNumber,providerSettings?.countrySelected?.callingCode??'',"ic_mobile.png",phoneController ),
                            SizedBox(height: 10),
                        //terms and conditions
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: providerSettings?.checkPolicies,
                              activeColor: CustomColors.blue,
                              checkColor: Colors.white,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3),),
                              fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return CustomColors.blue;
                                }
                                return CustomColors.gray;
                              }),
                              onChanged: (value) {
                                providerSettings?.checkPolicies = value!;
                              },
                            ),

                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: Strings.btnAccept,
                                      style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 15, color: CustomColors.gray,),
                                    ),
                                    TextSpan(
                                      text: ' ',
                                      style: TextStyle(fontSize: 15, color: CustomColors.gray,),
                                    ),
                                    TextSpan(
                                      text: Strings.acceptPoliciesTitle,
                                      style: TextStyle(fontFamily: Strings.fontRegular, fontSize: 15, color: CustomColors.blue,),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(context, customPageTransition(TermsAndConditionsView()));
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                            SizedBox(height: 30,),
                          ],
                        )),
                    btnCustomRounded(CustomColors.blueSplash, Colors.white, Strings.next, callStepTwoRegister, context) //btnCustomIcon("ic_next.png", , , , ))
                  ],
                ),
                SizedBox(height: 15,),
              ],
            ),
          ),
        ),
      ],
    );
  }

  openSelectCountry()async{
     await Navigator.push(context, customPageTransition(SelectCountryPage()));
     countryController.text = providerSettings?.countrySelected?.country??'';
     prefs.countryIdUser = providerSettings?.countrySelected?.id ??'';
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
    if(_validateEmptyFields() && providerSettings?.checkPolicies == true){
      userModel.name = nameController.text;
      userModel.lastName = lastNameController.text;
      userModel.numPhone = phoneController.text;
      userModel.cityId = providerSettings!.citySelected!.id;
      Navigator.push(context,customPageTransition(RegisterStepTwoPage(user: userModel)));
    }else{
      if(providerSettings?.checkPolicies == false){
        utils.showSnackBar(context, Strings.msgErrorPolicies);
      }else{
        utils.showSnackBar(context, msgError);
      }

    }
  }

}
