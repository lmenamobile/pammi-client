import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/Categories/SubCategoryPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/ShopCartPage.dart';
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
  late ProviderSettings providerSettings;
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
      backgroundColor: CustomColorsAPP.gray12,
      body: SafeArea(
        child: Container(
          color: CustomColorsAPP.gray12,
          child: Column(
            children: [
              headerView(Strings.categories, ()=>Navigator.pop(context)),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshCategories,
                  enablePullDown: true,
                  enablePullUp: true,
                  onLoading: _onLoadingToRefresh,
                  footer: footerRefreshCustom(),
                  header: headerRefresh(),
                  onRefresh: _pullToRefresh,
                  child: providerSettings.hasConnection?providerSettings.ltsCategories.isEmpty ? Center(
                          child: SingleChildScrollView(
                              child: emptyData("ic_empty_notification.png", Strings.sorry, Strings.emptyCategories)),)
                      : SingleChildScrollView(child: gridCategories()):notConnectionInternet(),
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


  Widget gridCategories(){
    return   AnimationLimiter(
      child: GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 30,
          childAspectRatio: 0.9,
          crossAxisSpacing: 0,
        ),
        padding: EdgeInsets.only(top: 20),
        physics: NeverScrollableScrollPhysics(),
        itemCount: providerSettings.ltsCategories.length > 8
            ? 8 : providerSettings.ltsCategories.length-1,
        shrinkWrap: true,
        itemBuilder: (_, int index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 4,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: InkWell(
                    onTap: () => openSubCategory(providerSettings.ltsCategories[index]),
                    child: itemCategory(providerSettings.ltsCategories[index])),
              ),
            ),
          );
        },
      ),
    );
  }

  openSubCategory(Category category) {
    Navigator.push(context,
        customPageTransition(SubCategoryPage(
          category: category,
        ), PageTransitionType.rightToLeftWithFade));
  }

  searchElements(String value) {
    providerSettings.ltsCategories.clear();
    getCategories(value);
  }

  getCategories(String text) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings = providerSettings.getCategoriesInterest(
            text, pageOffset, prefs.countryIdUser);
        await callSettings.then((list) {}, onError: (error) {
          //utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
