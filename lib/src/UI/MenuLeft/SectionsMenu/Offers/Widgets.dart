import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Offer.dart';
import 'package:wawamko/src/Models/Product/ProductOffer.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

Widget itemOfferUnits(Offer offer) {
  return Container(
    width: 310,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5)),
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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              itemImageOffer(offer?.baseProducts[getRandomPosition(offer?.baseProducts?.length??0)].reference.images[0].url),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                width: 1,
                height:120,
                color: CustomColors.grayBackground,
              ),
              itemImageOffer(offer?.promotionProducts[getRandomPosition(offer?.promotionProducts?.length??0)].reference.images[0].url)],
          ),
          customDivider(),
          Text(
            offer?.name??'',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              color: CustomColors.blackLetter
            ),
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: itemDescriptionOffer(Strings.products, offer?.baseProducts)),
              Expanded(child: itemDescriptionOffer(Strings.productsGift, offer?.promotionProducts))
            ],
          ),
          customDivider(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150,
                child: btnCustomIconLeft(
                    "ic_pay_add.png",
                    Strings.addCartShop,
                    CustomColors.blue,
                    Colors.white,
                    null),
              ),
              Text(
                Strings.moreView,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blue
                ),
              ),
            ],
          )

        ],
      ),
    ),
  );
}

Widget itemImageOffer(String url) {
  return Container(
    width: 130,
    child: FadeInImage(
      fit: BoxFit.fill,
      image: NetworkImage(url),
      placeholder: AssetImage("Assets/images/spinner.gif"),
    ),
  );
}

Widget itemDescriptionOffer(String description,List<ProductOffer> ltsProducts){
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        description,
        style: TextStyle(
            fontFamily: Strings.fontBold,
            color: CustomColors.gray7
        ),
      ),
      SizedBox(height: 8,),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: ltsProducts.isEmpty?0:ltsProducts.length>=1?1:ltsProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return charactersOffers(ltsProducts[index].reference);
        },
      )
    ],
  );
}

Widget charactersOffers(Reference reference){
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        reference.reference??'',
        style: TextStyle(
          fontSize: 13,
            fontFamily: Strings.fontBold,
            color: CustomColors.blackLetter
        ),
      ),
      Text(
        formatMoney(reference?.price??'0'),
        style: TextStyle(
            fontSize: 13,
            fontFamily: Strings.fontMedium,
            color: CustomColors.orange
        ),
      ),
    ],
  );
}

Widget itemBrandOffer(String url){
  return  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color:  Colors.black38.withOpacity(0.2),
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: Offset(
                  2.0,
                  2.0,
                ),
              )
            ],
            image: DecorationImage(
                fit: BoxFit.contain,
                image: url == "" ? AssetImage("Assets/images/spinner.gif") : NetworkImage(url)
            )
        )
    ),
  );
}



