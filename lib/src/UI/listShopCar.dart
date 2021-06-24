import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class ShopCarPage extends StatefulWidget {
  @override
  _ShopCarPageState createState() => _ShopCarPageState();
}

class _ShopCarPageState extends State<ShopCarPage> {
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

  Widget _body(BuildContext context){
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
               child: Column(
                  mainAxisSize: MainAxisSize.max,

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
                                image: AssetImage("Assets/images/ic_trash.png"),

                              ),
                              onTap: (){},
                            ),
                          ),

                          Center(
                            child: Container(
                              //alignment: Alignment.center,

                              child: Text(
                                Strings.shopCar,
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
                    Container(
                        margin: EdgeInsets.only(right: 20,left: 20),
                        width: double.infinity,
                        child: ListView.builder(
                            padding: EdgeInsets.only(top: 0),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 10,
                            itemBuilder: (BuildContext context, int index) {
                              return null;

                            }
                        )
                    ),
                    SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Strings.suggest,
                            style: TextStyle(
                              fontSize:15,
                              color: CustomColors.blackLetter,
                              fontFamily:  Strings.fontBold

                            ),
                          ),
                          SizedBox(height: 15),
                          Container(

                            width: double.infinity,
                            height:190,
                            child: ListView.builder(
                              //padding: EdgeInsets.only(left: 25),
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemCount: 5,
                              itemBuilder: (BuildContext context, int index) {
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    )


                  ],
                ),
              ),

        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: itemInfoShopCar(),
        ),
      ],
    );
  }
}
