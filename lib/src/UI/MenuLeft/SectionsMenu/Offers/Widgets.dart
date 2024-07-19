import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Offer.dart';
import 'package:wawamko/src/Models/Product/ProductOffer.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../../../../features/feature_views_shared/domain/domain.dart';

Widget itemOfferUnits(Offer offer, Function addOffer,Function openDetail) {
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
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /*itemImageOffer(offer.baseProducts!.isNotEmpty?
                  offer.baseProducts![getRandomPosition(offer.baseProducts?.length??0)].reference!.images![0].url!:""),*/
              itemImageOffer((offer.baseProducts != null && offer.baseProducts!.isNotEmpty)
                  ? (offer.baseProducts!.length > 0
                  ? (offer.baseProducts![getRandomPosition(offer.baseProducts!.length)].reference?.images != null
                  ? (offer.baseProducts![getRandomPosition(offer.baseProducts!.length)].reference!.images!.isNotEmpty
                  ? offer.baseProducts![getRandomPosition(offer.baseProducts!.length)].reference!.images![0].url ?? ""
                  : "")
                  : "")
                  : "")
                  : ""),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                width: 1,
                height:120,
                color: AppColors.grayBackground,
              ),
              Stack(
                children: [
                  itemImageOffer(offer.promotionProducts![getRandomPosition(offer.promotionProducts?.length??0)].reference!.images![0].url!),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.redAccent,
                      child: Text(
                          offer.offerType=="units"?unitsDiscount(offer.baseProducts!, offer.promotionProducts!):percentDiscount(offer.discountValue!),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10
                        ),
                      ),
                    ),
                  )
                ],
              )],
          ),
          customDivider(),
          Text(
            offer.name??'',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              color: AppColors.blackLetter
            ),
          ),
          SizedBox(height: 2,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: itemDescriptionOffer(Strings.products, offer.baseProducts!,offer,true)),
              Expanded(child: itemDescriptionOffer(Strings.productsGift, offer.promotionProducts!,offer,false))
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
                    AppColors.blue,
                    Colors.white,
                    (){
                      addOffer(offer.id.toString());
                    }),
              ),
              InkWell(
                onTap: ()=>openDetail(offer),
                child: Text(
                  Strings.moreView,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                      fontFamily: Strings.fontBold,
                      color: AppColors.blue
                  ),
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
    height: 130,
    child: FadeInImage(
      fit: BoxFit.fill,
      image: NetworkImage(url),
      placeholder: AssetImage("Assets/images/spinner.gif"),
      imageErrorBuilder: (_,__,___){
        return Image.asset("Assets/images/spinner.gif");
      },
    ),
  );
}

Widget itemDescriptionOffer(String description,List<ProductOffer> ltsProducts,Offer offer,bool isBaseProducts){
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        description,
        style: TextStyle(
            fontFamily: Strings.fontBold,
            color: AppColors.gray7
        ),
      ),
      SizedBox(height: 2,),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: ltsProducts.isEmpty?0:ltsProducts.length>=1?1:ltsProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return isBaseProducts?charactersOffers(ltsProducts[index].reference!):charactersProductsOffers(ltsProducts[index].reference!, offer);
        },
      )
    ],
  );
}

Widget charactersProductsOffers(Reference reference,Offer offer){
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        reference.reference??'',
        style: TextStyle(
            fontSize: 13,
            fontFamily: Strings.fontBold,
            color: AppColors.blackLetter
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      Text(
        formatMoney(reference.price??'0'),
        style: TextStyle(
          decoration: TextDecoration.lineThrough,
            fontSize: 13,
            fontFamily: Strings.fontMedium,
            color: AppColors.gray
        ),
      ),
      Text(
        offer.offerType=="units"?formatMoney('0'):formatMoney(priceDiscount(reference.price??'0', offer.discountValue!)),
        style: TextStyle(
            fontSize: 13,
            fontFamily: Strings.fontMedium,
            color: AppColors.orange
        ),
      ),
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
            color: AppColors.blackLetter
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      Text(
        formatMoney(reference.price??'0'),
        style: TextStyle(
            fontSize: 13,
            fontFamily: Strings.fontMedium,
            color: AppColors.orange
        ),
      ),
    ],
  );
}

Widget itemBrandOffer(Brand brandSelected, Brand brand){
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
                color: brandSelected==brand?Colors.redAccent.withOpacity(.4): Colors.black38.withOpacity(0.2),
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
                image: (brand.image == "" ? AssetImage("Assets/images/spinner.gif") : NetworkImage(brand.image!)) as ImageProvider<Object>
            )
        )
    ),
  );
}



