import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Offer.dart';
import 'package:wawamko/src/Models/Product/ProductOffer.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget itemOfferUnits(Offer offer) {
  return Container(
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
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              itemImageOffer(offer?.baseProducts[getRandomPosition(offer?.baseProducts?.length??0)].reference.images[0].url),
              itemImageOffer(offer?.promotionProducts[getRandomPosition(offer?.promotionProducts?.length??0)].reference.images[0].url)],
          ),
          customDivider(),
          Text(
            offer?.name??'',
            style: TextStyle(
              fontFamily: Strings.fontBold,
              color: CustomColors.blackLetter
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              itemDescriptionOffer(Strings.products, offer?.baseProducts),
              itemDescriptionOffer(Strings.productsGift, offer?.promotionProducts)
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
    children: [
      Text(
        description,
        style: TextStyle(
            fontFamily: Strings.fontBold,
            color: CustomColors.gray7
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: ltsProducts.isEmpty?0:ltsProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return charactersOffers(ltsProducts[index].reference);
        },
      )
    ],
  );
}

Widget charactersOffers(Reference reference){
  return Column(
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
            color: CustomColors.gray7
        ),
      ),
    ],
  );
}
