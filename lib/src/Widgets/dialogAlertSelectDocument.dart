


import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';


class DialogSelectDocument extends StatefulWidget{

  @override
  DialogSelectDocumentState createState()=> DialogSelectDocumentState();
}

class DialogSelectDocumentState extends State<DialogSelectDocument>{
GlobalVariables globalVariables  = GlobalVariables();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.black.withOpacity(.6),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _body(context)
        ));
  }
  
  Widget _body(BuildContext context){
    return FlipInY(
      child: Container(
        child: Center(
  //    children: <Widget>[
            child: Container(
              margin: EdgeInsets.only(left: 23,right: 23),
             // height: 400,
              //color: CustomColors.white,
              width: double.infinity,
              child: Stack(
                children: <Widget>[

                  Container(
                    margin: EdgeInsets.only(top: 30),
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: CustomColorsAPP.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              Strings.tipeDocument,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: Strings.fontBold,
                                color: CustomColorsAPP.blackLetter,


                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            margin: EdgeInsets.only(left: 20,right: 20),
                            height: 1,
                            color: CustomColorsAPP.gray.withOpacity(.2),
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                            child: Container(
                              width: double.infinity,
                              height: 20,
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                Strings.cedulaCiudadania,
                                style: TextStyle(
                                  fontFamily: Strings.fontRegular,
                                  fontSize: 15,
                                  color: CustomColorsAPP.blackLetter
                                ),


                              ),
                            ),
                            onTap: (){
                              globalVariables.typeDocument =  Strings.cedulaCiudadania;
                              Navigator.pop(context,true);
                            },
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.only(left: 20,right: 20),
                            height: 1,
                            color: CustomColorsAPP.gray.withOpacity(.1),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            child: Container(
                              width: double.infinity,
                              height: 20,
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                Strings.cedulaExtranjeria,
                                style: TextStyle(
                                    fontFamily: Strings.fontRegular,
                                    fontSize: 15,
                                    color: CustomColorsAPP.blackLetter
                                ),


                              ),
                            ),
                            onTap: (){
                              globalVariables.typeDocument = Strings.cedulaExtranjeria;
                              Navigator.pop(context,true);
                            },
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.only(left: 20,right: 20),
                            height: 1,
                            color: CustomColorsAPP.gray.withOpacity(.1),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            child: Container(
                              width: double.infinity,
                              height: 20,
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                Strings.passport,
                                style: TextStyle(
                                    fontFamily: Strings.fontRegular,
                                    fontSize: 15,
                                    color: CustomColorsAPP.blackLetter
                                ),


                              ),
                            ),
                            onTap: (){
                              globalVariables.typeDocument = Strings.passport;
                              Navigator.pop(context,true);
                            },
                          ),
                          //SizedBox(height: 10),

                          SizedBox(height: 20),
                        ],
                      ),
                    ),

                  ),
                  Container(
                    width: double.infinity,
                    height: 50,

                    //color: CustomColors.red,
                    child:  Center(
                      child: Container(
                          width: 51,
                          height: 51,
                          decoration: BoxDecoration(
                              color: CustomColorsAPP.blueActiveDots,
                              borderRadius: BorderRadius.all(Radius.circular(100))
                          ),
                          child: Center(
                            child: GestureDetector(
                              child: Container(
                                width: 30,
                                height: 30,
                                // color: CustomColors.blueClose,
                                child: Image(
                                    image: AssetImage("Assets/images/ic_close.png")),
                              ),
                              onTap: (){
                                Navigator.pop(context);
                              },
                            ),
                          )
                      ),



                    ),
                  ),
                ],


            )

            )
        ),
      ),
    );
  }

}
