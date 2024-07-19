import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';

import '../../features/feature_views_shared/domain/domain.dart';

Widget btnFloating(Function action,String asset){
  return FloatingActionButton(
    onPressed: ()=>action(),
    backgroundColor: Colors.transparent,
    child:  SvgPicture.asset("Assets/images/$asset",height: 50,),
  );
}


Widget boxSearchNextPage( TextEditingController searchController,Function searchElements) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(26)), color: Colors.white),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Image(
            height: 20,
            color: AppColors.blue,
            image: AssetImage("Assets/images/ic_seeker.png"),
          ),
        ),
        Expanded(
          child: TextField(
            controller: searchController,
            onSubmitted: (value){
             searchElements();
            },
            style: TextStyle(
                fontFamily: Strings.fontRegular,
                fontSize: 15,
                color: AppColors.black1),
            decoration: InputDecoration(
                hintText: "${Strings.search}...",
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color:AppColors.gray15.withOpacity(.5))),
          ),
        )
      ],
    ),
  );
}


Widget boxSearchHome( TextEditingController searchController,Function? searchElements) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        color: Colors.white),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Image(
            height: 20,
            color: AppColors.blue,
            image: AssetImage("Assets/images/ic_seeker.png"),
          ),
        ),
        Expanded(
          child: TextField(
            controller: searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (value){
              searchElements!(value);
            },
            style: TextStyle(
                fontFamily: Strings.fontRegular,
                fontSize: 15,
                color: AppColors.black1),
            decoration: InputDecoration(
                hintText: "${Strings.search}..",
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: AppColors.gray15.withOpacity(.5))),
          ),
        )
      ],
    ),
  );
}

Widget customDivider(){
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    height: 1,
    width: double.infinity,
    color: AppColors.grayBackground,
  );
}




Widget itemSelectBrand(Brand brand,Function selectBrand,bool selected){
  return GestureDetector(
    onTap: ()=>selectBrand(brand),
    child: Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: selected ? AppColors.greenValid : AppColors.gray4, width: 1),
      ),
      child: Center(
        child: Row(
          children: [
            FadeInImage(
              fit: BoxFit.fill,
              width: 20,
              height: 20,
              image: NetworkImage(brand.image!),
              placeholder: AssetImage("Assets/images/ic_gallery.png"),
              imageErrorBuilder: (_,__,___){
                return Container();
              },
            ),
            const SizedBox(width: 15,),
            Expanded(
              child: Text(
                brand.brand ?? '',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: Strings.fontRegular
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}


Widget itemProduct(Product product){
  return Container(
    width: 150,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                child:  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                  child: Container(
                    width: 50,
                    height: 30,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(product.brandProvider?.brand?.image??''),
                      placeholder: AssetImage("Assets/images/preloader.gif"),
                      imageErrorBuilder: (_,__,___){
                        return Container();
                      },
              ),
                  ),
                )
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: 120,
              height: 90,
              child: product.references[0].images!.isEmpty?Image.asset("Assets/images/spinner.gif"):
              isImageYoutube(product.references[0].images![0].url??'',FadeInImage(
                fit: BoxFit.fill,
                image: NetworkImage(product.references[0].images![0].url??''),
                placeholder: AssetImage("Assets/images/spinner.gif"),
                imageErrorBuilder: (_,__,___){
                  return Container();
                },
              )),
            ),
            customDivider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.product??'',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                          fontSize: 13,
                          fontFamily: Strings.fontBold,
                          color: AppColors.blackLetter),
                    ),
                    Text(
                      product.brandProvider?.brand?.brand??'',
                      style: TextStyle(
                          fontSize: 11,
                          fontFamily: Strings.fontRegular,
                          color: AppColors.gray7),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        itemSize: 15,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ignoreGestures: true,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                        },
                      ),
                    ),
                    Text(
                      product.references.isNotEmpty?formatMoney(product.references[0].price):formatMoney("0"),
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: Strings.fontBold,
                          color: AppColors.blueSplash,
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
            )),
      ],
    ),
  );
}