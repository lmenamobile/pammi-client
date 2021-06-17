import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/Categories/SubCategoryPage.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../Widgets.dart';
import 'Widgets.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final searchController = TextEditingController();
  ProviderSettings providerSettings;
  SharePreference prefs = SharePreference();
  RefreshController _refreshCategories =
      RefreshController(initialRefresh: false);
  int pageOffset = 0;

  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[CustomColors.redTour, CustomColors.redOne],
                  ),
                ),
                child: Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Image(
                                image: AssetImage(
                                    "Assets/images/ic_backward_arrow.png"),
                              ),
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                          Text(
                            Strings.categories,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily: Strings.fontBold),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 30,
                              child: Image(
                                image: AssetImage("Assets/images/ic_car.png"),
                              ),
                            ),
                            onTap: null,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          child: boxSearchHome(searchController,searchElements))
                    ],
                  ),
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
                  child: SingleChildScrollView(child: listCategories()),
                ),
              ),
            ],
          ),
        ),
      ),
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
    searchController.clear();
    getCategories(searchController.text);
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getCategories(searchController.text);
    _refreshCategories.loadComplete();
  }

  Widget listCategories() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: ListView.builder(
        itemCount:providerSettings.ltsCategories.isEmpty?0:providerSettings.ltsCategories.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return itemCategoryRow(
              providerSettings.ltsCategories[index], openSubCategory);
        },
      ),
    );
  }

  openSubCategory(Category category) {
    Navigator.push(
        context,
        customPageTransition(SubCategoryPage(
          category: category,
        )));
  }

  searchElements(String value){
      providerSettings.ltsCategories.clear();
      getCategories(value);
  }

  getCategories(String text) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings = providerSettings.getCategoriesInterest(text ?? '', pageOffset, prefs.countryIdUser);
        await callSettings.then((list) {}, onError: (error) {
          //utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
