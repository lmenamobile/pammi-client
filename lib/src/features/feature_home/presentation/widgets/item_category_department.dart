
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Utils/Strings.dart';
import '../../../../config/config.dart';
import '../../../feature_views_shared/domain/domain.dart';


class ItemCategoryDepartment extends StatelessWidget {
  final Department department;

  const ItemCategoryDepartment({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.grayDot,
          ),
          child: Center(
            child: department.image != null
                ? department.image.contains(".svg") == true
                ? SvgPicture.network(department.image ?? '',
              placeholderBuilder: (_) => Container(
                padding: const EdgeInsets.all(30.0),
                child: const CircularProgressIndicator(),
              ),
            ) : FadeInImage(
              height: 30,
              width: 30,
              fit: BoxFit.contain,
              image: NetworkImage(department.image ?? ''),
              placeholder: AssetImage("Assets/images/spinner.gif"),
              imageErrorBuilder: (_, __, ___) {
                return Container();
              },
            ) : Container(
              height: 30,
              width: 30,
              child: Image.asset("Assets/images/spinner.gif"),
            ),
          ),
        ),
        SizedBox(height: 10),
        Flexible(
          child: Text(
            department.department ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Strings.fontRegular,
              fontSize: 10,
              color: AppColors.black1,
            ),
          ),
        ),
      ],
    );
  }
}