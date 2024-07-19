import 'package:flutter/material.dart';

import '../../../../Utils/Strings.dart';
import '../../../../config/config.dart';
import '../../../feature_views_shared/domain/domain.dart';
import 'item_brand.dart';

class SectionBrandsWidget extends StatelessWidget {
  final List<Brand> brands;
  final Function openProductsByBrand;
  final VoidCallback openAllBrands;

  const SectionBrandsWidget({
    Key? key,
    required this.brands,
    required this.openProductsByBrand,
    required this.openAllBrands,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  Strings.ourOfficialBrands,
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: Strings.fontBold,
                      color: AppColors.blueSplash),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: ()=>openAllBrands,
                child: Text(
                  Strings.moreAll,
                  style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 15,
                      fontFamily: Strings.fontMedium),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 22),
        Container(
            height: 110,
            padding: EdgeInsets.only(left: 30),
            child: ListView.builder(
              itemCount: brands.length > 6 ? 6 : brands.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) {
                Brand brand = brands[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: InkWell(
                      onTap: ()=>openProductsByBrand(brand),
                      child: ItemBrand(brand: brand)),
                );
              },
            )),
      ],
    );
  }
}