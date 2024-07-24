import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Utils/Strings.dart';
import '../../../../config/config.dart';
import '../../../feature_department_categories/domain/domain.dart';
import '../../../feature_views_shared/domain/domain.dart';
import '../../../providers.dart';
import '../presentation.dart';

class FilterCategoryWidget extends StatelessWidget {
  late FilterRightProvider filterRightProvider;
  late DepartmentProvider departmentProvider;

  @override
  Widget build(BuildContext context) {
    filterRightProvider = Provider.of<FilterRightProvider>(context);
    departmentProvider = Provider.of<DepartmentProvider>(context);
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: AppColors.gray2,
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        iconColor: AppColors.blue,
        collapsedIconColor: AppColors.blue,
        title: Text(
          Strings.categories,
          style: TextStyle(
              color: AppColors.blueSplash,
              fontSize: 16,
              fontFamily: Strings.fontBold),
        ),
        children: [
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: departmentProvider.departments.map((department) {
              return ExpansionTile(
                dense: true,
                title: RadioListTile<String>(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(department.department),
                  value: department.department,
                  groupValue: departmentProvider.selectedDepartment,
                  onChanged: (_) => departmentProvider
                      .selectDepartment(department.department),
                ),
                children: department.categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ExpansionTile(
                      dense: true,
                      
                      title: RadioListTile<String>(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        title: Text(category.category),
                        value: category.category,
                        groupValue: departmentProvider.selectedCategory,
                        onChanged: (_) =>
                            departmentProvider.selectCategory(category.category),
                      ),
                      children: category.subCategories.map((subcategory) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: RadioListTile<String>(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            title: Text(subcategory.subCategory),
                            value: subcategory.subCategory,
                            groupValue: departmentProvider.selectedSubcategory,
                            onChanged: (_) => departmentProvider.selectSubcategory(subcategory.subCategory),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          )
          //CATEGORIES

          /* ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: departmentProvider.departments.length,
            itemBuilder: (context, index) {
              Department department = departmentProvider.departments[index];
              return _buildDepartmentTile(department);
            },
          ),*/
        ],
      ),
    );
  }

  Widget _buildDepartmentTile(Department department) {
    return ExpansionTile(
      title: Text(department.department,
          style: TextStyle(
              color: AppColors.blueSplash,
              fontSize: 16,
              fontFamily: Strings.fontBold)),
      children: department.categories
          .map((category) => _buildCategoryTile(category))
          .toList(),
    );
  }

  Widget _buildCategoryTile(Category category) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: ExpansionTile(
        title: Text(category.category,
            style: TextStyle(
                color: AppColors.blueSplash,
                fontSize: 15,
                fontFamily: Strings.fontRegular)),
        children: category.subCategories
            .map((subcategory) => _buildSubcategoryTile(subcategory))
            .toList(),
      ),
    );
  }

  Widget _buildSubcategoryTile(SubCategory subcategory) {
    return Padding(
      padding: EdgeInsets.only(left: 32.0),
      child: ListTile(
        title: Text(subcategory.subCategory,
            style: TextStyle(
                color: AppColors.blueSplash,
                fontSize: 15,
                fontFamily: Strings.fontRegular)),
        onTap: () {},
      ),
    );
  }
}
