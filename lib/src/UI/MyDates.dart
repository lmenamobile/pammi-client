import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/UI/changePassword.dart';
import 'package:wawamko/src/UI/selectCountry.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class MyDatesPage extends StatefulWidget {
  @override
  _MyDatesPageState createState() => _MyDatesPageState();
}

class _MyDatesPageState extends State<MyDatesPage> {

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final typeDocumentController = TextEditingController();
  final numberIdentityController = TextEditingController();
  final countryController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(mask: '###############', filter: { "#": RegExp(r'[0-9]') });

  NotifyVariablesBloc notifyVariables;

 // var edit = false;
  GlobalVariables globalVariables = GlobalVariables();


@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return Scaffold(
      backgroundColor: CustomColors.whiteBackGround,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context){
    //final bloc = Provider.ofVariables(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(


            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
              color: CustomColors.blueProfile
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[
                Container(

                  height: 100,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      child:  Container(

                        width: double.infinity,
                        height: 40,

                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 20,
                              top: 5,
                              child: GestureDetector(
                                child: Image(
                                  width: 25,
                                  height: 25,
                                  image: AssetImage("Assets/images/ic_backward_arrow.png"),

                                ),
                                onTap: (){Navigator.pop(context);},
                              ),
                            ),

                            Center(
                              child: Container(
                                //alignment: Alignment.center,

                                child: Text(
                                  Strings.myDates,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(

                                      fontSize: 15,
                                      fontFamily: Strings.fontArialBold,
                                      color: CustomColors.white
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 36),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          border: Border.all(color: CustomColors.white  ,width: 1),

                        ),
                        child: Center(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  border: Border.all(color: CustomColors.white  ,width: 1),
                                  color: CustomColors.grayBackground,

                                ),
                                child: Image(
                                  image: AssetImage("Assets/images/ic_default_perfil.png"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 13,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              Strings.changePhoto,
                              style: TextStyle(
                                fontFamily: Strings.fontArial,
                                fontSize: 14,
                                color: CustomColors.white.withOpacity(.8),
                                decoration: TextDecoration.underline
                              ),
                          ),
                          SizedBox(height: 15,),
                          notifyVariables.edit2 ? Container(width: 101, child: btnCustomRounded(CustomColors.white, CustomColors.blueActiveDots,Strings.saveDates , (){

                            notifyVariables.edit2 ? notifyVariables.edit2 = false : notifyVariables.edit2 = true;




                          },context)): Container(width: 101, child: btnCustomRounded(CustomColors.white, CustomColors.blueActiveDots,Strings.edit , (){

                            notifyVariables.edit2 ? notifyVariables.edit2 = false : notifyVariables.edit2 = true;




                          },context))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 28),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 33,right: 33),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 600),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),

                children: <Widget>[
                  Text(
                    Strings.personalInfo,
                    style: TextStyle(
                        fontSize: 15,
                        color: CustomColors.blackLetter,
                        fontFamily: Strings.fontArialBold
                    ),
                  ),
                  SizedBox(height: 20),
                  customTextField("Assets/images/ic_data.png","Nombre", nameController,TextInputType.text,[]),
                  SizedBox(height: 21),
                  customTextField("Assets/images/ic_data.png","Apellido", lastNameController,TextInputType.text,[]),
                  SizedBox(height: 21),
                  customTextField("Assets/images/ic_identity.png","Número de identificación", numberIdentityController,TextInputType.number,[]),
                  SizedBox(height: 21),
                   customTextFieldAction("Assets/images/ic_country.png", "País", countryController, (){Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:SelectCountryPage(), duration: Duration(milliseconds: 700)));
                  }),
                  SizedBox(height: 21),
                  customTextField("Assets/images/ic_telephone.png","Número de telefono", numberIdentityController,TextInputType.number,[maskFormatter]),
                  SizedBox(height: 21),
                  customTextField("Assets/images/ic_email_blue.png","Email", numberIdentityController,TextInputType.emailAddress,[]),
                  SizedBox(height: 18),
                  !notifyVariables.edit2 ? GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Image(
                          width:13,
                          height:13,
                          image: AssetImage("Assets/images/ic_close_red.png"),
                        ),
                        SizedBox(width: 5),
                        Text(
                          Strings.deleteAccount,
                          style: TextStyle(
                            fontFamily: Strings.fontArial,
                            fontSize: 16,
                            color: CustomColors.red
                          ),
                        )
                      ],
                    ),
                    onTap: (){utils.startCustomAlertMessage(context, "¡Espera!", "Assets/images/ic_error2.png", "¿Estas seguro deseas eliminar tu cuenta Wawamko?", (){Navigator.pop(context);},(){Navigator.pop(context);});},
                  ) : Container(),
                  // customTextFieldAction("Assets/images/ic_country.png", "País", countryController, (){Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:SelectCountryPage(), duration: Duration(milliseconds: 700)));
                  //}),
                 // notifyVariables.edit2  ? SizedBox(height: 46) : SizedBox(height: 0),

                ],
              )

            ),
          ),
          notifyVariables.edit2 ? Container(
              margin: EdgeInsets.only(top: 0,bottom: 40),
              padding: EdgeInsets.only(left: 60,right: 60),
              child:  btnCustomRounded(CustomColors.orange, CustomColors.white, Strings.changePass, (){ Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:ChangePasswordPage(), duration: Duration(milliseconds: 700))); },context)
          ): Container()

        ],
      ),
    );
  }






}
