
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../Utils/Strings.dart';
import '../../../../config/config.dart';
import '../../../feature_views_shared/domain/domain.dart';
import 'item_category_department.dart';

class SectionDepartmentsWidget extends StatelessWidget {
 final List<Department> departments;
 final VoidCallback openCategories;

  const SectionDepartmentsWidget({
    Key? key,
    required this.departments,
    required this.openCategories,
  }) : super(key: key);


 @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Strings.categories,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 24,
                color: AppColors.blueTitle,
                fontFamily: Strings.fontBold
            ),
          ),
        ),
        SizedBox(height: 8,),
        AnimationLimiter(
          child: GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 30,
              childAspectRatio: 0.9,
              crossAxisSpacing: 0,
            ),
            padding: EdgeInsets.only(top: 20),
            physics: NeverScrollableScrollPhysics(),
            itemCount: departments.length,
            shrinkWrap: true,
            itemBuilder: (_, int index) {
              Department department = departments[index];
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: 4,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: InkWell(
                        onTap: openCategories,
                        child: ItemCategoryDepartment(department: department)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}