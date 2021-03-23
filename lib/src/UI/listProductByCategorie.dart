import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/drawerFilter.dart';

class ListProductByCategories extends StatefulWidget {
  @override
  _ListProductByCategoriesState createState() => _ListProductByCategoriesState();
}

class _ListProductByCategoriesState extends State<ListProductByCategories> {

  final searchController = TextEditingController();
  NotifyVariablesBloc notifyVariables;
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

    return  Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: headerProducts(),
        ),
        Positioned(
          top: 160,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            

            margin: EdgeInsets.only(left: 12,right: 12),
            padding: EdgeInsets.only(top: 20),
            width: double.infinity,
            child: StaggeredGridView.countBuilder(

              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 0),
              scrollDirection: Axis.vertical,

              crossAxisCount: 2,


              itemCount: 20,

              itemBuilder: (BuildContext context, int index) =>itemProduct(context),
              staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(1,1.3),
              mainAxisSpacing: 8,
              crossAxisSpacing: 11,
            ),
          ),
        )

      ],
    );

  }


  Widget headerProducts(){
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25)),
          color: CustomColors.white
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 37,left: 28,right: 28),
        child: Container(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Image(
                      image: AssetImage("Assets/images/ic_blue_arrow.png"),
                      fit: BoxFit.fill,
                      width: 30,
                      height: 30,
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                  Image(
                    width: 110,
                    height: 35,
                    image: AssetImage("Assets/images/ic_logo_black.png"),
                    fit: BoxFit.fill,

                  ),
                  GestureDetector(
                    child: Image(
                      width: 30,
                      height: 30,
                      image: AssetImage("Assets/images/ic_shopping_blue-1.png"),
                    ),
                  )
                ],
              ),
              SizedBox(height: 25),

                 Row(


                  children: <Widget>[
                    Expanded(child: boxSearch(context)),
                    SizedBox(width: 14),
                    GestureDetector(
                      child: Container(
                          width: 45,
                          height: 45,
                        child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage("Assets/images/ic_edit.png"),
                        )
                      ),
                      onTap: (){
                        notifyVariables.showMarcaFilter = false;

                        Navigator.of(context).push(
                            PageRouteBuilder(
                                opaque: false, // set to false
                                pageBuilder: (_, __, ___) => DrawerFilterPage()
                            ));
                      },
                    )

                  ],
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget boxSearch(BuildContext context){
    return Container(
                height: 40,

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
  Widget itemProduct(BuildContext context){
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: CustomColors.white
        ),
        width: 162,
        child: Stack(
          children: <Widget>[
            Container(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 18),
                  Image(
                    fit:BoxFit.fill,
                    image:NetworkImage("https://assets.stickpng.com/images/580b57fbd9996e24bc43bfbb.png"),
                    width: 95,
                    height: 95,
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 1,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 13,right: 13),
                    color: CustomColors.grayBackground.withOpacity(.7),

                  ),
                  SizedBox(height: 8),

                  Padding(
                    padding:EdgeInsets.only(left: 12,right: 52),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "LENOVO",
                          style: TextStyle(
                              fontFamily: Strings.fontArial,
                              fontSize: 10,
                              color: CustomColors.grayLetter
                          ),

                        ),
                        Text(
                          "Portátil ideapad s145-14api amd r3",
                          style: TextStyle(
                              fontFamily: Strings.fontArialBold,
                              fontSize: 13,
                              color: CustomColors.blackLetter
                          ),

                        ),
                        Text(
                          r"$ 1.899.900 COP",
                          style: TextStyle(
                              fontFamily: Strings.fontArialBold,
                              fontSize: 15,
                              color: CustomColors.orange
                          ),

                        ),
                        SizedBox(height: 7)
                      ],
                    ),
                  )


                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                child: Image(
                  width: 30,
                  height: 30,
                  image: AssetImage("Assets/images/ic_no_like.png"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}
/*SizedBox(width: 20),
          Container(
            width: 36,
            height: 40,
            child: Image(

              fit: BoxFit.fill,
              image: AssetImage("Assets/images/ic_edit.png"),
            ),
          ) */