

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wawamko/src/Animations/animate_button.dart';
import 'package:wawamko/src/Models/Brand.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Models/SubCategory.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget itemCategoryRow(Category category, Function openSubcategory){
  return InkWell(
    onTap: ()=>openSubcategory(category),
    child: Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(9)),
        border: Border.all(color: CustomColorsAPP.grayBackground,width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: convertColor(category.color!),
                      boxShadow: [
                        BoxShadow(
                            color: convertColor(category.color!).withOpacity(.4),
                            blurRadius: 7,
                            offset: Offset(2, 3))
                      ]),
                  child: Center(
                    child: FadeInImage(
                      height: 25,
                      fit: BoxFit.fill,
                      image: NetworkImage(category.image!),
                      placeholder: AssetImage("Assets/images/spinner.gif"),
                      imageErrorBuilder: (_,__,___){
                        return Container();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  category.category!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 13,
                    color: CustomColorsAPP.blackLetter,
                  ),
                )
              ],
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: CustomColorsAPP.gray4,
            )
          ],
        ),
      ),
    ),
  );
}

Widget itemSubCategoryRow(SubCategory subCategory, Function openProductsSubcategory){
  return InkWell(
    onTap: ()=>openProductsSubcategory(subCategory),
    child: Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: CustomColorsAPP.grayBackground,width: 1),
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
                    subCategory.subcategory??"not found",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Strings.fontBold,
                      fontSize: 16,
                      color: CustomColorsAPP.blueSplash,
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

Widget itemBrandRow(Brand brand, Function openProducts){
  return InkWell(
    onTap: ()=>openProducts(brand),
    child: Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(9)),
        border: Border.all(color: CustomColorsAPP.grayBackground,width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                brand.brand!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  fontSize: 13,
                  color: CustomColorsAPP.blackLetter,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: CustomColorsAPP.gray4,
            )
          ],
        ),
      ),
    ),
  );
}

Widget itemProductRelations(Product product, Function openDetail){
  return InkWell(
    onTap: ()=>openDetail(product),
    child: Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              child: product.references[0].images!.isEmpty?Image.asset("Assets/images/spinner.gif"):
              isImageYoutube(product.references[0].images?[0].url??"",FadeInImage(
                fit: BoxFit.fill,
                image: NetworkImage(product.references[0].images?[0].url??""),
                placeholder: AssetImage("Assets/images/spinner.gif"),
                imageErrorBuilder: (_,__,___){
                  return Container();
                },),

              ),
            ),
            customDivider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brandProvider?.brand?.brand??'',
                    style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 12,
                      color: CustomColorsAPP.gray7,
                    ),
                  ),
                  Text(
                    product.references[0].reference??'',
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 13,
                      color: CustomColorsAPP.blackLetter,
                    ),
                  ),
                  Text(
                    formatMoney( product.references[0].price??'0'),
                    style: TextStyle(
                      fontFamily: Strings.fontBold,
                      color: CustomColorsAPP.orange,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget itemProductCategory(Product product, Function openDetail,Function callFavorite){
  return InkWell(
    onTap: ()=>openDetail(product),
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
            offset: Offset(0, 2), // changes position of shadow
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
                child: product.references[0].images!.isEmpty?Image.asset("Assets/images/spinner.gif"):
                    isImageYoutube(product.references[0].images?[0].url??'',
                FadeInImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(product.references[0].images?[0].url??''),
                  placeholder: AssetImage("Assets/images/spinner.gif"),
                  imageErrorBuilder: (_,__,___){
                    return Container();
                  },
                )),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.brandProvider?.brand?.brand??'',
                        maxLines: 2,
                        style: TextStyle(
                          height: 1,
                          fontFamily: Strings.fontRegular,
                          fontSize: 13,
                          color: CustomColorsAPP.gray7,
                        ),
                      ),
                      Text(
                        product.references[0].reference??'',
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: Strings.fontMedium,
                          fontSize: 16,
                          color: CustomColorsAPP.blackLetter,
                        ),
                      ),

                      Text(
                        formatMoney( product.references[0].price??'0'),
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 18,
                          color: CustomColorsAPP.orange,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),

          Positioned(
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
                  backgroundColor: CustomColorsAPP.redTour,
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
              )),
        ],
      ),
    ),
  );
}

Widget favorite(bool isFavorite){
  return Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        border: Border.all(color: isFavorite?Colors.transparent:CustomColorsAPP.gray5),
        boxShadow: [
          BoxShadow(
            color: isFavorite?CustomColorsAPP.redTour.withOpacity(0.2):CustomColorsAPP.gray5.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ]
    ),
    child: Center(
      child: Icon(
        Icons.favorite,
        size: 20,
        color: isFavorite?CustomColorsAPP.redTour:CustomColorsAPP.gray5,
      ),
    ),
  );
}

Widget rowButtonsMoreAndLess(String units, Function add, Function remove){
  return  Container(
    margin: EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        buttonMoreOrLess(Icons.remove, remove),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            units,
            style: TextStyle(
                fontSize: 25,
                fontFamily: Strings.fontBold,
                color: CustomColorsAPP.blueSplash),
          ),
        ),
        buttonMoreOrLess(Icons.add, add),
      ],
    ),
  );
}

Widget buttonMoreOrLess(IconData icon, Function action){
  return Container(
    width: 30,
    height: 30,
    child: AnimateButton(
      pressEvent: ()=> action(),
      body: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: CustomColorsAPP.blueSplash,
            borderRadius: BorderRadius.all(Radius.circular(6))
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

Widget rowStars(double qualify){
  return  Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    child: RatingBar.builder(
      initialRating: qualify,
      minRating: 1,
      itemSize: 20,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ignoreGestures: true,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {},
    ),
  );
}