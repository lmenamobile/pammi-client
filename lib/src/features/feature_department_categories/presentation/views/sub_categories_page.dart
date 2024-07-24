import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/features/feature_products/presentation/views/products_by_sub_category_page.dart';

import '../../../../Utils/Strings.dart';
import '../../../../Widgets/LoadingProgress.dart';
import '../../../../Widgets/WidgetsGeneric.dart';
import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../presentation.dart';

class SubCategoriesPage extends StatefulWidget {
  final Category category;
  const SubCategoriesPage({super.key, required this.category});
  @override
  _SubCategoriesPageState createState() => _SubCategoriesPageState();

}

class _SubCategoriesPageState extends State<SubCategoriesPage> {
  RefreshController _refreshSubCategories = RefreshController(initialRefresh: false);
  late SubCategoriesProvider subCategoriesProvider;

  initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subCategoriesProvider.resetPagination();
      subCategoriesProvider.loadSubCategories(categoryId: widget.category.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    subCategoriesProvider = Provider.of<SubCategoriesProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.gray12,
      body: SafeArea(
        child: Container(
          color: AppColors.gray12,
          child: Stack(
            children: [
              Column(
                children: [
                  headerView( widget.category.category, ()=>Navigator.pop(context)),
                  Expanded(
                      child: SmartRefresher(
                          controller: _refreshSubCategories,
                          enablePullDown: true,
                          enablePullUp: true,
                          onLoading: _onLoadingToRefresh,
                          onRefresh: _pullToRefresh,
                          child: subCategoriesProvider.subCategories.isEmpty
                              ? emptyData("ic_empty_notification.png", Strings.sorry, Strings.emptySubCategories)
                              :SingleChildScrollView(child: listSubCategories())
                      )
                  )
                ],
              ),
              subCategoriesProvider.isLoading ? LoadingProgress() : Container()
            ],
          ),
        ),
      ),
    );
  }


    Widget listSubCategories() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: subCategoriesProvider.subCategories.length,
          itemBuilder: (_, int index) {
            SubCategory subCategory= subCategoriesProvider.subCategories[index];
            return ItemSubCategoryRow(subCategory: subCategory, openProductsSubCategories: openProductsSubCategories);
          },
        ),
      );
    }

    void _onLoadingToRefresh() async{
      await Future.delayed(Duration(milliseconds: 800));
      subCategoriesProvider.loadMoreSubCategories();
      _refreshSubCategories.loadComplete();
    }

    void _pullToRefresh() async {
      await Future.delayed(Duration(milliseconds: 800));
      subCategoriesProvider.refreshSubCategories();
      _refreshSubCategories.refreshCompleted();
    }

    void openProductsSubCategories(SubCategory subCategory){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductsByCategoryPage(subCategory: subCategory)));
    }
}