import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/drawerMenu.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final searchController = TextEditingController();
  var position = 0;

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Container(
       width: double.infinity,
       height: MediaQuery.of(context).size.height,
       color: CustomColors.grayBackground,
       child: _body(context),
     ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _body(BuildContext context){
    return WillPopScope(
      onWillPop: () async => false,
      child: SingleChildScrollView(
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
                                      pageBuilder: (_, __, ___) => DraweMenuPage(rollOverActive: "start",)
                                  ));
                            },
                          ),
                        Expanded(
                          child: Image(
                            width: 120,
                            height: 35,
                            image: AssetImage("Assets/images/ic_logo_black.png"),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            width: 31,
                            height: 31,
                            child:Image(
                              image: AssetImage("Assets/images/ic_shopping_blue-1.png"),
                            ),
                          ),
                          onTap: (){
                            print("Shop car");
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 23.5),
                    Padding(
                      padding: const EdgeInsets.only(left: 16,right: 16),
                      child: boxSearch(context),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.only(top: 23,left: 17,right: 17),
             // height: 300,
              width: double.infinity,
              color: CustomColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                   child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: <Widget>[
                        Text(
                          Strings.ourCategories,
                          style: TextStyle(
                            color: CustomColors.letterDarkBlue,
                            fontSize: 16,
                            fontFamily: Strings.fontArialBold
                          ),
                        ),

                        Expanded(
                          child: Text(

                            Strings.moreAll,
                            textAlign:TextAlign.end,
                            style: TextStyle(
                                color: CustomColors.orange,
                                fontSize: 16,
                                fontFamily: Strings.fontArialBold
                            ),
                          ),
                        ),
                      ],
                    ),

                  ),
                  Container(
                    padding: EdgeInsets.only(top: 18,left: 10,right: 10),
                      //margin: EdgeInsets.only(left: 7),
                      height: 270,
                      child:GridView.count(
                            physics:  new NeverScrollableScrollPhysics(),

                            childAspectRatio: 1.1,
                            scrollDirection:Axis.horizontal,
                            crossAxisSpacing: 14,
                            crossAxisCount: 2,
                            // Generate 100 widgets that display their index in the List.
                            children: List.generate(6, (index) {
                              return Center(
                                child: itemCategorie()
                              );
                            }),
                          )
                  ),
                 // SizedBox(height: 5),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: CustomColors.grayBackground,
                  ),
                  SizedBox(height: 20),
                  Text(
                    Strings.aprovecha,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: Strings.fontArialBold,
                      color: CustomColors.blue
                    ),
                  ),
                  Text(
                    Strings.detacados,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: Strings.fontArialBold,
                        color: CustomColors.splashColor
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    //height: 400,
                    width: double.infinity,
                    child: StaggeredGridView.countBuilder(

                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 0),
                      shrinkWrap: true,
                      crossAxisCount: 2,


                      itemCount: 3,

                      itemBuilder: (BuildContext context, int index) =>
                      index == 0 ? itemProductFirstDestacado(): itemProductDestacado(),
                      staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(1, index == 0 ? 2:1),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 8,
                    ),
                  ),
                  SizedBox(height: 20),

                ],
              ),
            ),
            SizedBox(height: 21),
            Container(
              margin: EdgeInsets.only(left: 21),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Strings.top,
                    style: TextStyle(
                      fontFamily: Strings.fontArialBold,
                      fontSize: 12,
                      color: CustomColors.blue
                    ),
                  ),
                  Text(
                    Strings.vendidos,
                    style: TextStyle(
                        fontFamily: Strings.fontArialBold,
                        fontSize: 16,
                        color: CustomColors.splashColor
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 23),
            Container(
              margin: EdgeInsets.only(left: 23),
              width: double.infinity,
              height:190,
              child: ListView.builder(
                //padding: EdgeInsets.only(left: 25),
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return itemProduct(false);
                },
              ),
            ),
            SizedBox(height: 22),
            Container(
              width: double.infinity,
              color: CustomColors.white,
              padding: EdgeInsets.only(top: 11,left: 21,right: 21),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Strings.findHere,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: Strings.fontArialBold,
                          color: CustomColors.blue,

                        ),
                      ),
                      Text(
                        Strings.ofertas,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: Strings.fontArialBold,
                          color: CustomColors.splashColor,

                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 23),
                  Container(
                    //height: 400,
                    width: double.infinity,
                    child: StaggeredGridView.countBuilder(

                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 0),
                      shrinkWrap: true,
                      crossAxisCount: 2,


                      itemCount: 3,

                      itemBuilder: (BuildContext context, int index) =>
                      index == 0 ? itemFirsOfertas(context) : itemProduct(true),
                      staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(index == 0 ? 3 : 1, index == 0 ? 1.2:1.1),
                      mainAxisSpacing: 34,
                      crossAxisSpacing: 8,
                    ),
                  ),
                  SizedBox(height: 23),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


  Widget boxSearch(BuildContext context){
    return Container(
      height: 47,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: CustomColors.grayBackground
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Image(
                width: 20,
                height: 20,
                image: AssetImage("Assets/images/ic_seeker.png"),
              ),
            ),
            Expanded(
              child: TextField(
                controller: searchController,
                style: TextStyle(
                    fontFamily: Strings.fontArial,
                    fontSize: 15,
                    color: CustomColors.blackLetter
                ),
                decoration: InputDecoration(
                    hintText: "Buscar",
                    isDense: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontFamily: Strings.fontArial,
                        fontSize: 15,
                        color: CustomColors.grayLetter
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );

  }


}