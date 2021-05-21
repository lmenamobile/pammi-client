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
  List<Category> categoriesSelected = List();
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
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 30, top: 20, bottom: 10),
          child: GestureDetector(
            child: Container(
              width: 40,
              height: 40,
              child: Image(image: AssetImage("Assets/images/ic_back_w.png")),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200,
                  child: Text(
                    Strings.selectInterest,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 35,
                        fontFamily: Strings.fontBold,
                        color: CustomColors.white),
                  ),
                ),
                SizedBox(height: 11),
                Text(
                  Strings.selectCategory,
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.white),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20, bottom: 30),
                  child: StaggeredGridView.countBuilder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 0),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    itemCount: this.categories.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return itemCategoryInteresting(
                          this.categories[index], selectCategory);
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(1, 1.1),
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50, bottom: 20),
                  child: btnCustomRounded(
                      CustomColors.white, CustomColors.grayLetter, Strings.next, validateCategoriesSelected, context),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  serviceGetCategories(String filter) async {
    this.categories = [];
    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);

        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => DialogLoadingAnimated()));
        Future callResponse =
            ProductsProvider.instance.getCategories(context, filter, 0);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          CategoriesResponse data = CategoriesResponse.fromJson(decodeJSON);

          if (data.status) {
            for (var category in data.data.categories) {
              this.categories.add(category);
            }
            setState(() {});
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
            setState(() {});
            // utils.showSnackBarError(context,data.message);
          }

          //loading = false;
        }, onError: (error) {
          print("Ocurrio un error: ${error}");
          //loading = false;
          Navigator.pop(context);
        });
      } else {
        hasInternet = false;
        // loading = false;
        //utils.showSnackBarError(context,Strings.loseInternet);
      }
    });
  }

  selectCategory(Category category) {
    if (category.selected) {
      category.selected = false;
      categoriesSelected.remove(category);
    } else {
      if (categoriesSelected.length <= 4) {
        category.selected = true;
        categoriesSelected.add(category);
      } else {
        utils.showSnackBar(context, Strings.categoriesMaxSelected);
      }
    }
    setState(() {});
  }

  validateCategoriesSelected(){
    if(categoriesSelected.isNotEmpty){
      serviceSaveCategories();
    }else{
      utils.showSnackBar(context, Strings.emptySelectCategory);
    }
  }

  serviceSaveCategories() async {
    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callResponse =
            ProductsProvider.instance.saveCategories(context, categoriesSelected);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          ChangeStatusAddressResponse data =
              ChangeStatusAddressResponse.fromJson(decodeJSON);

          if (data.status) {
            print("Sucess___");
            Navigator.pop(context);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyHomePage()),
                (Route<dynamic> route) => false);
          } else {
            Navigator.pop(context);
            setState(() {});
            utils.showSnackBarError(context, data.message);
          }

          //loading = false;
        }, onError: (error) {
          print("Ocurrio un error: ${error}");
          //loading = false;
          Navigator.pop(context);
        });
      } else {
        hasInternet = false;
        // loading = false;
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
