import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class DetailProductPage extends StatefulWidget {
  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteBackGround,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext cotext){
    return Stack(children: <Widget>[
      Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                  height: 74,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                      color: CustomColors.white
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 20,
                        top:20,
                        child: GestureDetector(
                          child: Image(
                            width: 30,
                            height: 30,
                            image: AssetImage("Assets/images/ic_blue_arrow.png"),

                          ),
                          onTap: (){Navigator.pop(context);},
                        ),
                      ),

                      Positioned(
                        right: 25,
                        top:20,
                        child: GestureDetector(
                          child: Image(
                            width: 30,
                            height: 30,
                            image: AssetImage("Assets/images/ic_shopping_blue-1.png"),

                          ),
                          onTap: (){

                          },
                        ),
                      ),

                      Center(
                        child: Container(
                          //alignment: Alignment.center,

                          child: Text(
                           "Audifonos auteco",
                            textAlign: TextAlign.center,
                            style: TextStyle(

                                fontSize: 15,
                                fontFamily: Strings.fontBold,
                                color: CustomColors.blackLetter
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),

      Container(
        margin: EdgeInsets.only(top: 110),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                 Container(
                   width: double.infinity,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.all(Radius.circular(15)),
                     color: CustomColors.white
                   ),
                   child: Stack(
                     children: <Widget>[
                       Container(
                         width: double.infinity,
                         margin: EdgeInsets.only(top: 30,bottom: 30,right: 71,left: 71),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Image(
                               width: 162,
                               height: 162,
                               fit: BoxFit.fill,
                               image: NetworkImage("https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),
                             ),

                             Container(
                               alignment: Alignment.center,

                               width: double.infinity,
                               height: 45,
                               child: ListView.builder(
                                   scrollDirection: Axis.horizontal,
                                   padding: EdgeInsets.only(top: 0),
                                   shrinkWrap: true,
                                   physics: NeverScrollableScrollPhysics(),
                                   itemCount: 4,
                                   itemBuilder: (BuildContext context, int index) {
                                     return  Container(

                                       margin: EdgeInsets.only(right: 10),
                                       width:45,
                                       height: 45,
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.all(Radius.circular(10)),
                                         border: Border.all(color:index == 0 ? CustomColors.orange :  CustomColors.gray.withOpacity(.2) ,width: 1),

                                       ),
                                       child: Center(
                                         child: Image(
                                           width: 36,
                                           height: 36,
                                           fit: BoxFit.fill,
                                           image: NetworkImage("https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),
                                         ),
                                       ),
                                     );

                                   }
                               ),
                             )

                           ],
                         ),

                       )
                     ],

                   ),
                 ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 23,right: 23),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Adata",
                          style: TextStyle(
                              fontFamily: Strings.fontBold,
                              fontSize: 15,
                              color: CustomColors.gray7
                          ),
                        ),
                        Text(
                          "Micro SD 64GB UHS-I",
                          style: TextStyle(
                              fontFamily: Strings.fontBold,
                              fontSize: 20,
                              color: CustomColors.blackLetter
                          ),
                        ),
                        Text(
                          "Ref.:12345",
                          style: TextStyle(
                              fontFamily: Strings.fontRegular,
                              fontSize: 12,
                              color: CustomColors.gray7
                          ),
                        ),
                        Text(
                          r"$ 60.990 COP",
                          style: TextStyle(
                              fontFamily: Strings.fontBold,
                              fontSize: 22,
                              color: CustomColors.orange
                          ),
                        ),
                        //
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 18,left: 12.5,right: 12.5),
                    color: CustomColors.gray.withOpacity(.1),
                    width: double.infinity,
                    height: 1,

                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 23,right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 18.5,),
                          Row(
                            children: <Widget>[
                              Image(
                              width: 30,
                              height: 30,
                              fit: BoxFit.fill,
                              image: AssetImage("Assets/images/ic_sent.png")
                              ),
                              Text(
                                "Entrega a domicilio",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: Strings.fontRegular,
                                  color: CustomColors.blackLetter
                                ),
                              )
                            ],
                          ),
                        SizedBox(height: 15),
                        Row(
                          children: <Widget>[
                            Text(
                              "Procesador: ",
                              style: TextStyle(
                                fontFamily: Strings.fontBold,
                                fontSize: 15,
                                color: CustomColors.blackLetter
                              ),
                            ),
                            Text(
                              "AMD RYZEN",
                              style: TextStyle(
                                  fontFamily: Strings.fontRegular,
                                  fontSize: 15,
                                  color: CustomColors.blackLetter
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 11),
                        Row(
                          children: <Widget>[
                            Text(
                              "Memoria RAM: ",
                              style: TextStyle(
                                  fontFamily: Strings.fontBold,
                                  fontSize: 15,
                                  color: CustomColors.blackLetter
                              ),
                            ),
                            Text(
                              "8GB",
                              style: TextStyle(
                                  fontFamily: Strings.fontRegular,
                                  fontSize: 15,
                                  color: CustomColors.blackLetter
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 11),
                        Row(
                          children: <Widget>[
                            Text(
                              "Tamaño de la pantalla:",
                              style: TextStyle(
                                  fontFamily: Strings.fontBold,
                                  fontSize: 15,
                                  color: CustomColors.blackLetter
                              ),
                            ),
                            Text(
                              "15.6 pulgadas",
                              style: TextStyle(
                                  fontFamily: Strings.fontRegular,
                                  fontSize: 15,
                                  color: CustomColors.blackLetter
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 18),
                        itemInfoProduct(),
                        SizedBox(height: 11),
                        itemHelpCenter(),
                        SizedBox(height: 14.2),
                        viewBuyProduct()
                        //
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
      ),





    ],
    );
  }




  Widget itemInfoProduct(){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 24,right: 30),
        width: double.infinity,
        height: 41.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: CustomColors.blueOne.withOpacity(.1)
        ),
        child: Center(
          child: Row(
            children: <Widget>[
              Image(
                width: 30,
                height: 30,
                fit: BoxFit.fill,
                image: AssetImage("Assets/images/ic_inf.png"),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  Strings.infoProd,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blueOne
                   ),
                ),
              ),

              Image(
                width: 14,
                height: 14,
                fit: BoxFit.fill,
                image: AssetImage("Assets/images/ic_arrow_blue.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemHelpCenter(){
    return Container(

      padding: EdgeInsets.only(left: 24,right: 60),
      height: 74.5,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: CustomColors.white
      ),
      child: Center(
        child: Row(
         crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("Assets/images/ic_activate.png"),
              width: 30,
              height: 30,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Strings.needHelp,
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 11,
                    color: CustomColors.gray7
                  )
                  ,
                ),
                Text(
                  "Contáctate al 031 567 8790",
                  style: TextStyle(
                      fontFamily: Strings.fontBold,
                      fontSize: 13,
                      color: CustomColors.blackLetter
                  ),

                )
              ],
            )
          ],
        ),
      ),
    );
  }


  Widget viewBuyProduct(){
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular((10))),
          color: CustomColors.white
        ),

        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 96,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SpringButton(
                        SpringButtonType.OnlyScale,
                        Image(
                          width: 30,
                          height: 30,
                          fit: BoxFit.fill,
                          image: AssetImage("Assets/images/ic_negative.png"),
                        ),
                        onTapUp: (_){},

                      ),
                      Text(
                        "0",
                        style: TextStyle(
                            fontFamily: Strings.fontBold,
                            fontSize: 20,
                            color: CustomColors.blackLetter
                        ),
                      ),

                      SpringButton(
                        SpringButtonType.OnlyScale,
                        Image(
                          width: 30,
                          height:30,
                          fit: BoxFit.fill,
                          image: AssetImage("Assets/images/ic_add.png"),
                        ),
                        onTapUp: (_){},
                      ),
                    ],
                  ),
                ),
                Text(
                  r"Total: $ 109.990",
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.blackLetter,
                    fontFamily: Strings.fontBold
                  ),
                ),

              ],
            ),
            SizedBox(height: 24.5,),
            Padding(
              padding: EdgeInsets.only(left: 45,right: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buttonGoToCar(),
                  SizedBox(height: 18),
                  btnCustomRounded(CustomColors.orange, CustomColors.white, Strings.payNow, (){}, context),
                  SizedBox(height: 24.5),
                  GestureDetector(
                    child: Text(
                      Strings.gonnaBuy,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: Strings.fontRegular,
                        color: CustomColors.blueOne,
                        decoration: TextDecoration.underline
                      ),
                    ),
                  onTap: (){},
                  )
                ],
              ),
            )
          ],
        ),
      );
  }

  Widget buttonGoToCar(){
    return SpringButton(
      SpringButtonType.OnlyScale,
      Container(
        padding: EdgeInsets.only(left: 27),
        height: 44,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          color: CustomColors.blueOne
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 10,
              bottom: 8,
              child: Image(
                width: 25,
                height: 25,
                fit: BoxFit.fill,
                image: AssetImage("Assets/images/ic_shopping_white.png"),
              ),
            ),
            Center(
              child: Text(
                "Ir al carrito",
                style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  fontSize: 14,
                  color: CustomColors.white,

                ),
              ),
            )
          ],
      ),
      ),
        onTapUp: (_){},
    );
  }


}
