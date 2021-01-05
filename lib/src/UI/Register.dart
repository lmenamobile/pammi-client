import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wawamko/src/UI/RegisterStepTwo.dart';
import 'package:wawamko/src/UI/selectCountry.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/dialogAlertSelectDocument.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final typeDocumentController = TextEditingController();
  final numberIdentityController = TextEditingController();
  final countryController = TextEditingController();
  GlobalVariables globalVariables = GlobalVariables();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

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
                            customTextField("Assets/images/ic_data.png","Nombre", nameController),
                            SizedBox(height: 21),
                            customTextField("Assets/images/ic_data.png","Apellido", lastNameController),
                            SizedBox(height: 21),
                            customTextFieldAction("Assets/images/ic_identity.png", "Tipo de documento", typeDocumentController, (){pushToSelectDocument();}),
                            SizedBox(height: 21),
                            customTextField("Assets/images/ic_identity.png","Número de identificación", numberIdentityController),
                            SizedBox(height: 21),
                            customTextFieldAction("Assets/images/ic_country.png", "País", countryController, (){Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:SelectCountryPage(), duration: Duration(milliseconds: 700)));
                            }),
                            SizedBox(height: 46),

                          ],
                        )
                      ),
                      )




                    ],
                  ),
                ),


              ],
            ),
          ),
          SizedBox(height: 12),
          Center(
            child: GestureDetector(
              child: Container(
                child: Text(
                    "Siguiente",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: Strings.fontArial,
                    color: CustomColors.white
                  ),
                ),
              ),
              onTap: (){
                print("Next");
                Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:RegiterStepTwoPage(), duration: Duration(milliseconds: 700)));

              },
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );

  }

  pushToSelectDocument()async{
    var data = await  Navigator.of(context).push(
        PageRouteBuilder(
            opaque: false, // set to false
            pageBuilder: (_, __, ___) => DialogSelectDocument()
        ));
    if(data!=null){
      if(data){
        typeDocumentController.text = globalVariables.typeDocument.toString();
       setState(() {

       });

      }

    }
  }
}
