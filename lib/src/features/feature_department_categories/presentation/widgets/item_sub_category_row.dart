import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../../Utils/Strings.dart';
import '../../../../config/config.dart';
import '../../domain/domain.dart';

class ItemSubCategoryRow extends StatelessWidget {
  final SubCategory subCategory;
  final Function(SubCategory) openProductsSubCategories;

  const ItemSubCategoryRow({super.key, required this.subCategory, required this.openProductsSubCategories});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>openProductsSubCategories(subCategory),
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: AppColors.grayBackground,width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 15, 15,18),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      subCategory.subCategory??"not found",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: Strings.fontBold,
                        fontSize: 16,
                        color: AppColors.blueSplash,
                      ),
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                "Assets/images/btn_see_more_circle.svg",
              )
            ],
          ),
        ),
      ),
    );
  }


}