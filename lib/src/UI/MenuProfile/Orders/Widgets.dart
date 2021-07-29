import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wawamko/src/Models/Order.dart';
import 'package:wawamko/src/Models/Order/OrderDeatil.dart';
import 'package:wawamko/src/Models/Order/PackageProvider.dart';
import 'package:wawamko/src/Models/Order/ProductProvider.dart';
import 'package:wawamko/src/Models/Order/Seller.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

Widget itemOrder(Order order) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: CustomColors.blueTwo,
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
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.orderId + " ${order?.id}",
                      style: TextStyle(
                          color: CustomColors.blue,
                          fontFamily: Strings.fontBold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: CustomColors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Text(
                          order?.status ?? '',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: Strings.fontRegular),
                        ),
                      ),
                    ),
                  ],
                ),
                customDivider(),
                itemDescription(Icons.access_time, Strings.orderDateRequest,
                    formatDate(order?.createdAt, 'd MMMM yyyy', 'es_CO')),
                SizedBox(
                  height: 5,
                ),
                itemDescription(Icons.add_shopping_cart, Strings.valueOrder,
                    formatMoney(order?.total)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.paymentMethod,
                style: TextStyle(
                    fontFamily: Strings.fontBold, color: CustomColors.blue),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    child: SvgPicture.network(order?.paymentMethod?.image),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: CustomColors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ))
                ],
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget itemDescription(IconData icon, String text, String price) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: CustomColors.blue,
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Text(text,
              style: TextStyle(
                  color: CustomColors.blackLetter,
                  fontFamily: Strings.fontRegular)),
        ],
      ),
      Text(
        price,
        style: TextStyle(
            fontFamily: Strings.fontBold, color: CustomColors.blackLetter),
      )
    ],
  );
}

Widget itemProductsProvider(PackageProvider provider) {
  return Container(
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
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.subOrder +" ${ provider?.id.toString()}",
                style: TextStyle(
                    color: CustomColors.blue, fontFamily: Strings.fontBold),
              ),
              Container(
                decoration: BoxDecoration(
                    color: CustomColors.blueSplash,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Text(
                    provider?.status??'',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: Strings.fontRegular),
                  ),
                ),
              ),
            ],
          ),
          customDivider(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider?.providerProduct?.businessName??'',
                    style: TextStyle(
                        fontFamily: Strings.fontBold,
                        fontSize: 15,
                        color: CustomColors.blackLetter),
                  ),
                  Text(
                    Strings.provider,
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 12,
                        color: CustomColors.gray7),
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,color: CustomColors.gray7,size: 15,),
                      SizedBox(width: 5,),
                      Text(
                        "Aca fecha de entrega",
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            fontSize: 12,
                            color: CustomColors.gray7),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                   Strings.qualification,
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 13,
                        color: CustomColors.blue),
                  ),
                ],
              )
            ],
          ),

          customDivider(),
          listProducts(provider?.productsProvider),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.priceSend,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: Strings.fontRegular,
                  color: CustomColors.gray7
                ),
              ),
              Text(
                formatMoney(provider?.shippingValue??'0'),
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.gray7
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.total,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blackLetter
                ),
              ),
              Text(
                formatMoney(provider?.total??'0'),
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blackLetter
                ),
              ),
            ],
          ),
          customDivider(),
          Align(
            alignment: Alignment.center,
              child: btnCustom(140, Strings.tracking,CustomColors.orange, Colors.white, null))
        ],
      ),
    ),
  );
}

Widget itemProduct(ProductProvider product){
  return Column(
    children: [
      Row(
        children: [
          Container(
            width: 110,
            child: Center(
              child: Container(
                width: 90,
                height: 90,
                child: FadeInImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(product?.reference?.images[getRandomPosition(product.reference.images.length)].url),
                  placeholder: AssetImage("Assets/images/spinner.gif"),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product?.reference?.brandAndProduct?.brandProvider?.brand?.brand??'',
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 12,
                    color: CustomColors.gray7,
                  ),
                ),
                Text(
                 product?.reference?.reference??''+product?.qty.toString(),
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 13,
                    color: CustomColors.blackLetter,
                  ),
                ),
                Text(
                  formatMoney(product?.price??''),
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 13,
                    color: CustomColors.orange,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      customDivider()
    ],
  );
}

Widget listProducts(List<ProductProvider> productsProvider) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: productsProvider==null?0:productsProvider.length,
      itemBuilder: (_, int index) {
        return itemProduct(productsProvider[index]);
      },
    ),
  );
}

Widget sectionSeller(Seller seller){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
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
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38.withOpacity(.4),
                      blurRadius: 7,
                      offset: Offset(2, 3))
                ]),
            child: Center(
              child: FadeInImage(
                height: 30,
                fit: BoxFit.fill,
                image: NetworkImage(seller?.photoUrl??''),
                placeholder: AssetImage("Assets/images/spinner.gif"),
              ),
            ),
          ),
          SizedBox(width: 15,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                 Strings.seller,
                  style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 15,
                    color: CustomColors.blackLetter,
                  ),
                ),
                Text(
                  seller?.fullName??'',
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: CustomColors.gray7,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      Strings.qualificationSeller,
                      style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        fontSize: 15,
                        color: CustomColors.blue,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Icon(Icons.arrow_forward_ios_rounded,color: CustomColors.blue,size: 20,)
                  ],
                )
              ],
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: CustomColors.orange,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset("Assets/images/ic_chat.png"),
            ),
          )
        ],
      ),
    ),
  );
}

Widget sectionAddressOrder(String address){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
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
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.addressDelivery,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 15,
              color: CustomColors.blackLetter,
            ),
          ),
          customDivider(),
          Text(
            address??'',
            style: TextStyle(
              fontFamily: Strings.fontRegular,
              fontSize: 15,
              color: CustomColors.gray7,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget sectionTotalOrder(OrderDetail order) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.detailTotalOrder,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              fontSize: 15,
              color: CustomColors.blackLetter,
            ),
          ),
          customDivider(),
          rowTotal(Strings.paymentMethod, order?.paymentMethod?.methodPayment??''),
          rowTotal(Strings.subtotal, formatMoney(order?.subtotal??'0')),
          rowTotal(Strings.send, formatMoney(order?.shippingValue??'0')),
          rowTotal(Strings.coupon, formatMoney(order?.discountCoupon??'0')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                Strings.valueOrder,
                style: TextStyle(
                  fontFamily: Strings.fontBold,
                  fontSize: 15,
                  color: CustomColors.blackLetter,
                ),
              ),
              Text(
                formatMoney(order?.total??'0'),
                style: TextStyle(
                  fontFamily: Strings.fontBold,
                  fontSize: 15,
                  color: CustomColors.orange,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget rowTotal(String textLabel,String textData ){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    children: [
      Text(
        textLabel,
        style: TextStyle(
          fontFamily: Strings.fontRegular,
          fontSize: 15,
          color: CustomColors.gray7,
        ),
      ),
      Text(
       textData,
        style: TextStyle(
          fontFamily: Strings.fontRegular,
          fontSize: 15,
          color: CustomColors.gray7,
        ),
      ),
    ],
  );
}