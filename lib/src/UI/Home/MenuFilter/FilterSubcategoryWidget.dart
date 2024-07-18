import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/SubCategory.dart';
import '../../../Providers/ProviderFilter.dart';
import '../../../Utils/Strings.dart';
import '../../../config/theme/colors.dart';

class FilterSubcategoryWidget extends StatelessWidget {
  late ProviderFilter providerFilter;
  @override
  Widget build(BuildContext context) {
    providerFilter = Provider.of<ProviderFilter>(context);
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: AppColors.gray2,
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        iconColor: AppColors.blue,
        collapsedIconColor: AppColors.blue,
        title: Text(
          Strings.subcategories,
          style: TextStyle(
              color: AppColors.blueSplash,
              fontSize: 16,
              fontFamily: Strings.fontBold),
        ),
        children: [
          //SUBCATEGORIES
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: providerFilter.ltsSubCategory.length,
            itemBuilder: (context, index) {
              SubCategory subCategory = providerFilter.ltsSubCategory[index];
              return CheckboxListTile(
                title: Text(
                  subCategory.subcategory ?? '',
                  style: TextStyle(
                      color: AppColors.blueSplash,
                      fontFamily: Strings.fontRegular),
                ),
                value: false,
                onChanged: (value) {

                },
              );
            },
          ),
        ],
      ),
    );
  }
}