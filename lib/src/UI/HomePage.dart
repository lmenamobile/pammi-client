import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wawamko/src/Models/Product/CategoryModel.dart';
import 'package:wawamko/src/Providers/ProductsProvider.dart';
import 'package:wawamko/src/UI/allCategories.dart';
import 'package:wawamko/src/UI/listShopCar.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/UI/MenuLeft/DrawerMenu.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import 'coupons.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final searchController = TextEditingController();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  var position = 0;
  List<Category> categories = List();
  bool hasInternet = true;

  @override
  void initState() {
    serviceGetCategories("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     key: _drawerKey,
     drawer: DrawerMenuPage(rollOverActive: "start",),

     body: Container(
       width: double.infinity,
       height: MediaQuery.of(context).size.height,
       color: CustomColors.grayBackground,
       child:  _body(context)

     ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Widget _body(BuildContext context){
    return Stack(
      children: <Widget>[

      hasInternet ?  Positioned(
          top: 130,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[

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
                                  fontFamily: Strings.fontBold
                                ),
                              ),

                              Expanded(
                                child: GestureDetector(
                                  child: Text(

                                    Strings.moreAll,
                                    textAlign:TextAlign.end,
                                    style: TextStyle(
                                        color: CustomColors.orange,
                                        fontSize: 16,
                                        fontFamily: Strings.fontBold
                                    ),
                                  ),
                                  onTap: (){Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:AllCategoriesPage(), duration: Duration(milliseconds: 700)));},
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
                                  children: List.generate(categories.length ?? 0, (index) {
                                    return Center(
                                      child: itemCategorie(this.categories[index])
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
                            fontFamily: Strings.fontBold,
                            color: CustomColors.blue
                          ),
                        ),
                        Text(
                          Strings.detacados,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: Strings.fontBold,
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
                            fontFamily: Strings.fontBold,
                            fontSize: 12,
                            color: CustomColors.blue
                          ),
                        ),
                        Text(
                          Strings.vendidos,
                          style: TextStyle(
                              fontFamily: Strings.fontBold,
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
                        return itemProduct(false,context);
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
                                fontFamily: Strings.fontBold,
                                color: CustomColors.blue,

                              ),
                            ),
                            Text(
                              Strings.ofertas,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: Strings.fontBold,
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
                            index == 0 ? itemFirsOfertas(context) : itemProduct(true,context),
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
        ) : Container(alignment: Alignment.center, color: CustomColors.white, child: notifyInternet("Assets/images/ic_img_internet.png", Strings.titleAmSorry, Strings.loseInternet,context,(){
        serviceGetCategories("");})),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(left: 21,right: 21),
            width: double.infinity,
            //height: 139,
            decoration: BoxDecoration(
              color: CustomColors.redTour,
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
                              color: CustomColors.redTour
                          ),
                          child: Center(
                            child: Image(
                              image: AssetImage("Assets/images/ic_menu.png"),
                            ),
                          ),
                        ),
                        onTap: (){
                          _drawerKey.currentState.openDrawer();
                        },
                      ),
                      Expanded(
                        child: Image(
                          width: 120,
                          height: 30,
                          image: AssetImage("Assets/images/ic_logo_email.png"),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          width: 31,
                          height: 31,
                          child:Image(
                            image: AssetImage("Assets/images/ic_car.png"),
                          ),
                        ),
                        onTap: (){
                          Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:ShopCarPage(), duration: Duration(milliseconds: 700)));
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
        ),
      ],
    );

  }


  Widget boxSearch(BuildContext context){
    return Container(
      height: 47,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: CustomColors.graySearch
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
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: CustomColors.blackLetter
                ),
                decoration: InputDecoration(
                    hintText: "Buscar",
                    isDense: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 16,
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

  serviceGetCategories(String filter) async {
    this.categories = [];
    utils.checkInternet().then((value) async {
      if (value) {
        hasInternet = true;
        utils.startProgress(context);


        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => DialogLoadingAnimated()));
        Future callResponse = ProductsProvider.instance.getCategories(context,filter,0);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          CategoriesResponse data = CategoriesResponse.fromJson(decodeJSON);

          if(data.status) {

            var contCat = 0;
            for(var category in data.data.categories ){
              if(contCat <=6){
                this.categories.add(category);
                contCat +=1;
              }

            }
            setState(() {

            });
            Navigator.pop(context);
          }else{
            Navigator.pop(context);
            setState(() {

            });
            // utils.showSnackBarError(context,data.message);
          }

          //loading = false;
        }, onError: (error) {
          print("Ocurrio un error: ${error}");
          //loading = false;
          Navigator.pop(context);
        });
      }else{
        hasInternet = false;
        setState(() {

        });
        // loading = false;
        //utils.showSnackBarError(context,Strings.loseInternet);
      }
    });
  }


}