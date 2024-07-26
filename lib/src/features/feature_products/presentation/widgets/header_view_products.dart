import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../UI/Home/Widgets.dart';
import '../../../../Utils/Strings.dart';
import '../../../../config/config.dart';

class HeaderViewProducts extends StatelessWidget {
  final String title;
  final TextEditingController searchController;
  final VoidCallback onTapShopCart;
  final VoidCallback onTapSearch;
  final VoidCallback onTapFilter;

  const HeaderViewProducts({super.key,
    required this.title,
    required this.searchController,
    required this.onTapShopCart,
    required this.onTapSearch,
    required this.onTapFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.redDot,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: SvgPicture.asset(
                    "Assets/images/ic_arrow_back.svg",
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontFamily: Strings.fontBold),
                ),
                GestureDetector(
                  child: Stack(
                    children: [
                      Container(
                        width: 30,
                        child: Image(
                          image: AssetImage("Assets/images/ic_car.png"),
                        ),
                      ),
                     /* Positioned(
                        right: 0,
                        top: 0,
                        child: Visibility(
                          visible: totalProducts != "0" ? true : false,
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.white,
                            child: Text(
                              totalProducts,
                              style: TextStyle(
                                  fontSize: 8, color: AppColors.redTour),
                            ),
                          ),
                        ),
                      )*/
                    ],
                  ),
                  onTap: () => onTapShopCart(),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: boxSearchHome(searchController, onTapSearch)),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => onTapFilter(),
                  child: SvgPicture.asset(
                    "Assets/images/btn_filter.svg",
                    height: 40,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}