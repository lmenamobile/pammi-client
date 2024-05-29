import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/Providers/SupportProvider.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';

import 'package:wawamko/src/Utils/share_preference.dart';

import '../MenuLeft/DrawerMenu.dart';


class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  SharePreference _prefs = SharePreference();
  late ProfileProvider profileProvider;
  late SupportProvider supportProvider;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  bool checkTerms = false;
  bool checkDates = false;
  bool bandAllFields = false;
  String msgError = "";

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    supportProvider = Provider.of<SupportProvider>(context);
    profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      key: _drawerKey,
      drawer: DrawerMenuPage(
        rollOverActive: "profile",
      ),
      backgroundColor: CustomColorsAPP.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColorsAPP.whiteBackGround,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 235,
          width: double.infinity,
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage("Assets/images/ic_bg_profile.png"),
          ),
        ),
        Column(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: GestureDetector(
                      child: Container(
                        width: 31,
                        height: 31,
                        child: Center(
                          child: Image(
                            image: AssetImage("Assets/images/ic_back_w.png"),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child:  Text(
                      Strings.titleInterests,
                      style: TextStyle(
                          fontFamily: Strings.fontBold,
                          fontSize: 24,
                          color: CustomColorsAPP.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:  Text(
                      Strings.txInterests,
                      style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 14,
                          color: CustomColorsAPP.white),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Expanded(child: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: CustomColorsAPP.blackLetter.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          customTextField(Strings.name, nameController, TextInputType.text, []),
                          SizedBox(height: 15),
                          customTextField(Strings.phone, phoneController, TextInputType.number, <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(15)
                          ]),
                          SizedBox(height: 15),
                          customTextField(Strings.email, emailController, TextInputType.emailAddress, []),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                checkDates
                                    ? GestureDetector(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "Assets/images/ic_check2.png"))),
                                  ),
                                  onTap: () {
                                    this.checkDates = false;
                                    print("true");
                                    bandAllFields = false;
                                    setState(() {});
                                  },
                                )
                                    : GestureDetector(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "Assets/images/ic_check.png"))),
                                  ),
                                  onTap: () {
                                    this.checkDates = true;
                                    print("False");
                                    setState(() {});
                                    validateEmptyFields();
                                  },
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    Strings.AuthorizeDates,
                                    style: TextStyle(
                                        fontFamily: Strings.fontRegular,
                                        fontSize: 12,
                                        color: CustomColorsAPP.blackLetter),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 14),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              checkTerms
                                  ? GestureDetector(
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "Assets/images/ic_check2.png")))),
                                onTap: () {
                                  this.checkTerms = false;
                                  print("true");
                                  bandAllFields = false;
                                  setState(() {});
                                },
                              )
                                  : GestureDetector(
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "Assets/images/ic_check.png")))),
                                onTap: () {
                                  this.checkTerms = true;
                                  print("False");
                                  setState(() {});
                                  validateEmptyFields();
                                },
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      style: TextStyle(
                                        height: 1.5,
                                        fontSize: 12,
                                        color: CustomColorsAPP.blackLetter,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "He leido y acepto los ",
                                            style: TextStyle(
                                              fontFamily: Strings.fontRegular,
                                            )),
                                        TextSpan(
                                          text: "Terminos y condiciones",
                                          style: TextStyle(
                                              fontFamily: Strings.fontRegular,
                                              color: CustomColorsAPP.blueActiveDots,
                                              decoration: TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => launch(
                                                "https://pamii-dev.s3.us-east-2.amazonaws.com/wawamko/system/Clientes_Terminos+y+condiciones.pdf"),
                                        ),
                                        TextSpan(
                                            text: " y la",
                                            style: TextStyle(
                                              fontFamily: Strings.fontRegular,
                                            )),
                                        TextSpan(
                                          text: " Política de privacidad",
                                          style: TextStyle(
                                              fontFamily: Strings.fontRegular,
                                              color: CustomColorsAPP.blueActiveDots,
                                              decoration: TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => launch(
                                                "https://pamii-dev.s3.us-east-2.amazonaws.com/wawamko/system/Cliente_Politica_De_Tratamiento_De_Datos_Personales.pdf"),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: ()=>callServicePreRegister(),
                      child: Container(
                        width: 200,
                        height: 45,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 50, right: 50 ,top: 25, bottom: 20),
                        decoration: BoxDecoration(
                          color: bandAllFields ? CustomColorsAPP.yellowOne : CustomColorsAPP.greyBorder,
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                        ),
                        child:  Text(
                          Strings.send,
                          style: TextStyle(
                              fontFamily: Strings.fontRegular,
                              fontSize: 14,
                              color: CustomColorsAPP.blueSplash),
                        ),

                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        )
      ],
    );
  }

  Widget customTextField(
      String hintText,
      TextEditingController controller,
      TextInputType inputType,
      List<TextInputFormatter> formaters) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(color: CustomColorsAPP.gray2, width: 1),
          color: CustomColorsAPP.grayMenu),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              width: 200,
              child: TextField(
                inputFormatters: formaters,
                keyboardType: inputType,
                controller: controller,
                onChanged: (value){
                  validateEmptyFields();
                },
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    color: CustomColorsAPP.blackLetter),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: CustomColorsAPP.grayLetter2.withOpacity(.4),
                    fontFamily: Strings.fontRegular,
                  ),
                  hintText: hintText,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  validateEmptyFields() {
    if (nameController.text.toString().trim().isEmpty) {
      bandAllFields =  false;
    } else if (phoneController.text.toString().trim().isEmpty) {
      bandAllFields =  false;
    } else if (emailController.text == "") {
      bandAllFields =  false;
    } else if (!validateEmail(emailController.text)) {
      bandAllFields =  false;
    } else if (!checkDates) {
      bandAllFields =  false;
    } else if (!checkTerms) {
      bandAllFields =  false;
    } else {
      bandAllFields =  true;
    }
    setState(() {});
  }


  bool validateForm() {
    bool validateForm = true;
    if (nameController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.emptyName;
    } else if (phoneController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.emptyPhone;
    } else if (emailController.text.trim().isEmpty) {
      validateForm = false;
      msgError = Strings.emptyEmail;
    } else if (!validateEmail(emailController.text.trim())) {
      validateForm = false;
      msgError = Strings.emailInvalid;
    }else if (!checkDates) {
      validateForm = false;
      msgError = Strings.dontCheckDates;
    }else if (!checkTerms) {
      validateForm = false;
      msgError = Strings.dontCheckTerms;
    }
    return validateForm;
  }

  callServicePreRegister(){
    if(validateForm()){
      if(_prefs.authToken=="0"){
        serviceSellerNOtLogin(nameController.text, emailController.text.trim());
      }else{
        serviceSeller();
      }
    }else{
      utils.showSnackBar(context,msgError.toString());
    }
  }

  serviceSellerNOtLogin(String name,String email) {
    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser = supportProvider.betSellerNotLogin(name, email);
        await callUser.then((msg) {
          Navigator.pop(context);
          utils.showSnackBarGood(context,msg.toString());
        }, onError: (error) {
          Navigator.pop(context);
          utils.showSnackBar(context,error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  serviceSeller() {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = supportProvider.betSeller();
        await callUser.then((msg) {
          Navigator.pop(context);
          utils.showSnackBarGood(context,msg.toString());
        }, onError: (error) {
          Navigator.pop(context);
          utils.showSnackBar(context,error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

}
