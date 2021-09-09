import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wawamko/src/Models/Banner.dart';
import 'package:wawamko/src/Models/Brand.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget itemCategory(Category category) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: convertColor(category.color),
              boxShadow: [
                BoxShadow(
                    color: convertColor(category.color).withOpacity(.4),
                    blurRadius: 7,
                    offset: Offset(2, 3))
              ]),
          child: Center(
            child: FadeInImage(
              height: 40,
              fit: BoxFit.fill,
              image: NetworkImage(category.image),
              placeholder: AssetImage("Assets/images/spinner.gif"),
            ),
          ),
        ),
        SizedBox(height: 15),
        Text(
          category.category,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: Strings.fontRegular,
            fontSize: 13,
            color: CustomColors.blackLetter,
          ),
        )
      ],
    ),
  );
}

Widget boxSearchNextPage( TextEditingController searchController,Function searchElements) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: CustomColors.graySearch.withOpacity(.3)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Image(
            height: 20,
            color: Colors.white,
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
                color: Colors.white),
            decoration: InputDecoration(
                hintText: Strings.search,
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: Colors.white)),
          ),
        )
      ],
    ),
  );
}


Widget boxSearchHome( TextEditingController searchController,Function searchElements) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: CustomColors.graySearch.withOpacity(.3)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Image(
            height: 20,
            color: Colors.white,
            image: AssetImage("Assets/images/ic_seeker.png"),
          ),
        ),
        Expanded(
          child: TextField(
            controller: searchController,
            onChanged: (value){
              searchElements(value);
            },
            style: TextStyle(
                fontFamily: Strings.fontRegular,
                fontSize: 15,
                color: Colors.white),
            decoration: InputDecoration(
                hintText: Strings.search,
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: Colors.white)),
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
    color: CustomColors.grayBackground,
  );
}

Widget itemBrand(Brand brand){
  return Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    ),
    child: FadeInImage(
      fit: BoxFit.fill,
      image: NetworkImage(brand.image),
      placeholder: AssetImage(""),
    ),
  );
}

Widget sliderBanner(int indexSlider,Function updateIndex, List<Banners> banners){
  return Stack(
    children: [
      Swiper(
          itemBuilder: (_, int index) {
            return FadeInImage(
                fit: BoxFit.fill,
                image: NetworkImage(banners.isEmpty?"":banners[index]?.image),
                placeholder: AssetImage("Assets/images/preloader.gif"),
              );
          },
          autoplay: false,
          itemCount: banners.isEmpty?0:banners.length,
          duration: 4000,
          onIndexChanged: (index) {
            updateIndex(index);
          }),
      banners.isEmpty?Container():Positioned(
        bottom: 25,
        left: 0,
        right: 0,
        child: DotsIndicator(
          dotsCount: banners.length,
          position: indexSlider.toDouble(),
          decorator: DotsDecorator(
            activeColor: CustomColors.redTour,
            size: const Size.square(9),
            spacing: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
            activeSize: const Size(30, 9),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      )
    ],
  );
}

Widget itemProduct(Product product){
  int position = getRandomPosition(product?.references?.length??0);
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
    child: Column(
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
                  image: NetworkImage(product?.brandProvider?.brand?.image),
                  placeholder: AssetImage("Assets/images/preloader.gif"),
          ),
              ),
            )
          ),
        ),
        SizedBox(height: 10,),
        Container(
          width: 120,
          height: 90,
          child: FadeInImage(
            fit: BoxFit.fill,
            image: NetworkImage(product?.references[position].images[getRandomPosition(product?.references[position].images.length)].url??''),
            placeholder: AssetImage("Assets/images/spinner.gif"),
          ),
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
                      fontSize: 13,
                      fontFamily: Strings.fontBold,
                      color: CustomColors.blackLetter),
                ),
                Text(
                  product.brandProvider?.brand?.brand??'',
                  style: TextStyle(
                      fontSize: 11,
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.gray7),
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
                  product.references.isNotEmpty?formatMoney(product?.references[position].price):formatMoney("0"),
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: Strings.fontBold,
                      color: CustomColors.blueSplash,
                ),
                )
              ],
            ),
          ),
        )
      ],
    ),
  );
}