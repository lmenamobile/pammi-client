import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wawamko/src/Models/Product/CategoryModel.dart';
import 'package:wawamko/src/Providers/ProductsProvider.dart';
import 'package:wawamko/src/UI/productsByCategorie.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class AllCategoriesPage extends StatefulWidget {
  @override
  _AllCategoriesPageState createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {

  final searchController = TextEditingController();
  bool bandLoadingText = false;
  List<Category> categories = List();
  bool hasInternet = true;


  @override
  void initState() {
    serviceGetCategories("",true);
    super.initState();
  }

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
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: headerCategories(),
        ),
        Positioned(
          top: 170,
          left: 0,
          right: 0,
          bottom: 0,
          child:  hasInternet ? Container(

            width: double.infinity,

            child:  ListView.builder(
                padding: EdgeInsets.only(top: 0,bottom: 20),
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: this.categories.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                 //return //itemCategorie();
                  return itemCategory(this.categories[index]);

                },


            ),
          ) : Center(child: Container( width: double.infinity,height: MediaQuery.of(context).size.height - 90, child: notifyInternet("Assets/images/ic_img_internet.png", Strings.titleAmSorry, Strings.loseInternet,context,(){
            serviceGetCategories("",true);})))
        )

      ],
    );
  }
  Widget headerCategories(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25)),
        color: CustomColors.redTour
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
                      image: AssetImage("Assets/images/ic_back_w.png"),
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
                      image: AssetImage("Assets/images/ic_logo_email.png"),
                      fit: BoxFit.contain,

                  ),
                  GestureDetector(
                    child: Image(
                      width: 30,
                      height: 30,
                      image: AssetImage("Assets/images/ic_car.png"),
                    ),
                  )
                ],
              ),
              SizedBox(height: 25),
              boxSearch(context),
              SizedBox(height: 20),
            ],
          ),
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
                        fontSize: 15,
                        color: CustomColors.grayLetter
                    )
                ),
                cursorColor: CustomColors.blueSplash,
                onChanged: (value){
                  serviceGetCategories(value,false);
                },
              ),
            ),
            this.bandLoadingText ? Container(
              margin: EdgeInsets.only(right: 15),
              height: 30,
              width: 30,
              child:  SpinKitThreeBounce(
                color: CustomColors.red,
                size: 20.0,
              ),
            ):Container()
          ],
        ),
      ),
    );

  }
  Widget itemCategory(Category category){
    return GestureDetector(
      child: Container(
        height: 63,
        padding: EdgeInsets.only(left: 10,right: 10),
        width: double.infinity,
        margin: EdgeInsets.only(top: 20,left: 20,right: 20),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.all(Radius.circular(9)),
          border: Border.all(color: CustomColors.gray.withOpacity(.3),width: 1),
        ),
        child: Center(
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: <Widget>[
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: HexColor(category.color),
                  shape: BoxShape.circle
                ),
                child: FadeInImage(
                  image: NetworkImage(category.image),
                  placeholder: AssetImage(""),
                  width: 55,
                  height: 55,
                ),
              ),
             SizedBox(width: 10),
             Expanded(
               child: Text(
                 category.category,
                 style: TextStyle(
                   fontFamily: Strings.fontRegular,
                   fontSize: 14,
                   color: CustomColors.blackLetter
                 ),
               ),
             ),
             Image(
               width: 30,
               height: 30,
               image: AssetImage("Assets/images/ic_arrow.png"),
             )
           ],
          ),
        ),
      ),
      onTap: (){
        Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:ProductsByCategoryPage(category: category,), duration: Duration(milliseconds: 700)));
      },
    );
  }

  serviceGetCategories(String filter,bool hasLoading) async {
    this.categories = [];
    utils.checkInternet().then((value) async {
      if (value) {
        hasInternet = true;
        if(hasLoading){
          utils.startProgress(context);
        }else{
          bandLoadingText = true;
        }



        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => DialogLoadingAnimated()));
        Future callResponse = ProductsProvider.instance.getCategories(context,filter,0);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          CategoriesResponse data = CategoriesResponse.fromJson(decodeJSON);

          if(data.status) {

            this.categories = [];
            for(var category in data.data.categories ){
              this.categories.add(category);


            }
            setState(() {

            });
            if(hasLoading){
              Navigator.pop(context);
            }else{
              bandLoadingText = false;
            }

          }else{
            if(hasLoading){
              Navigator.pop(context);
            }else{
              bandLoadingText = false;
            }
            setState(() {

            });
            // utils.showSnackBarError(context,data.message);
          }

          //loading = false;
        }, onError: (error) {
          print("Ocurrio un error: ${error}");
          //loading = false;
          if(hasLoading){
            Navigator.pop(context);
          }
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
