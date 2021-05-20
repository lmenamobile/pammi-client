import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wawamko/src/Models/Address/GetAddress.dart';
import 'package:wawamko/src/Models/Product/CategoryModel.dart';
import 'package:wawamko/src/Providers/ProductsProvider.dart';
import 'package:wawamko/src/UI/HomePage.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class InterestCategoriesUser extends StatefulWidget {
  @override
  _InterestCategoriesUserState createState() => _InterestCategoriesUserState();
}

class _InterestCategoriesUserState extends State<InterestCategoriesUser> {
  List<Category> categories = List();
  bool hasInternet;

  @override
  void initState() {
    serviceGetCategories("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.redTour,
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
        Positioned(
          top: 30,
          left: 30,
          child: GestureDetector(
            child: Container(
              width: 40,
              height: 40,
              child: Image(
                  image: AssetImage("Assets/images/ic_back_w.png")
              ),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),

        ),
        Positioned(
          top: 80,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(left: 42,right:50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Strings.selectInterest,
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: Strings.fontBold,
                      color: CustomColors.white
                    ),
                  ),
                  SizedBox(height: 11),
                  Text(
                    Strings.selectCategory,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: Strings.fontRegular,
                        color: CustomColors.white
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20,bottom: 30),
                    child: StaggeredGridView.countBuilder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 0),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      itemCount:this.categories.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return itemCategoryInteresting(this.categories[index]);
                      },
                      staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count( 1,1.1),
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 50,right:50,bottom: 20),
                    child: btnCustomRounded(CustomColors.white,CustomColors.grayLetter, Strings.next, (){serviceSaveCategories();}, context),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }



  serviceGetCategories(String filter) async {
    this.categories = [];
    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);


        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => DialogLoadingAnimated()));
        Future callResponse = ProductsProvider.instance.getCategories(context,filter,0);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          CategoriesResponse data = CategoriesResponse.fromJson(decodeJSON);

          if(data.status) {


            for(var category in data.data.categories ){
              this.categories.add(category);
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
        // loading = false;
        //utils.showSnackBarError(context,Strings.loseInternet);
      }
    });
  }

  serviceSaveCategories() async {
    var numSelected = 0;
    List<int> idCats = List();

    for(var cat in this.categories){
      if(cat.selected){
        idCats.add(cat.id);
        numSelected += 1;
      }
    }

    if(numSelected < 1){
      utils.showSnackBar(context, Strings.emptySelectCategory);
      return;
    }


    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);


        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => DialogLoadingAnimated()));
        Future callResponse = ProductsProvider.instance.saveCategories(context, idCats);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          ChangeStatusAddressResponse data = ChangeStatusAddressResponse.fromJson(decodeJSON);

          if(data.status) {

            print("Sucess___");
            Navigator.pop(context);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                MyHomePage()), (Route<dynamic> route) => false);
          }else{
            Navigator.pop(context);
            setState(() {

            });
             utils.showSnackBarError(context,data.message);
          }

          //loading = false;
        }, onError: (error) {
          print("Ocurrio un error: ${error}");
          //loading = false;
          Navigator.pop(context);
        });
      }else{
        hasInternet = false;
        // loading = false;
        utils.showSnackBarError(context,Strings.loseInternet);
      }
    });
  }
}
