import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Models/SubCategory.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/Categories/ProductCategoryPage.dart';
import 'package:wawamko/src/UI/Home/Categories/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class SubCategoryPage extends StatefulWidget{
  final Category category;

  const SubCategoryPage({required this.category});
  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  late ProviderSettings providerSettings;
  SharePreference prefs = SharePreference();
  RefreshController _refreshSubCategories =
  RefreshController(initialRefresh: false);
  int pageOffset = 0;


  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context,listen: false);
    providerSettings.ltsSubCategories.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSubCategories(widget.category.id.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: AppColors.gray12,
      body: SafeArea(
        child: Container(
          color: AppColors.gray12,
          child: Stack(
            children: [
              Column(
                children: [
                  headerView( widget.category.category??"not found", ()=>Navigator.pop(context)),
                  Expanded(
                      child: SmartRefresher(
                          controller: _refreshSubCategories,
                          enablePullDown: true,
                          enablePullUp: true,
                          onLoading: _onLoadingToRefresh,
                          footer: footerRefreshCustom(),
                          header: headerRefresh(),
                          onRefresh: _pullToRefresh,
                          child: providerSettings.hasConnection?providerSettings.ltsSubCategories.isEmpty
                              ? emptyData("ic_empty_notification.png",
                              Strings.sorry, Strings.emptySubCategories)
                              :SingleChildScrollView(child: listSubcategories()):notConnectionInternet()))
                ],
              ),
              Visibility(
                  visible: providerSettings.isLoading, child: LoadingProgress()),
            ],
          ),
        ),
      ),
    );
  }

  Widget listSubcategories() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: providerSettings.ltsSubCategories.isEmpty?0:providerSettings.ltsSubCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return itemSubCategoryRow(providerSettings.ltsSubCategories[index], openProductsBySubCategory);
        },
      ),
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    clearForRefresh();
    _refreshSubCategories.refreshCompleted();
  }

  void clearForRefresh() {
    pageOffset = 0;
    getSubCategories(widget.category.id.toString());
  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getSubCategories(widget.category.id.toString());
    _refreshSubCategories.loadComplete();
  }

  openProductsBySubCategory(SubCategory subCategory){
      Navigator.push(context, customPageTransition(ProductCategoryPage(idCategory: widget.category.id.toString(),idSubcategory: subCategory.id.toString(),),
      PageTransitionType.rightToLeftWithFade));
  }

  getSubCategories(String idCategory) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings = providerSettings.getSubCategories(pageOffset, idCategory);
        await callSettings.then((list) {

        }, onError: (error) {
         // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}