import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/drawerMenu.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class DayOferstPage extends StatefulWidget {
  @override
  _DayOferstPageState createState() => _DayOferstPageState();
}

class _DayOferstPageState extends State<DayOferstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.grayBackground,
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
      pageBuilder: (_, __, ___) => DraweMenuPage(rollOverActive: "ofertsDay",)
      ));
      },
      ),
      Expanded(
      child: Center(
      child: Text(
      "Ofertas del día",
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
             Container(
                margin: EdgeInsets.only(left: 24,right:14),
                //height: 400,
                width: double.infinity,
                child: StaggeredGridView.countBuilder(

                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 0),
                  shrinkWrap: true,
                  crossAxisCount: 2,


                  itemCount: 20,

                  itemBuilder: (BuildContext context, int index) =>
                      itemProduct(false),
                  staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count( 1, index == 0 ? 1.2:1.2),
                  mainAxisSpacing: 28,
                  crossAxisSpacing: 8,
                ),

            ),
            SizedBox(height: 20)
      ]
      ),
    );
  }
}
