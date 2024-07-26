
import 'package:flutter/material.dart';

import '../../../../Utils/FunctionsFormat.dart';
import '../../../../Utils/FunctionsUtils.dart';
import '../../../../Utils/Strings.dart';
import '../../../../config/config.dart';
import '../../domain/domain.dart';

class CardProduct extends StatelessWidget {
  final Product product;
  final Function onTapProduct;

  const CardProduct({super.key, required this.product, required this.onTapProduct});

  @override
  Widget build(BuildContext context) {
    final principalReference = product.getPrincipalReference;
    final hasImages = principalReference?.mediaResourcesReference.isNotEmpty ?? false;

    if (principalReference == null || !hasImages) {
      return Container();
    }

    return InkWell(
      onTap: ()=>onTapProduct(product),
      child: Container(
        width: 180.0,
        height: 318.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  child: isImageYoutube(
                    principalReference.mediaResourcesReference.first.url??'',
                    FadeInImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(principalReference.mediaResourcesReference.first.url??''),
                      placeholder: AssetImage("Assets/images/spinner.gif"),
                      imageErrorBuilder: (_, __, ___) => Container(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.brandProvider.brand.brand,
                          maxLines: 2,
                          style: TextStyle(
                            height: 1,
                            fontFamily: Strings.fontRegular,
                            fontSize: 13,
                            color: AppColors.gray7,
                          ),
                        ),
                        Text(
                          principalReference.referenceName,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: Strings.fontMedium,
                            fontSize: 16,
                            color: AppColors.blackLetter,
                          ),
                        ),
                        Text(
                          formatMoney(principalReference.price),
                          style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            fontSize: 18,
                            color: AppColors.orange,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            /*   Positioned(
                top: 3,
                right: 3,
                child: Visibility(
                  visible: userIsLogged()?true:false,
                  child: InkWell(
                      onTap: ()=>callFavorite(product.references[0]),
                      child: favorite(product.references[0].isFavorite??false)),
                )),

            Positioned(
                top: 3,
                left: 3,
                child: Visibility(
                  visible: product.references[0].totalProductOffer!.status??false,
                  child: CircleAvatar(
                    radius: 11,
                    backgroundColor: AppColors.redTour,
                    child: Center(
                      child: Text(
                        product.references[0].totalProductOffer!.discountValue!+"%",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                )),*/
          ],
        ),
      ),
    );
  }

}