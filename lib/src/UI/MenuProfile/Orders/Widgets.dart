import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wawamko/src/Models/Order.dart';
import 'package:wawamko/src/Models/Order/OrderDeatil.dart';
import 'package:wawamko/src/Models/Order/PackageProvider.dart';
import 'package:wawamko/src/Models/Order/ProductProvider.dart';
import 'package:wawamko/src/Models/Order/Seller.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/Constants.dart';
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

Widget itemProductsProvider(PackageProvider providerPackage,bool isActive,Function qualification,Function openChat) {
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
                Strings.subOrder +" ${ providerPackage?.id.toString()}",
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
                    providerPackage?.status??'',
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
                    providerPackage?.providerProduct?.businessName??'',
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
              Visibility(
                visible: isActive,
                child: InkWell(
                  onTap: ()=>qualification(Constants.qualificationProvider,providerPackage?.providerProduct?.id.toString(),providerPackage?.id.toString()),
                  child: Row(
                    children: [
                      Image.asset("Assets/images/ic_star.png", width: 15,color: CustomColors.gray5,),
                      SizedBox(width: 5,),
                      Text(
                       Strings.qualification,
                        style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            fontSize: 13,
                            color: CustomColors.blue),
                      ),
                      SizedBox(width: 5,),
                      Icon(Icons.arrow_forward_ios_rounded,color: CustomColors.blue,size: 15,)
                    ],
                  ),
                ),
              )
            ],
          ),
          customDivider(),
          listProducts(providerPackage,providerPackage?.productsProvider,isActive,qualification),
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
                formatMoney(providerPackage?.shippingValue??'0'),
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
                formatMoney(providerPackage?.total??'0'),
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blackLetter
                ),
              ),
            ],
          ),
          customDivider(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: btnCustom(double.infinity,Strings.btnCancel, CustomColors.pink
                      ,Colors.white, null),
                ),
                SizedBox(width: 30,),
                Expanded(
                  child: btnCustomIconLeft("ic_chat.png", Strings.chat,CustomColors.blue,
                      Colors.white, (){
                    openChat(providerPackage?.providerProduct?.id.toString(),providerPackage?.id.toString());
                      }),
                )
              ],
            ),
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

Widget itemProduct(PackageProvider providerPackage,ProductProvider product, bool isActive,Function qualification){
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
          ),
          Visibility(
            visible: isActive,
              child: InkWell(
                  onTap: ()=>qualification(Constants.qualificationProduct,product?.reference?.id.toString(),providerPackage?.id.toString(),product?.reference?.images[0].url),
                  child: Image.asset("Assets/images/ic_star.png", width: 20,color: CustomColors.gray5,))),
        ],
      ),
      customDivider()
    ],
  );
}

Widget itemProductOffer(PackageProvider providerPackage,ProductProvider product, bool isActive,Function qualification){
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
                  image: NetworkImage(product?.offerOrder?.baseProducts[0].reference.images[getRandomPosition(product?.offerOrder?.baseProducts[0].reference.images.length)].url),
                  placeholder: AssetImage("Assets/images/spinner.gif"),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product?.offerOrder?.baseProducts[0].reference.brandAndProduct?.brandProvider?.brand?.brand??'',
                  style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 12,
                    color: CustomColors.gray7,
                  ),
                ),
                Text(
                  product?.offerOrder?.baseProducts[0].reference.reference??''+product?.qty,
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
          ),
        ],
      ),
      customDivider()
    ],
  );
}


Widget listProducts(PackageProvider providerPackage,List<ProductProvider> productsProvider,bool isActive,Function qualification) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: productsProvider==null?0:productsProvider.length,
      itemBuilder: (_, int index) {
        if(productsProvider[index].reference != null){
          return itemProduct(providerPackage,productsProvider[index],isActive,qualification);
        }else {
          return itemProductOffer(providerPackage,productsProvider[index],isActive,qualification);
        }
      },
    ),
  );
}

Widget sectionSeller(OrderDetail order,Seller seller,Function qualification,bool isActive,Function openChat){
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
                Visibility(
                  visible: isActive,
                  child: InkWell(
                    onTap: ()=>qualification(Constants.qualificationSeller,seller.id.toString(),order.id.toString(),seller?.photoUrl??''),
                    child: Row(
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
                    ),
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: ()=>openChat(seller.id.toString(),order.id.toString()),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: CustomColors.orange,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset("Assets/images/ic_chat.png"),
              ),
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