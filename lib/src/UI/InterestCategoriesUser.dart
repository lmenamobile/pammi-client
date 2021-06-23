import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/HomePage.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import 'Onboarding/Login.dart';

class InterestCategoriesUser extends StatefulWidget {
  @override
  _InterestCategoriesUserState createState() => _InterestCategoriesUserState();
}

class _InterestCategoriesUserState extends State<InterestCategoriesUser> {
  RefreshController _refreshCategories =
      RefreshController(initialRefresh: false);
  List<Category> categoriesSelected = List();
  ProviderSettings providerSettings;
  SharePreference prefs = SharePreference();
  int pageOffset = 0;

  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context, listen: false);
    providerSettings.ltsCategories.clear();
    serviceGetCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            child: _body(context),
          ),
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
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
          ),
        ),
        Expanded(
          child: SmartRefresher(
            controller: _refreshCategories,
            enablePullDown: true,
            enablePullUp: true,
            onLoading: _onLoadingToRefresh,
            footer: footerRefreshCustom(),
            header: headerRefresh(),
            onRefresh: _pullToRefresh,
            child: SingleChildScrollView(
              child: Column(
                children: [
                 Padding(
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
                                itemCount:
                                    providerSettings?.ltsCategories?.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  return itemCategoryInteresting(
                                      providerSettings?.ltsCategories[index],
                                      selectCategory);
                                },
                                staggeredTileBuilder: (int index) =>
                                    new StaggeredTile.count(1, 1.1),
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 50, right: 50, bottom: 20),
                              child: btnCustomRounded(
                                  CustomColors.white,
                                  CustomColors.gray7,
                                  Strings.next,
                                  validateCategoriesSelected,
                                  context),
                            )
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshCategories.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    providerSettings.ltsCategories.clear();
    categoriesSelected.clear();
    serviceGetCategories();
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    serviceGetCategories();
    _refreshCategories.loadComplete();
  }

  serviceGetCategories() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings = providerSettings.getCategoriesInterest(
            "", pageOffset, prefs.countryIdUser);
        await callSettings.then((list) {}, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  selectCategory(Category category) {
    if (category.isSelected) {
      category.isSelected = false;
      categoriesSelected.remove(category);
    } else {
      if (categoriesSelected.length <= 4) {
        category.isSelected = true;
        categoriesSelected.add(category);
      } else {
        utils.showSnackBar(context, Strings.categoriesMaxSelected);
      }
    }
    setState(() {});
  }

  validateCategoriesSelected() {
    if (categoriesSelected.isNotEmpty) {
      callSaveCategories();
    } else {
      utils.showSnackBar(context, Strings.emptySelectCategory);
    }
  }

  callSaveCategories() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings =
            providerSettings.saveCategories(categoriesSelected);
        await callSettings.then((msg) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyHomePage()),
              (Route<dynamic> route) => false);
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
