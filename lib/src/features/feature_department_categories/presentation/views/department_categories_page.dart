import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/features/feature_department_categories/presentation/views/categories_page.dart';


import '../../../feature_home/presentation/widgets/section_departments_widget.dart';
import '../../../feature_views_shared/domain/domain.dart';
import '../../../feature_views_shared/presentation/presentation.dart';



class DepartmentCategoriesPage extends StatefulWidget {
  @override
  _DepartmentCategoriesPageState createState() => _DepartmentCategoriesPageState();
}

class _DepartmentCategoriesPageState extends State<DepartmentCategoriesPage> {
  final searchController = TextEditingController();
  late DepartmentProvider departmentProvider;
  SharePreference prefs = SharePreference();
  RefreshController _refreshCategories = RefreshController(initialRefresh: false);
  int pageOffset = 0;

  @override
  void initState() {
    departmentProvider = Provider.of<DepartmentProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {;
    return Scaffold(
      backgroundColor: AppColors.gray12,
      body: SafeArea(
        child: Container(
          color: AppColors.gray12,
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
                  child:  departmentProvider.departments.isEmpty ? Center(
                          child: SingleChildScrollView(
                              child: emptyData("ic_empty_notification.png", Strings.sorry, Strings.emptyCategories)),)
                      : SingleChildScrollView(child:
                  SectionDepartmentsWidget(
                    isAvailableHeader: false,
                    departments: departmentProvider.departments,
                    openCategories: openCategory,
                  )
                  ),
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
    searchController.clear();

  }

  void _onLoadingToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;

    _refreshCategories.loadComplete();
  }



  openCategory(Department department) {
    Navigator.push(context, customPageTransition(CategoriesPage(department: department), PageTransitionType.rightToLeftWithFade));
  }

  searchElements(String value) {

  }


}
