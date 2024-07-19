import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../../Utils/Strings.dart';
import '../../../../config/config.dart';
import '../../domain/domain.dart';

class ItemCategoryRow extends StatelessWidget {
  final Category category;
  final Function(Category) openSubCategories;

  const ItemCategoryRow({super.key, required this.category, required this.openSubCategories});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>openSubCategories(category),
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
                      category.category??"not found",
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