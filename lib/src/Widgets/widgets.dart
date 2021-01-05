
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spring_button/spring_button.dart';


import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';


Widget customBoxEmailLogin(TextEditingController emailController){
  return StreamBuilder(

  builder: (BuildContext context, AsyncSnapshot snapshot){
    return Container(
    //  width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
       border: Border.all(color: snapshot.hasData ? snapshot.hasError ? CustomColors.gray.withOpacity(.3) : CustomColors.blueActiveDots : CustomColors.gray.withOpacity(.3),width: 1.3),
       color: CustomColors.white
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                width: 35,
                height: 35,
                image:snapshot.hasData ? snapshot.hasError ? AssetImage("Assets/images/ic_email.png") :AssetImage("Assets/images/ic_email_blue.png") : AssetImage("Assets/images/ic_email.png")  ,

              ),
              SizedBox(width: 6,),
              Expanded(
                child: Container(
                  width: 200,
                  child: TextField(

                    controller: emailController,
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
                      hintText: Strings.email,
                    ),
                    onChanged: (value){
                      //bloc.changeEmail(value);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  );

}



Widget customBoxEmailRegister(TextEditingController emailController){
  return StreamBuilder(
     // stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              //  width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                  border: Border.all(color:  CustomColors.gray.withOpacity(.3),width: 1.3),
                  color: CustomColors.white
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        width: 35,
                        height: 35,
                        image:AssetImage("Assets/images/ic_email_blue.png"),

                      ),
                      SizedBox(width: 6,),
                      Expanded(
                        child: Container(
                          width: 200,
                          child: TextField(

                            controller: emailController,
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
                              hintText: Strings.email,
                            ),
                            onChanged: (value){
                             // bloc.changeEmail(value);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            snapshot.hasError ?  Padding(
              padding: const EdgeInsets.only(left: 8,top: 2),
              child: Text("Email Invalido example@xxx.com",style: TextStyle(fontFamily: Strings.fontArial,fontSize: 13,color: CustomColors.red),),

            ): Container(

            )
          ],
        );
      }
  );

}

Widget btnCustomRounded(Color backgroungButton,Color textColor, String textButton,Function action,BuildContext context){

  return SpringButton(
    SpringButtonType.OnlyScale,

    Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: backgroungButton
      ),
      child: Center(
        child: Text(
          textButton,
          style: TextStyle(
            fontSize: 14,
            fontFamily: Strings.fontArial,
            color: textColor
          ),
        ),
      ),
    ),
    onTapUp: (_){
        action();
    },
  );
}

Widget itemConnectTo(String logo,Function actionConnect){
  return SpringButton(
    SpringButtonType.OnlyScale,
    Container(
      width: 46,
      height: 47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: CustomColors.whiteBackGround
      ),
      child: Center(
        child: Image(
          width: 35,
          height: 35,
          fit: BoxFit.fill,
          image: AssetImage(logo),
        ),
      ),
    ),
    onTapUp: (_){
      actionConnect();
    },
  );



}

Widget customTextField(String icon,String hintText,TextEditingController controller){
  return Container(
    padding: EdgeInsets.only(left: 10),
    height: 52,
    decoration: BoxDecoration(
        border: Border.all(color:  CustomColors.gray.withOpacity(.3) ,width: 1.3),
        color: CustomColors.white

    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          width: 35,
          height: 35,
          fit: BoxFit.fill,
          image: AssetImage(icon),
        ),
        SizedBox(width: 6),
        Expanded(
          child: Container(
            width: 200,
            child: TextField(

              controller: controller,
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
                hintText: hintText,
              ),

            ),
          ),
        )
      ],
    ),
  );

}


Widget customTextFieldAction(String icon,String hintText,TextEditingController controller,Function action){
  return GestureDetector(
    child: Container(
      padding: EdgeInsets.only(left: 10),
      height: 52,
      decoration: BoxDecoration(
          border: Border.all(color:  CustomColors.gray.withOpacity(.3) ,width: 1.3),
          color: CustomColors.white

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            width: 35,
            height: 35,
            fit: BoxFit.fill,
            image: AssetImage(icon),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Container(
              width: 200,
              child: TextField(
                enabled: false,
                controller: controller,
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
                  hintText: hintText,
                ),

              ),
            ),
          ),
          Image(
            width: 35,
            height: 35,
            fit: BoxFit.fill,
            image: AssetImage("Assets/images/ic_arrow.png"),
          ),
        ],
      ),
    ),
    onTap: (){
      action();
    },
  );

}

Widget itemCountry(BuildContext context,int pos,Function select){
  return GestureDetector(
    child: Column(
      children: <Widget>[
        pos == 0 ? Container() : Container(height: 1,color:  CustomColors.grayBackground.withOpacity(.5),width: double.infinity,),
        Container(
          height: 70,
          width: double.infinity,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 30,

                  decoration:BoxDecoration(
                    color: CustomColors.grayBackground,
                    borderRadius: BorderRadius.all(Radius.circular(100))
                  ),
                  child: Image(
                    image: AssetImage(""),

                  ),
                ),
                SizedBox(width: 15),
                Text(
                  "Colombia",
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.blackLetter,
                    fontFamily: Strings.fontArialBold
                  ),
                )
              ],
            ),
          ),

        ),
        Container(height: 1,color: CustomColors.grayBackground.withOpacity(.5),width: double.infinity,),

      ],
    ),
    onTap: (){
      select();
    },
  );
}


Widget itemCity(BuildContext context,int pos,Function select){
  return GestureDetector(
    child: Column(
      children: <Widget>[
        pos == 0 ? Container() : Container(height: 1,color:  CustomColors.grayBackground.withOpacity(.5),width: double.infinity,),
        Container(
          height: 70,
          width: double.infinity,
          child: Center(
            child: Text(
              "Bogota",
              style: TextStyle(
                color: CustomColors.letterDarkBlue,
                fontFamily: Strings.fontArialBold,
                fontSize: 18
              ),
            )
          ),

        ),
        Container(height: 1,color: CustomColors.grayBackground.withOpacity(.5),width: double.infinity,),

      ],
    ),
    onTap: (){
      select();
    },
  );
}

Widget itemCategorie(){
  return Container(
    width: 50,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: CustomColors.blueActiveDots
          ),
          child: Image(
            image: AssetImage("Assets/images/"),
          ),
        ),
        SizedBox(height: 15),
        Text(
          "Tecnología",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: Strings.fontArial,
            fontSize: 12,
            color: CustomColors.blackLetter,
          ),
        )
      ],
    ),
  );

}


Widget itemProductFirstDestacado(){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      color:CustomColors.des1
    ),
    child: Stack(
      children: <Widget>[
        Padding(
            padding:EdgeInsets.only(left: 15,top: 15,right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Tecnología",
                style: TextStyle(
                  fontFamily: Strings.fontArialBold,
                  fontSize: 13,
                  color: CustomColors.blue
                ),
              ),
              Text(
                "AirPods Earphones",
                style: TextStyle(
                    fontFamily: Strings.fontArialBold,
                    fontSize: 19,
                    color: CustomColors.splashColor
                ),
              ),
              SizedBox(height: 7),
              Text(
                "Hoy:",
                style: TextStyle(
                    fontFamily: Strings.fontArial,
                    fontSize: 11,
                    color: CustomColors.letterGray
                ),
              ),
              SizedBox(height: 7),
              Text(
                r"$500.000",
                style: TextStyle(
                    fontFamily: Strings.fontArial,
                    fontSize: 16,
                    color: CustomColors.orange
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Image(
            width: 50,
            height: 50,
            image: AssetImage("Assets/images/ic_orange_arrow.png"),
          ),
        ),


        Positioned(
          bottom: 0,
          left: 0,
          child: Image(
            fit: BoxFit.fill,
            width: 125,
            height: 180,
            image: NetworkImage("https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),
          ),
        )
      ],
    ),

  );
}

Widget itemProductDestacado(){
  return Container(
      decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      color:CustomColors.des2
  ),
  child: Stack(
    children: <Widget>[
      Padding(
          padding: EdgeInsets.only(left: 8,top: 11,right: 18),
        child: Row(
          children: <Widget>[
            Image(

              image: NetworkImage("https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),
              width: 75,
              height: 100,
              fit: BoxFit.fill,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Tecnología",
                    style: TextStyle(
                      fontSize: 9,
                      fontFamily: Strings.fontArialBold,
                      color: CustomColors.letterGray
                    ),
                  ),
                  Text(
                    "Audifonos Stereo Bluetooth",
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: Strings.fontArialBold,
                        color: CustomColors.splashColor
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Image(
          width: 35,
          height: 35,
          image: AssetImage("Assets/images/ic_orange_arrow.png"),
        ),
      )
    ],
  )
  );
}


Widget itemProduct(bool border){
  return Container(
    margin: EdgeInsets.only(right: 10),
   // height: 300,
    width: 152,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
       border: Border.all(color: border ? CustomColors.gray.withOpacity(.3) : CustomColors.white ,width: 1.3),

  color: CustomColors.white
    ),
    child: Stack(
      children: <Widget>[
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              color: CustomColors.red.withOpacity(.8)
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "20%",
                    style: TextStyle(
                      fontFamily: Strings.fontArialBold,
                      fontSize: 8,
                      color: CustomColors.white
                    ),
                  ),
                  Text(
                    "DCT",
                    style: TextStyle(
                        fontFamily: Strings.fontArialBold,
                        fontSize: 4,
                        color: CustomColors.white
                    ),
                  ),
                ],
              ),
            ),

        ),
        Container(
         // color: CustomColors.green,
          width: double.infinity,
          margin: EdgeInsets.only(left: 15,right: 15,top: 10),
          child: Image(
            image: NetworkImage("https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),
            height: 81,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15,top: 100,right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  "Tenis Adidas Mujer Moda Vl Court 2.0",
                  style: TextStyle(
                      fontSize: 10,
                      fontFamily: Strings.fontArialBold,
                      color: CustomColors.blackLetter
                  ),
                ),
              ),
              Text(
                r"$109.990 COP",
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: Strings.fontArialBold,
                    color: CustomColors.orange
                ),
              ),
              SizedBox(height: 5),
              Text(

                r"$109.990 COP",
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 10,
                    fontFamily: Strings.fontArialBold,
                    color: CustomColors.letterGray
                ),

              ),
              SizedBox(height: 20),
            ],
          ),
        )
        //eSTRELLas


      ],
    ),
  );
}


Widget itemFirsOfertas(BuildContext context){
  return Container(
    width: double.infinity,
    child: Stack(
      children: <Widget>[

         Container(

            padding: EdgeInsets.only(right: 30),
            child: Center(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Ofertas del día",
                          style: TextStyle(

                              fontSize: 14,
                              fontFamily: Strings.fontArial,
                              color: CustomColors.orange
                          ),

                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Text(
                            "Altavoz inteligente para el hogar con el Asistente de Google ",
                            style: TextStyle(

                                fontSize: 16,
                                fontFamily: Strings.fontArialBold,
                                color: CustomColors.blackLetter
                            ),

                          ),
                        ),
                        SizedBox(height: 16,),
                        Text(
                          r"$129.000",
                          style: TextStyle(

                              fontSize: 16,
                              fontFamily: Strings.fontArialBold,
                              color: CustomColors.orange
                          ),

                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      //width: 400,
                      height: 200,

                      child: Image(
                        width: 500,
                        fit: BoxFit.fitHeight,
                        image: NetworkImage("https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),),
                    ),
                  )
                ],
              ),
            ),
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: Image(
            width: 35,
            height: 35,
            image: AssetImage("Assets/images/ic_orange_arrow.png"),
          ),
        ),

      ],
    ),
  );
}

Widget itemHelpCenter(String question,Function action){
 return GestureDetector(
   child: Container(
     margin: EdgeInsets.only(top: 19),
     padding: EdgeInsets.only(left: 24,right: 10),
     height: 58,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.all(Radius.circular(5)),
       border: Border.all(color: CustomColors.gray.withOpacity(.2) ,width: 1.5),


     ),
     child: Center(
       child: Container(

         child: Row(

           children: <Widget>[
             Expanded(
               child: Text(
                 question,
                 style: TextStyle(
                   fontFamily: Strings.fontArialBold,
                   fontSize: 15,
                   color: CustomColors.blackLetter
                 ),
               ),
             ),

               Container(

                 child: Image(
                   width: 30,
                   height: 30,
                   image: AssetImage("Assets/images/ic_arrow.png"),

               ),
             )
           ],
         ),
       ),
     ),
   ),
 );
}