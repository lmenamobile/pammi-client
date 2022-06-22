
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Claim/Claim.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';

Widget itemReasonClaim(String label,String labelSelected){
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      boxShadow: [
        BoxShadow(
          color: label!=labelSelected?Colors.grey.withOpacity(0.2):CustomColors.blue.withOpacity(.3),
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.black, fontFamily: Strings.fontMedium,fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget headerClaim(String title,String subtitle){
  return Container(
    width: double.infinity,
    height: 180,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10
            )
        )
    ),
    child: Center(
      child: Column(
        mainAxisSize:MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
                color: CustomColors.blackLetter, fontFamily: Strings.fontMedium,fontSize: 16),
          ),
          Text(
            subtitle,
            style: TextStyle(
                color: CustomColors.blue, fontFamily: Strings.fontMedium,fontSize: 16),
          ),
        ],
      ),
    ),
  );
}

Widget buttonNext(){
  return Container(
    decoration: BoxDecoration(
        color: CustomColors.blue,
      borderRadius: BorderRadius.all(Radius.circular(8))
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
      child: Icon(Icons.arrow_forward,color: Colors.white,),
    ),
  );
}

Widget itemClaimOPen(Claim claimOpen, Function closeClaim, Function detailClaim) {
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
                      Strings.ID + " ${claimOpen.id??0}",
                      style: TextStyle(
                          color: CustomColors.blue,
                          fontFamily: Strings.fontBold),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: getStatusColorClaim(claimOpen.state??''),
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Text(
                              getStatusClaim(claimOpen.state??''),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: Strings.fontRegular),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        InkWell(
                          onTap: ()=>detailClaim(claimOpen.id.toString()),
                          child: Container(
                            decoration: BoxDecoration(
                                color: CustomColors.orangeOne,
                                borderRadius: BorderRadius.all(Radius.circular(4))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              child: Icon(Icons.arrow_forward_rounded,color: Colors.white,),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
                customDivider(),
                itemDescription(Strings.claimType,utils.getLtsTypeClaim.firstWhere((element) => element.valueTypeClaim! ==claimOpen.type!).typeClaim??''),
                itemDescription(Strings.reason,utils.getLtsTypeReason.firstWhere((element) => element.valueTypeReason! ==claimOpen.reasonOpen!).typeReason??''),
                itemDescription(Strings.claimCreate, formatDate(claimOpen.optionsDates?.createdAt??DateTime.now(), 'd MMMM yyyy', 'es_CO')),
                customDivider(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: InkWell(
                      onTap: ()=>closeClaim(claimOpen.id.toString()),
                      child: Text(
                        Strings.closeClaim,
                        style: TextStyle(
                            fontFamily: Strings.fontBold, color: CustomColors.redTwo),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.total,
                style: TextStyle(
                    fontFamily: Strings.fontBold, color: CustomColors.blue),
              ),
              Text(
                formatMoney(claimOpen.orderPackageDetail?.total??'0'),
                style: TextStyle(
                    fontFamily: Strings.fontBold, color: CustomColors.blue),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget itemDescription(String text, String value) {
  return Container(
    margin: EdgeInsets.only(bottom: 5),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
            style: TextStyle(
                color: CustomColors.blackLetter,
                fontFamily: Strings.fontRegular)),
        Text(
          value,
          style: TextStyle(
              fontFamily: Strings.fontBold, color: CustomColors.grayTwo),
        )
      ],
    ),
  );
}

Widget itemClaimClose(Claim claimOpen) {
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
                      Strings.ID + " ${claimOpen.id??0}",
                      style: TextStyle(
                          color: CustomColors.blue,
                          fontFamily: Strings.fontBold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: CustomColors.orangeOne,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Icon(Icons.arrow_forward_rounded,color: Colors.white,),
                      ),
                    ),
                  ],
                ),
                customDivider(),
                itemDescription(Strings.claimType,utils.getLtsTypeClaim.firstWhere((element) => element.valueTypeClaim! ==claimOpen.type!).typeClaim??''),
                itemDescription(Strings.reason,utils.getLtsTypeReason.firstWhere((element) => element.valueTypeReason! ==claimOpen.reasonOpen!).typeReason??''),
                customDivider(),
                itemDescription(Strings.claimCreate, formatDate(claimOpen.optionsDates?.createdAt??DateTime.now(), 'd MMMM yyyy', 'es_CO')),
                itemDescription(Strings.claimFinish, formatDate(claimOpen.closeDate??DateTime.now(), 'd MMMM yyyy', 'es_CO')),
                customDivider(),
                itemDescription(Strings.reasonClose,utils.getLtsReasonClose.firstWhere((element) => element.valueReason! ==claimOpen.reasonClose!).reasonClose??''),


              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.total,
                style: TextStyle(
                    fontFamily: Strings.fontBold, color: CustomColors.blue),
              ),
              Text(
                formatMoney(claimOpen.orderPackageDetail?.total??'0'),
                style: TextStyle(
                    fontFamily: Strings.fontBold, color: CustomColors.blue),
              )
            ],
          ),
        )
      ],
    ),
  );
}