import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class ProductsCampaignsPage extends StatefulWidget {
  @override
  _ProductsCampaignsPageState createState() => _ProductsCampaignsPageState();
}

class _ProductsCampaignsPageState extends State<ProductsCampaignsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteBackGround,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: _body(context),
      ),
    );
  }
  Widget _body(BuildContext context){
    return Stack(
      children: <Widget>[

        Container(
          height: 90,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
              color: CustomColors.white
          ),
          child: Stack(
            children: <Widget>[

              Positioned(
                left: 20,
                top:35,
                child: GestureDetector(
                  child: Image(
                    width: 30,
                    height: 30,
                    image: AssetImage("Assets/images/ic_blue_arrow.png"),

                  ),
                  onTap: (){Navigator.pop(context);},
                ),
              ),

              Center(
                child: Container(
                  //alignment: Alignment.center,
                 margin: EdgeInsets.only(top: 15),
                  child: Text(
                    Strings.campaigns,
                    textAlign: TextAlign.center,
                    style: TextStyle(

                        fontSize: 15,
                        fontFamily: Strings.fontArialBold,
                        color: CustomColors.blackLetter
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),


                Padding(
                  padding: EdgeInsets.only(left: 17,right: 20,top: 100),
                  child: Text(
                    "Titulo campaña",
                    style: TextStyle(
                        fontSize: 18,
                        color: CustomColors.blackLetter,
                        fontFamily: Strings.fontArialBold
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(


                  margin: EdgeInsets.only(left: 12,right: 12,top: 120),
                  padding: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: StaggeredGridView.countBuilder(

                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 0),
                    scrollDirection: Axis.vertical,

                    crossAxisCount: 2,


                    itemCount: 20,

                    itemBuilder: (BuildContext context, int index) =>itemDestacado(context),
                    staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(1,1.2),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 11,
                  ),
                ),



      ],
    );

  }
}
