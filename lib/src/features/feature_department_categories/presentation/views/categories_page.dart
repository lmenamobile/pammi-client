
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';



import '../../../feature_views_shared/domain/domain.dart';
import '../../domain/domain.dart';
import '../presentation.dart';

class CategoriesPage extends StatefulWidget{
  final Department department;

  const CategoriesPage({super.key, required this.department});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  SharePreference prefs = SharePreference();
  RefreshController _refreshCategories = RefreshController(initialRefresh: false);
  late CategoriesProvider categoriesProvider;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      categoriesProvider.loadCategories(departmentId: widget.department.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    categoriesProvider = Provider.of<CategoriesProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.gray12,
      body: SafeArea(
        child: Container(
          color: AppColors.gray12,
          child: Stack(
            children: [
              Column(
                children: [
                  headerView( widget.department.department, ()=>Navigator.pop(context)),
                  Expanded(
                      child: SmartRefresher(
                          controller: _refreshCategories,
                          enablePullDown: true,
                          enablePullUp: true,
                          onLoading: _onLoadingToRefresh,
                          footer: footerRefreshCustom(),
                          header: headerRefresh(),
                          onRefresh: _pullToRefresh,
                          child: categoriesProvider.categories.isEmpty
                              ? emptyData("ic_empty_notification.png", Strings.sorry, Strings.emptySubCategories)
                              :SingleChildScrollView(child: listCategories())))
                ],
              ),
              Visibility(
                  visible: categoriesProvider.isLoading, child: LoadingProgress()),
            ],
          ),
        ),
      ),
    );
  }

  Widget listCategories() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: categoriesProvider.categories.length,
        itemBuilder: (_, int index) {
          Category category = categoriesProvider.categories[index];
          return ItemCategoryRow(category: category, openSubCategories: openSubCategory);
        },
      ),
    );
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    categoriesProvider.refreshCategories();
    _refreshCategories.refreshCompleted();
  }



  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
      categoriesProvider.loadMoreCategories();
    _refreshCategories.loadComplete();
  }

  openSubCategory(Category category) {
     /* Navigator.push(context, customPageTransition(ProductCategoryPage(idCategory: widget.category.id.toString(),idSubcategory: subCategory.id.toString(),),
      PageTransitionType.rightToLeftWithFade));*/
  }



}