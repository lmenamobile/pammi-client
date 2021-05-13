import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/UI/HomePage.dart';


import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/confirmationSlide.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class RegiterStepTwoPage extends StatefulWidget {

  final UserModel user;
  RegiterStepTwoPage({Key key,this.user}) : super(key: key);

  @override
  _RegiterStepTwoPageState createState() => _RegiterStepTwoPageState();
}

class _RegiterStepTwoPageState extends State<RegiterStepTwoPage> {

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(mask: '###############', filter: { "#": RegExp(r'[0-9]') });
  NotifyVariablesBloc notifyVariables;


  bool checkTerms = false;
  bool checkDates = false;
  bool obscureTextPass = true;
  bool obscureTextConfirmPass = true;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: CustomColors.white,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context){
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 107,
          child: Stack(
            children: <Widget>[
              Positioned(
                left:0,
                right: 0,
                top: 0,
                child: Image(

                  fit: BoxFit.fitWidth,
                  image: AssetImage("Assets/images/ic_header_signup.png"),
                ),


              ),
              Positioned(
                top: 15,
                left: 15,

                child:  GestureDetector(
                  child: Image(
                    image: AssetImage("Assets/images/ic_back_w.png"),
                    width: 40,
                    height: 40,
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),


              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 25),
                child: Text(
                  Strings.register,
                  style: TextStyle(
                      fontFamily: Strings.fontArial,
                      fontSize: 18,
                      color: CustomColors.white
                  ),
                ),
              ),

            ],
          ),
        ),
        Positioned(
          top: 110,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                  Padding(
                  padding: const EdgeInsets.only(top: 17,left: 29),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[

                      SizedBox(height: 6,),
                      Text(
                        Strings.createAccount,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: Strings.fontArialBold,
                            fontSize: 24,
                            color: CustomColors.blackLetter
                        ),
                      ),
                      SizedBox(height: 6,),
                      Text(
                        Strings.registerMsg,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: Strings.fontArial,
                            fontSize: 15,
                            color: CustomColors.blackLetter
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 6,right: 35),
                        child: Column(
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 600),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: widget,
                                ),
                              ),

                              children: <Widget>[
                                customTextField("Assets/images/ic_telephone.png","Número telefónico", phoneController,TextInputType.number,[maskFormatter]),
                                SizedBox(height: 21),
                                customBoxEmailRegister(emailController,notifyVariables,(){setState(() {

                                });}),
                                SizedBox(height: 21),
                                customBoxPassword(passwordController),
                                SizedBox(height: 21),
                                customBoxConfirmPassword(confirmPassController)
                                //customTextField("Assets/images/ic_email_blue.png","Apellido", emailController),

                                //customTextField("Assets/images/ic_email_blue.png","Apellido", emailController),
                                //SizedBox(height: 21),
                                //customTextField("Assets/images/ic_identity.png","Número de identificación", numberIdentityController),
                                //SizedBox(height: 21),
                                //customTextFieldAction("Assets/images/ic_country.png", "País", countryController, (){}),
                                //SizedBox(height: 46),

                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 6,right: 18),
                        child: Text(
                          Strings.challengePassword,
                          style: TextStyle(
                              fontFamily: Strings.fontArial,
                              fontSize: 10,
                              color: CustomColors.grayLetter2
                          ),
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(right: 17,top: 30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            checkDates ? GestureDetector(
                              child: Container(
                                width:30,
                                height: 30,

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage("Assets/images/ic_check2.png")
                                    )
                                  //border: Border.all(color:  CustomColors.blueActiveDots ,width: 1),

                                ),
                              ),
                              onTap: (){
                                this.checkDates = false;
                                print("true");
                                setState(() {

                                });
                              },
                            ) : GestureDetector(
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage("Assets/images/ic_check.png")
                                    )
                                  //border: Border.all(color:  CustomColors.blueActiveDots ,width: 1),

                                ),
                              ),
                              onTap: (){
                                this.checkDates = true;
                                print("False");
                                setState(() {

                                });
                              },
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child:  Text(
                                  Strings.AuthorizeDates,
                                  style: TextStyle(
                                      fontFamily: Strings.fontArial,
                                      fontSize: 14,
                                      color: CustomColors.blackLetter
                                  ),
                                ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 21),
                      Padding(
                        padding: const EdgeInsets.only(right: 17),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            checkTerms ? GestureDetector(
                              child: Container(
                                  width:30,
                                  height: 30,

                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage("Assets/images/ic_check2.png")
                                      )
                                    //border: Border.all(color:  CustomColors.blueActiveDots ,width: 1),

                                  )
                              ),
                              onTap: (){
                                this.checkTerms = false;
                                print("true");
                                setState(() {

                                });
                              },
                            ) : GestureDetector(
                              child: Container(
                                  width:30,
                                  height: 30,

                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage("Assets/images/ic_check.png")
                                      )
                                    //border: Border.all(color:  CustomColors.blueActiveDots ,width: 1),

                                  )
                              ),
                              onTap: (){
                                this.checkTerms = true;
                                print("False");
                                setState(() {

                                });
                              },
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child:  RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    style: TextStyle(
                                      height: 1.5,
                                      fontSize: 14,
                                      color: CustomColors.gray,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "He leido y acepto los ",
                                          style: TextStyle(
                                              fontFamily: Strings.fontArial, color: CustomColors.gray)
                                      ),

                                      TextSpan(

                                          text: "Terminos y condiciones",
                                          style: TextStyle(
                                              fontFamily: Strings.fontArial, color: CustomColors.blueActiveDots, decoration: TextDecoration.underline),
                                        recognizer: TapGestureRecognizer() ..onTap = () => launch("https://pamii-dev.s3.us-east-2.amazonaws.com/wawamko/system/Clientes_Terminos+y+condiciones.pdf"),

                                      ),

                                      TextSpan(
                                          text: " y la",
                                          style: TextStyle(
                                              fontFamily: Strings.fontArial, color: CustomColors.gray)
                                      ),

                                      TextSpan(

                                        text: " Política de privacidad",
                                        style: TextStyle(
                                            fontFamily: Strings.fontArial,color: CustomColors.blueActiveDots, decoration: TextDecoration.underline),
                                        recognizer: TapGestureRecognizer() ..onTap = () => launch("https://pamii-dev.s3.us-east-2.amazonaws.com/wawamko/system/Cliente_Politica_De_Tratamiento_De_Datos_Personales.pdf"),
                                      ),

                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 32),




                    ],
                  ),
                ),

                SizedBox(height: 12),


                Padding(
                  padding: EdgeInsets.only(bottom: 20,left: 80,right: 80),
                  child: btnCustomRoundedImage(CustomColors.blueSplash, CustomColors.white, Strings.next, (){ _serviceRegister();}, context,"Assets/images/ic_next.png"),
                )
              ],
            ),
          ),
        ),
      ],

    );

  }

  Widget customBoxPassword(TextEditingController passwordController){
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return StreamBuilder(

        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //  width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                    border: Border.all(color: !notifyVariables.intRegister.validPass ? CustomColors.gray.withOpacity(.3) : CustomColors.blueSplash,width: 1.3),
                    color: CustomColors.white
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          width: 35,
                          height: 35,
                          image: notifyVariables.intRegister.validPass ? AssetImage("Assets/images/ic_padlock_blue.png") : AssetImage("Assets/images/ic_padlock.png"),

                        ),
                        SizedBox(width: 6,),
                        Expanded(
                          child: Container(
                            width: 200,
                            child: TextField(
                              obscureText:obscureTextPass,
                              controller: passwordController,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Strings.fontArial,
                                  color:CustomColors.blackLetter
                              ),

                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color:  CustomColors.grayLetter.withOpacity(.4),
                                  fontSize: 16,
                                  fontFamily: Strings.fontArial,

                                ),
                                hintText: Strings.password,
                              ),
                              onChanged: (value){
                              if(validatePwd(value)){
                                notifyVariables.intRegister.validPass = true;
                                setState(() {

                                });
                              }else{
                                notifyVariables.intRegister.validPass = false;
                                setState(() {

                                });
                              }
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Image(
                            width: 35,
                            height: 35,
                            image: !notifyVariables.intRegister.validPass ? obscureTextPass ? AssetImage("Assets/images/ic_no_show_grey.png") : AssetImage("Assets/images/ic_show_grey.png") : obscureTextPass ? AssetImage("Assets/images/ic_no_show_blue.png") : AssetImage("Assets/images/ic_show_blue.png"),
                          ),
                          onTap: (){
                            this.obscureTextPass ? this.obscureTextPass = false : this.obscureTextPass = true;
                            setState(() {

                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              //SizedBox(height: 20,),
              snapshot.hasError ?  Padding(
                padding: const EdgeInsets.only(left: 8,top: 2),
                child: Text(Strings.passwordChallenge,style: TextStyle(fontFamily: Strings.fontArial,fontSize: 13,color: CustomColors.red),),

              ): Container(

              )
            ],
          );
        }
    );

  }


  Widget customBoxConfirmPassword(TextEditingController passwordController){
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return StreamBuilder(

        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //  width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                    border: Border.all(color:notifyVariables.intRegister.validConfirmPass ? CustomColors.blueSplash :  CustomColors.gray.withOpacity(.3) ,width: 1.3),
                    color: CustomColors.white
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          width: 35,
                          height: 35,
                          image: notifyVariables.intRegister.validConfirmPass  ? AssetImage("Assets/images/ic_padlock_blue.png") : AssetImage("Assets/images/ic_padlock.png"),

                        ),
                        SizedBox(width: 6,),
                        Expanded(
                          child: Container(
                            width: 200,
                            child: TextField(
                              obscureText:obscureTextConfirmPass,
                              controller: passwordController,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Strings.fontArial,
                                  color:CustomColors.blackLetter
                              ),

                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color:  CustomColors.grayLetter.withOpacity(.4),
                                  fontSize: 16,
                                  fontFamily: Strings.fontArial,

                                ),
                                hintText: Strings.confirmPassword,
                              ),
                              onChanged: (value){
                               if(validatePwd(value)){
                                 notifyVariables.intRegister.validConfirmPass = true;
                                 setState(() {

                                 });
                               }else{
                                 notifyVariables.intRegister.validConfirmPass = false;
                                 setState(() {

                                 });
                               }
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Image(
                            width: 35,
                            height: 35,
                            image:  !notifyVariables.intRegister.validConfirmPass ? obscureTextConfirmPass ? AssetImage("Assets/images/ic_no_show_grey.png") : AssetImage("Assets/images/ic_show_grey.png")  : obscureTextConfirmPass ? AssetImage("Assets/images/ic_no_show_blue.png") : AssetImage("Assets/images/ic_show_blue.png"),
                          ),
                          onTap: (){
                            this.obscureTextConfirmPass ? this.obscureTextConfirmPass = false : this.obscureTextConfirmPass = true;
                            setState(() {

                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              //SizedBox(height: 20,),
              snapshot.hasError ?  Padding(
                padding: const EdgeInsets.only(left: 8,top: 2),
                child: Text(Strings.passwordChallenge,style: TextStyle(fontFamily: Strings.fontArial,fontSize: 13,color: CustomColors.red),),

              ): Container(

              )
            ],
          );
        }
    );

  }

  bool _validateEmptyFields(){



    if(phoneController.text == "" ){
      utils.showSnackBar(context, Strings.emptyPhone);
      return true;
    }

    if(emailController.text == "" ){
      utils.showSnackBar(context, Strings.emptyEmail);
      return true;
    }

    if(passwordController.text == "" ){
      utils.showSnackBar(context, Strings.passwordEmpty);
      return true;
    }

    if(confirmPassController.text == "" ){
      utils.showSnackBar(context, Strings.emptyConfirmPassword);
      return true;
    }

    if(!validateEmail(emailController.text)){
      utils.showSnackBar(context,Strings.emailInvalid);
      return true;
    }

    if(!validatePwd(passwordController.text)){
      utils.showSnackBar(context,Strings.passwordChallenge);
      return true;
    }

    if(confirmPassController.text != passwordController.text){
      utils.showSnackBar(context, Strings.dontSamePass);
      return true;
    }

    if(!checkDates){
      utils.showSnackBar(context, Strings.dontCheckDates);
      return true;
    }

    if(!checkTerms){
      utils.showSnackBar(context, Strings.dontCheckTerms);
      return true;
    }



    widget.user.numPhone = phoneController.text;
    widget.user.email = emailController.text;
    widget.user.passWord = passwordController.text;

    return false;

  }

  _serviceRegister() async {
    FocusScope.of(context).unfocus();

    if (_validateEmptyFields()) {

      return;
    }


    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser = OnboardingProvider.instance.createAccount(context, widget.user);
        await callUser.then((user) {

          var decodeJSON = jsonDecode(user);
          ResponseUserinfo data = ResponseUserinfo.fromJsonMap(decodeJSON);

          if(data.code.toString() == "100") {

            var dataUser = data.data.user;


           //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BaseNavigationPage()), (Route<dynamic> route) => false);
            Navigator.pop(context);
            utils.startOpenSlideUp(context,widget.user);
            //Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child: MyHomePage(), duration: Duration(milliseconds: 700)));

          } else {

            Navigator.pop(context);
            utils.showSnackBar(context, data.message);

          }
        }, onError: (error) {

          Navigator.pop(context);
          utils.showSnackBar(context, Strings.serviceError);


        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
        print("you has not internet");

      }
    });
  }


}
