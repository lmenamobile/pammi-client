import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:wawamko/src/Models/Product/CategoryModel.dart';
import 'package:wawamko/src/Models/Product/SubCategoryModel.dart';
import 'package:wawamko/src/Providers/ProductsProvider.dart';
import 'package:wawamko/src/UI/listProductByCategorie.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class ProductsByCategoryPage extends StatefulWidget {
  Category category;
  ProductsByCategoryPage({Key key,this.category}) : super(key: key);
  @override
  _ProductsByCategoryPageState createState() => _ProductsByCategoryPageState();
}

class _ProductsByCategoryPageState extends State<ProductsByCategoryPage> {

  List<Subcategory> subCategories = List();
  bool hasInternet = true;

  @override
  void initState() {
    serviceGetSubCategories("");
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
          child: header(),
        ),
        Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: hasInternet ? Container(

              width: double.infinity,

              child:  ListView.builder(
                padding: EdgeInsets.only(top: 0,bottom: 20),
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: subCategories.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  //return //itemCategorie();
                  return itemProductByCategory(this.subCategories[index]);

                },


              ),
            ) : Center(child: Container(child: notifyInternet("Assets/images/ic_img_internet.png", Strings.titleAmSorry, Strings.loseInternet,context,(){
              serviceGetSubCategories("");})))




        )

      ],
    );
  }


  Widget header(){
    return Container(

      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
          color: CustomColors.white,
        image: DecorationImage(
          image: AssetImage("Assets/images/ic_header.png")
        )
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 8,
              color: CustomColors.blueSplash,
            ),
          ),

          Positioned(
            left: 15,
            top:25,
            child: GestureDetector(
              child: Image(
                width: 40,
                height: 40,
                image: AssetImage("Assets/images/ic_back_w.png"),

              ),
              onTap: (){Navigator.pop(context);},
            ),
          ),

           Container(

              margin: EdgeInsets.only(top: 35),
              alignment: Alignment.topCenter,
              child: Text(
                widget.category.category,
                textAlign: TextAlign.center,
                style: TextStyle(

                    fontSize: 15,
                    fontFamily: Strings.fontArialBold,
                    color: CustomColors.white

              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget itemProductByCategory(Subcategory subcategory){
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: CustomColors.gray.withOpacity(.3),width: 1),
          color: CustomColors.white
        ),
        width: double.infinity,
        height: 63,
        margin: EdgeInsets.only(left: 20,right: 20,top: 20),
        padding: EdgeInsets.only(left: 30,right: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                subcategory.subcategory,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: Strings.fontArial,
                  color: CustomColors.blackLetter
                ),
              ),
            ),
            Image(
              width: 25,
              height: 25,
              fit: BoxFit.fill,
              image: AssetImage("Assets/images/ic_arrow.png"),
            )
          ],
        ),
      ),
      onTap: (){
        Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:ListProductByCategories(), duration: Duration(milliseconds: 700)));

      },
    );
  }


  serviceGetSubCategories(String filter) async {
    this.subCategories = [];
    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        hasInternet = true;




        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => DialogLoadingAnimated()));
        Future callResponse = ProductsProvider.instance.getSubCategories(context, filter,0, widget.category);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          SubCategoriesResponse data = SubCategoriesResponse.fromJson(decodeJSON);

          if(data.status) {

            this.subCategories = [];
            for(var subCategory in data.data.subcategories ){
              this.subCategories.add(subCategory);


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
