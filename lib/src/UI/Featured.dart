import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tabbar/tabbar.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/UI/MenuLeft/DrawerMenu.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class FeaturedPage extends StatefulWidget {
  @override
  _FeaturedPageState createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage> {

  final controller = PageController();
  var enableFeature = true;


  @override
  void initState() {
   controller.addListener(() {
      //_listener();
    });
    // TODO: implement initState
    super.initState();
  }


  _listener() {

    if (controller.position.userScrollDirection == ScrollDirection.reverse) {
      this.enableFeature = false;
      setState(() {

      });
      print('swiped to right');
    } else {
      this.enableFeature = true;
      setState(() {

      });
      print('swiped to left');
    }
  }

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
                                  pageBuilder: (_, __, ___) => DrawerMenuPage(rollOverActive: "featured",)
                              ));
                        },
                      ),
                      Expanded(
                          child: Center(
                            child: Text(
                              "Destacados",
                              style: TextStyle(
                                  fontFamily: Strings.fontBold,
                                  fontSize: 16,
                                  color: CustomColors.blackLetter

                              ),
                            ),
                          )
                      ),

                    ],
                  ),


                  //SizedBox(height: 20),

                  Container(
                      width: double.infinity,


                      child:Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: TabbarHeader(
                          indicatorColor: CustomColors.blueActiveDots,
                          foregroundColor: CustomColors.red,
                          controller: controller,
                          backgroundColor: CustomColors.white,
                          tabs: [


                            Tab(child: Text(
                              "Destacados",
                              style: TextStyle(
                                color:this.enableFeature ? CustomColors.blackLetter: CustomColors.blackLetter.withOpacity(.3),
                                fontSize: 14,
                                fontFamily: Strings.fontBold,

                              ),

                            )

                            ),

                            Tab(child: Text(
                              "Campañas",

                              style: TextStyle(
                                color:this.enableFeature ? CustomColors.blackLetter: CustomColors.blackLetter.withOpacity(.3),
                                fontSize: 14,
                                fontFamily: Strings.fontBold,

                              ),

                            )),

                          ],
                        ),
                      )
                  ),



                ],
              ),
            ),
          ),
          SizedBox(height: 0,),

          Container(
              width: double.infinity,
              child: TabbarContent(

              controller: controller,

              children: <Widget>[

                Container(


                  margin: EdgeInsets.only(left: 12,right: 12),
                  padding: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: StaggeredGridView.countBuilder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 0),
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
                      itemCount: 20,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) =>null,
                      staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(1,1.2),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 11,
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 20,right: 20),
                  width: double.infinity,

                  child:  SingleChildScrollView(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics:NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {

                        return itemBannerCampaign(context);

                      },


                    ),
                  ),
                )


              ],
            ),
          )
    ]
    )
    );



  }




}
