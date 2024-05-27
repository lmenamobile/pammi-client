import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wawamko/src/Models/Banner.dart';
import 'package:wawamko/src/Models/Brand.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget btnFloating(Function action,String asset){
  return FloatingActionButton(
    onPressed: ()=>action(),
    backgroundColor: Colors.transparent,
    child:  SvgPicture.asset("Assets/images/$asset",height: 50,),
  );
}


Widget itemCategory(Category category) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CustomColorsAPP.grayDot,
        ),
        child: Center(
          child: category.image != null
              ? category.image!.contains(".svg") == true
              ? SvgPicture.network(category.image ?? '',
              placeholderBuilder: (_) => Container(
              padding: const EdgeInsets.all(30.0),
              child: const CircularProgressIndicator(),
            ),
          ) : FadeInImage(
            height: 30,
            width: 30,
            fit: BoxFit.contain,
            image: NetworkImage(category.image ?? ''),
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
          category.category ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: Strings.fontRegular,
            fontSize: 10,
            color: CustomColorsAPP.black1,
          ),
        ),
      ),
    ],
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
            color: CustomColorsAPP.blue,
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
                color: CustomColorsAPP.black1),
            decoration: InputDecoration(
                hintText: "${Strings.search}...",
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color:CustomColorsAPP.gray15.withOpacity(.5))),
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
            color: CustomColorsAPP.blue,
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
                color: CustomColorsAPP.black1),
            decoration: InputDecoration(
                hintText: "${Strings.search}..",
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: CustomColorsAPP.gray15.withOpacity(.5))),
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
    color: CustomColorsAPP.grayBackground,
  );
}

Widget itemBrand(Brand brand){
  double size = 60;
  return ClipRRect(
    borderRadius: BorderRadius.circular(60),
    child: Image.network(
      brand.image ?? "",
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: size,
          height: size,
          color: Colors.grey,
          child: Icon(
            Icons.error,
            color: Colors.white,
          ),
        );
      },
    ),
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
        border: Border.all(color: selected ? CustomColorsAPP.greenValid : CustomColorsAPP.gray4, width: 1),
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

Widget sliderBanner(int? indexSlider,Function updateIndex, List<Banners> banners){
  return Column(
    children: [
      CarouselSlider.builder(
        itemCount: banners.isEmpty?0:banners.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            FadeInImage(
              fit: BoxFit.fill,
              image: NetworkImage(banners[itemIndex].image??''),
              placeholder: AssetImage("Assets/images/preloader.gif"),
              imageErrorBuilder: (_,__,___){
                return Container();
              },
            ), options: CarouselOptions(
              height: 208,
              viewportFraction: 1,
              autoPlay: true,
              autoPlayAnimationDuration: Duration(seconds: 4),
              onPageChanged: (index,changeType){
                updateIndex(index);
              }
        ),
      ),

      banners.isEmpty?Container():Column(
        children: [
          const SizedBox(height: 17),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DotsIndicator(
              dotsCount: banners.length,
              position: indexSlider!,
              decorator: DotsDecorator(
                activeColor: CustomColorsAPP.blue5,
                size: const Size.square(9),
                spacing: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
                activeSize: const Size(9, 9),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
        ],
      )
    ],
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
                          color: CustomColorsAPP.blackLetter),
                    ),
                    Text(
                      product.brandProvider?.brand?.brand??'',
                      style: TextStyle(
                          fontSize: 11,
                          fontFamily: Strings.fontRegular,
                          color: CustomColorsAPP.gray7),
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
                          color: CustomColorsAPP.blueSplash,
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
  );
}