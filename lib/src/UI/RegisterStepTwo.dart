import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';


import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/confirmationSlide.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class RegiterStepTwoPage extends StatefulWidget {
  @override
  _RegiterStepTwoPageState createState() => _RegiterStepTwoPageState();
}

class _RegiterStepTwoPageState extends State<RegiterStepTwoPage> {

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool checkTerms = false;
  bool obscureTextPass = true;
  bool obscureTextConfirmPass = true;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        color: CustomColors.blueActiveDots,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context){
  //  final bloc = Provider.ofRegister(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(

            decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50))
            ),
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Image(
                      width: 80,
                      height: 80,
                      image: AssetImage("Assets/images/ic_arrow_menu.png"),
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: 29,top: 50),
                  child: Image(
                    width: 80,
                    height: 80,
                    image: AssetImage("Assets/images/ic_logo_l.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 140,left: 29),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Text(
                        Strings.welcome,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: Strings.fontArial,
                            fontSize: 15,
                            color: CustomColors.blackLetter
                        ),
                      ),
                      SizedBox(height: 6,),
                      Text(
                        Strings.register,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: Strings.fontArialBold,
                            fontSize: 24,
                            color: CustomColors.blackLetter
                        ),
                      ),
                      SizedBox(height: 6,),
                      Text(
                        Strings.inputDates  ,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: Strings.fontArial,
                            fontSize: 15,
                            color: CustomColors.blackLetter
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        Strings.textResgister,
                        style: TextStyle(
                            fontFamily: Strings.fontArial,
                            fontSize:14,
                            color: CustomColors.blackLetter
                        ),
                      ),
                      SizedBox(height: 38),

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
                                customTextField("Assets/images/ic_telephone.png","Número telefónico", phoneController),
                                SizedBox(height: 21),
                                customBoxEmailRegister(emailController),
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
                      SizedBox(height: 17),
                      Padding(
                        padding: EdgeInsets.only(left: 6,right: 18),
                        child: Text(
                          Strings.AuthorizeDates,
                          style: TextStyle(
                            fontFamily: Strings.fontArial,
                            fontSize: 14,
                            color: CustomColors.blackLetter
                          ),
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
                                width: 18,
                                height: 18,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("Assets/images/ic_approved_blue.png")
                                  )
                                  //border: Border.all(color:  CustomColors.blueActiveDots ,width: 1),

                                ),
                              ),
                              onTap: (){
                                this.checkTerms = false;
                                print("true");
                                setState(() {

                                });
                              },
                            ) : GestureDetector(
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color:  CustomColors.blueActiveDots ,width: 1),

                                ),
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
                                              fontFamily: Strings.fontArial, color: CustomColors.blueActiveDots, decoration: TextDecoration.underline)
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
                                        recognizer: TapGestureRecognizer() ..onTap = () => launch("URL"),
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


              ],
            ),
          ),
          SizedBox(height: 12),
          Center(
            child: Container(
              child: GestureDetector(
                child: Text(
                  "Registrarme",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: Strings.fontArial,
                      color: CustomColors.white
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(
                      PageRouteBuilder(
                          opaque: false, // set to false
                          pageBuilder: (_, __, ___) => ConfirmationSlidePage()
                      ));
                  print("Registrarme");
                },
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );

  }

  Widget customBoxPassword(TextEditingController passwordController){
    return StreamBuilder(

        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //  width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                    border: Border.all(color:  CustomColors.gray.withOpacity(.3) ,width: 1.3),
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
                          image:AssetImage("Assets/images/ic_padlock_blue.png") ,

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
                               // bloc.changePassword(value);
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Image(
                            width: 35,
                            height: 35,
                            image:obscureTextPass ? AssetImage("Assets/images/ic_no_show_grey.png") : AssetImage("Assets/images/ic_show_grey.png"),
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
    return StreamBuilder(

        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //  width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                    border: Border.all(color:  CustomColors.gray.withOpacity(.3) ,width: 1.3),
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
                          image:AssetImage("Assets/images/ic_padlock_blue.png") ,

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
                               // bloc.changeConfirmPassword(value);
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Image(
                            width: 35,
                            height: 35,
                            image:obscureTextConfirmPass ? AssetImage("Assets/images/ic_no_show_grey.png") : AssetImage("Assets/images/ic_show_grey.png"),
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


}
