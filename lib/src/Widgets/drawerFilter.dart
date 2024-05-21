import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/VariablesNotifyProvider.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class DrawerFilterPage extends StatefulWidget {
  @override
  _DrawerFilterPageState createState() => _DrawerFilterPageState();
}

class _DrawerFilterPageState extends State<DrawerFilterPage> {

  late VariablesNotifyProvider notifyVariables;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black54.withOpacity(.3),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: _body(context),
      ),
    );
  }



  Widget _body(BuildContext context){
    notifyVariables = Provider.of<VariablesNotifyProvider>(context);
    return   FadeInRight(
      child: Container(

        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                  width: 242,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(

                      color: CustomColors.white
                  ),
                  child: SingleChildScrollView(
                    child: !notifyVariables.showMarcaFilter ? FadeInRight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Padding(
                            padding: EdgeInsets.only(top: 40,left: 23,right: 23),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  Strings.filter,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: CustomColors.blueTitle,
                                    fontFamily: Strings.fontBold
                                  ),
                                ),
                                GestureDetector(
                                  child: Image(
                                    width: 13,
                                    height: 13,
                                    fit: BoxFit.fill,
                                    image: AssetImage("Assets/images/ic_close_red.png"),
                                  ),
                                  onTap: (){

                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 28),
                          Padding(
                            padding: EdgeInsets.only(left: 23,right: 23),
                            child: GestureDetector(
                              child: Container(
                                width: double.infinity,
                                height: 34,
                                padding: EdgeInsets.only(left: 23,right: 8),
                                decoration: BoxDecoration(
                                  color: CustomColors.grayBackground,
                                  borderRadius: BorderRadius.all(Radius.circular(6))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                     "Aca va algo",
                                      style: TextStyle(
                                        fontFamily: Strings.fontBold,
                                        fontSize: 11,
                                        color: CustomColors.blackLetter
                                      ),
                                    ),

                                    Image(
                                      image: AssetImage("Assets/images/ic_arrow.png"),
                                      width: 25,
                                      height: 25,
                                    ),

                                  ],
                                ),

                              ),
                              onTap: (){
                                notifyVariables.showMarcaFilter = true;
                              },
                            ),
                          ),
                          SizedBox(height: 28),
                          Padding(
                            padding: const EdgeInsets.only(left: 23),
                            child: Text(
                              Strings.price,
                              style: TextStyle(
                                fontSize: 12,
                                color: CustomColors.blackLetter,
                                fontFamily: Strings.fontBold
                              ),
                            ),

                          ),
                          SizedBox(height: 4),
                          Container(
                            margin: EdgeInsets.only(left: 23,right: 23),
                            width: double.infinity,
                            child: ListView.builder(
                              padding: EdgeInsets.only(top: 0,bottom: 8),
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                //return //itemCategorie();
                                return Text(
                                      r"$100.000 a $300.000",
                                      style: TextStyle(
                                        fontFamily: Strings.fontRegular,
                                        color: CustomColors.gray7,
                                        fontSize:10
                                      ),

                                );

                              },


                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 20),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 18,
                                  width: 43,
                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(3)),
                                    border: Border.all(color:CustomColors.blue ,width: 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      Strings.min,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: CustomColors.gray7,
                                        fontFamily: Strings.fontRegular
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "-",
                                  style: TextStyle(
                                    fontFamily: Strings.fontRegular,
                                    color: CustomColors.gray,
                                    fontSize: 14
                                  ),
                                ),
                                SizedBox(width: 6),
                                Container(
                                  height: 18,
                                  width: 43,
                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(3)),
                                    border: Border.all(color:CustomColors.blue ,width: 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      Strings.max,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: CustomColors.gray7,
                                          fontFamily: Strings.fontRegular
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 23,right: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text(
                                  Strings.type,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: Strings.fontBold,
                                    color: CustomColors.blackLetter,
                                  ),
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  child: Row(
                                    children: <Widget>[
                                     notifyVariables.addCurrent ? Image(
                                        image: AssetImage("Assets/images/ic_add_blue.png"),
                                        width: 20,
                                        height: 20,
                                      ) : Image(
                                            image: AssetImage("Assets/images/ic_square.png"),
                                            width: 20,
                                            height: 20,
                                          ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Agregados recientemente",
                                        style: TextStyle(
                                          fontFamily: Strings.fontRegular,
                                          fontSize: 12,
                                          color: CustomColors.gray7
                                        ),
                                      )
                                    ],
                                  ),
                                  onTap: (){
                                    notifyVariables.addCurrent == true ?  notifyVariables.addCurrent = false :  notifyVariables.addCurrent = true;

                                  },
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  child: Row(
                                    children: <Widget>[
                                      notifyVariables.moreSend ? Image(
                                        image: AssetImage("Assets/images/ic_add_blue.png"),
                                        width: 20,
                                        height: 20,
                                      ):Image(
                                        image: AssetImage("Assets/images/ic_square.png"),
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Más vendidos",
                                        style: TextStyle(
                                            fontFamily: Strings.fontRegular,
                                            fontSize: 12,
                                            color: CustomColors.gray7
                                        ),
                                      )
                                    ],
                                  ),
                                  onTap: (){
                                    notifyVariables.moreSend ? notifyVariables.moreSend = false : notifyVariables.moreSend = true;

                                  },
                                )


                              ],
                            ),
                          ),
                          SizedBox(height: 48),
                          Padding(padding: EdgeInsets.only(left: 43,right: 43),  child: btnCustomSemiRounded(CustomColors.blue, CustomColors.white, Strings.apply, (){}, context))
                        ],
                      ),
                    ) : FadeInRight(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40,left: 23,right: 23),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  child: Image(
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.fill,
                                    image: AssetImage("Assets/images/ic_blue_arrow.png"),
                                  ),
                                  onTap: (){
                                    notifyVariables.showMarcaFilter = false;
                                    
                                  },
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    Strings.filter,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: CustomColors.blueTitle,
                                        fontFamily: Strings.fontBold
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Image(
                                    width: 13,
                                    height: 13,
                                    fit: BoxFit.fill,
                                    image: AssetImage("Assets/images/ic_close_red.png"),
                                  ),
                                  onTap: (){

                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 40,top: 6),
                              child: Text(
                                "Aca va algo",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: Strings.fontRegular,
                                  color: CustomColors.blackLetter
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: ListView.builder(
                                padding: EdgeInsets.only(top: 5,left: 35,right: 20),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                itemCount: 5,
                                itemBuilder: (BuildContext context, int index) {
                                  return itemMarca("Acer");
                                },
                              ),
                            ),
                            SizedBox(height: 50),
                            Padding(
                              padding: const EdgeInsets.only(left: 25,right: 25),
                              child: btnCustomSemiRounded(CustomColors.blue,CustomColors.white, Strings.apply, (){}, context),
                            )



                          ],
                        ),
                      ),
                    ),
                  )
                ),

            ),

          /*  Container(
              width: 286,
              margin: EdgeInsets.only(left: 23,top: 68,right: 52),
              decoration: BoxDecoration(

                  color: CustomColors.white,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),topRight: Radius.circular(30))
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(width: double.infinity,height: 30,color: CustomColors.red,),
                    SizedBox(height: 20),
                    Container(width: double.infinity,height: 30,color: CustomColors.red,),
                    SizedBox(height: 20),
                    Container(width: double.infinity,height: 30,color: CustomColors.red,),
                    SizedBox(height: 20),
                    Container(width: double.infinity,height: 30,color: CustomColors.red,),
                    SizedBox(height: 20),
                    Container(width: double.infinity,height: 30,color: CustomColors.red,),
                    SizedBox(height: 20),
                    Container(width: double.infinity,height: 30,color: CustomColors.red,),
                    SizedBox(height: 20),
                    Container(width: double.infinity,height: 30,color: CustomColors.red,),
                    SizedBox(height: 20),
                    Container(width: double.infinity,height: 30,color: CustomColors.red,)


                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),

    );

  }

  Widget itemMarca(String nameMarca){
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.only(top: 15),
          child: Row(
          children: <Widget>[
          notifyVariables.moreSend ? Image(
          image: AssetImage("Assets/images/ic_add_blue.png"),
    width: 20,
    height: 20,
    ):Image(
    image: AssetImage("Assets/images/ic_square.png"),
    width: 20,
    height: 20,
    ),
    SizedBox(width: 8),
    Text(
      nameMarca,
    style: TextStyle(
    fontFamily: Strings.fontRegular,
    fontSize: 14,
    color: CustomColors.gray7
    ),
    )
    ],
    ),
        )
    );
  }

}
