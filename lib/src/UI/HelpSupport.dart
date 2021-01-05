import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/drawerMenu.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class SupportHelpPage extends StatefulWidget {
  @override
  _SupportHelpPageState createState() => _SupportHelpPageState();
}

class _SupportHelpPageState extends State<SupportHelpPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: _body(context),
      ),
    );
  }
  Widget _body(BuildContext context){
    return SingleChildScrollView(
      child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 21,right: 21),
              width: double.infinity,
              //height: 139,
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight:Radius.circular(30)),

              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            width: 31,
                            height: 31,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: CustomColors.blueActiveDots
                            ),
                            child: Center(
                              child: Image(
                                image: AssetImage("Assets/images/ic_menu.png"),
                              ),
                            ),
                          ),
                          onTap: (){
                            Navigator.of(context).push(
                                PageRouteBuilder(
                                    opaque: false, // set to false
                                    pageBuilder: (_, __, ___) => DraweMenuPage(rollOverActive: "support",)
                                ));
                          },
                        ),
                        Expanded(
                            child: Center(
                              child: Text(
                                "Soporte y servicios",
                                style: TextStyle(
                                    fontFamily: Strings.fontArialBold,
                                    fontSize: 16,
                                    color: CustomColors.blackLetter

                                ),
                              ),
                            )
                        ),

                      ],
                    ),


                    SizedBox(height: 20),


                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 70,right: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 135,
                    height: 135,
                    image: AssetImage("Assets/images/ic_customer.png"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    Strings.support,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: Strings.fontArialBold,
                      color: CustomColors.blackLetter
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(

                    Strings.supportMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: Strings.fontArial,
                        color: CustomColors.blueGray
                    ),
                  ),
                  SizedBox(height: 19),

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
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
                itemHelpCenter("question 1",(){}),

                itemHelpCenter("question 2",(){}),
                itemHelpCenter("question 3",(){}),
                itemHelpCenter("question 4",(){}),
                itemHelpCenter("question 5",(){}),
                itemHelpCenter("question 6",(){})


                ],
                )

                ),
              ),
            )



          ]
      ),
    );
  }

}
