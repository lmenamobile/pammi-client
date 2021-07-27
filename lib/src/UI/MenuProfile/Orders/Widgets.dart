import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Order.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';


Widget  itemOrder(Order order){
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
                    Text(Strings.orderId+" ${order?.id}",
                    style: TextStyle(
                      color: CustomColors.blue,
                      fontFamily: Strings.fontBold
                    ),),
                    Container(
                      decoration: BoxDecoration(
                        color: CustomColors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(4))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                        child: Text("Estado",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: Strings.fontRegular
                          ),),
                      ),
                    ),
                  ],
                ),
                customDivider(),
                itemDescription(Icons.access_time, Strings.orderDateRequest, "20 Agost 21"),
                SizedBox(height: 5,),
                itemDescription(Icons.add_shopping_cart,Strings.valueOrder, formatMoney("20000")),
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
                    fontFamily: Strings.fontBold,
                    color: CustomColors.blue
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    child: FadeInImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(""),
                      placeholder: AssetImage("Assets/images/spinner.gif"),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: CustomColors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_forward_outlined,color: Colors.white,size: 20,),
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

Widget itemDescription(IconData icon,String text,String price){
  return  Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,color: CustomColors.blue,size: 20,),
          SizedBox(width: 5,),
          Text(text,
              style: TextStyle(
                  color: CustomColors.blackLetter,
                  fontFamily: Strings.fontRegular
              )
          ),
        ],
      ),
      Text(
        price,
        style: TextStyle(
            fontFamily: Strings.fontBold,
            color: CustomColors.blackLetter
        ),
      )
    ],
  );
}