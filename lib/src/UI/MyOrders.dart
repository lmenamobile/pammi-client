import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/UI/MenuLeft/DrawerMenu.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: DrawerMenuPage(rollOverActive: "myOrders",),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: _body(context),
      ),
      backgroundColor: CustomColors.whiteBackGround,
    );
  }

  Widget _body(BuildContext context){
    return Stack(
      children: <Widget>[
        headerMenu(context,Strings.myOrders,_drawerKey),
        Container(
            margin: EdgeInsets.only(right: 20,left: 20,top: 120),
            width: double.infinity,
            child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return itemOrderProgress();

                }
            )
        ),

      ],
    );
  }

  Widget itemOrderProgress(){
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: CustomColors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Orden #101",
                  style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 15,
                    color: CustomColors.blackLetter
                  ),
                ),
            Text(
              "1 producto",
              style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  fontSize: 12,
                  color: CustomColors.gray7
              ),
            ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(

                          child: Image(
                            width: 20,
                            height: 20,
                            image: AssetImage("Assets/images/ic_no_preparing.png"),
                          ),
                          color: CustomColors.red,
                        ),

                      ],
                    ),
                    Container(
                      height: 1,
                      width: 72,
                      color: CustomColors.green,
                    ),
                    Column(
                      children: <Widget>[
                        Image(
                          width: 20,
                          height: 20,
                          image: AssetImage("Assets/images/ic_preparing.png"),
                        ),
                        Text("Preparando 22",
                          style: TextStyle(
                              fontSize: 12,
                              color: CustomColors.blueGray,
                              fontFamily: Strings.fontRegular
                          ),)
                      ],
                    ),
                    Container(
                      height: 1,
                      width: 72,
                      color: CustomColors.gray7,
                    ),
                  ],
                ),
                SizedBox(height: 17),
                Container(
                  width: 89,
                  height: 26,
                  child: btnCustomSemiRounded(CustomColors.blueOne, CustomColors.white, "Ver detalle", (){}, context),
                )
              ],
            ),
          ),
        ],
      ),
      onTap: (){},
    );

  }
}
