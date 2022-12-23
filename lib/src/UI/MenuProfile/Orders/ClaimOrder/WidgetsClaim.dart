
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Claim/Claim.dart';
import 'package:wawamko/src/Models/Claim/DetailClaim.dart' as data;
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

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
                itemDescription(Strings.claimCreate, formatDate(claimOpen.optionsDates?.createdAt??DateTime.now(), 'd MMMM yyyy hh:mm a', 'es_CO')),
                claimOpen.closeDate==null?Container():itemDescription(Strings.claimFinish, formatDate(claimOpen.closeDate??DateTime.now(), 'd MMMM yyyy hh:mm a', 'es_CO')),
                customDivider(),
              claimOpen.reasonClose==""?Container():
                   itemDescription(Strings.reasonClose,utils.getLtsReasonCloseByPamii.firstWhere((element) => element.valueReason! ==claimOpen.reasonClose!).reasonClose??''),


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

Widget itemDescriptionDetailClaim(String text, String value) {
  return Container(
    margin: EdgeInsets.only(bottom: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.access_time,color: CustomColors.blueTitle,),
        SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text,
                style: TextStyle(
                    color: CustomColors.blackLetter,
                    fontFamily: Strings.fontRegular)),
            Text(
              value,
              style: TextStyle(
                  fontFamily: Strings.fontBold, color: CustomColors.blueTitle),
            )
          ],
        )
      ],
    ),
  );
}

Widget itemProductClaim(data.OrderPackageDetail detail){
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
                child: detail.reference!.images!.isEmpty?Image.asset("Assets/images/spinner.gif"):
                isImageYoutube(detail.reference?.images?[0].url??'',FadeInImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(detail.reference?.images?[0].url??''),
                  placeholder: AssetImage("Assets/images/spinner.gif"),
                )),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.nameProduct??'',
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 13,
                    color: CustomColors.blackLetter,
                  ),
                ),
                Text(
                  formatMoney(detail.price??''),
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 13,
                    color: CustomColors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 10,),
      Row(
        children: [
          Expanded(
            child: DataTable(
              checkboxHorizontalMargin: 0.0,
              horizontalMargin: 0.0,
              columnSpacing: 15,
              dataRowHeight: 25,
              headingRowHeight: 25,
              headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => CustomColors.greyBackground
              ),
              columns: <DataColumn>[
                DataColumn(label:    Center(
                  child: Text(Strings.quantity,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Strings.fontBold,
                      fontSize: 13,
                      color: CustomColors.blueTitle,
                    ),
                  ),
                ),),
                DataColumn(label:    Text(Strings.warranty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 13,
                    color: CustomColors.blueTitle,
                  ),
                ),),
                DataColumn(label:    Text(Strings.total,
                  style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 13,
                    color: CustomColors.blueTitle,
                  ),
                ),),
              ],
              rows: [DataRow(cells: <DataCell>[
                cellTableText(detail.qty??'0',CustomColors.blackLetter),
                cellTableText(detail.reference?.brandAndProduct?.warranty?.warrantyProduct??'',CustomColors.blackLetter),
                cellTableText( formatMoney(detail.total??'0'),CustomColors.orange),
              ])],
            ),
          ),
        ],
      ),

    ],
  );
}

DataCell cellTableText(String text,Color color) {
  return DataCell(
      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontFamily: Strings.fontBold,
            fontSize: 13,
            color: color,
          ),
        ),
      )
  );
}

Widget sectionDataGuide(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
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
            Text(Strings.guideDevolution,
              style: TextStyle(
                fontFamily: Strings.fontBold,
                color: CustomColors.blueTitle,
              ),
            ),
            SizedBox(height: 10,),
            Text(Strings.textGuideDevolution,
              style: TextStyle(
                fontFamily: Strings.fontRegular,
                color: CustomColors.blackLetter,
              ),
            )
          ],
        ),
      ),
    );
}

Widget sectionProvider(data.DetailClaim claim){
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
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(claim.orderPackageDetail?.reference?.brandAndProduct?.warranty?.provider?.businessName??'',
                style: TextStyle(
                  fontFamily: Strings.fontBold,
                  color: CustomColors.blackLetter,
                ),
              ),
              Text(Strings.provider,
                style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  color: CustomColors.blackLetter,
                ),
              )
            ],
          ),
          Container(
            width: 150,
            child: btnCustomIconLeft("ic_chat.png", Strings.chat,CustomColors.blue,
                Colors.white, (){

                }),
          )
        ],
      ),
    ),
  );
}

Widget btnMakeClaim(){
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CustomColors.red)
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        Strings.makeClaim,
        style: TextStyle(
          fontFamily: Strings.fontBold,
          fontSize: 13,
          color: CustomColors.red,
        ),
      ),
    ),
  );
}

Widget btnNotMakeClaim(BuildContext context, String message){
  return InkWell(
    onTap: ()=>utils.showSnackBar(context, message),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color:CustomColors.gray4)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          Strings.makeClaim,
          style: TextStyle(
            fontFamily: Strings.fontBold,
            fontSize: 13,
            color:CustomColors.gray4,
          ),
        ),
      ),
    ),
  );
}

Widget noApplyClaim(){
  return Text(
    Strings.noApplyClaim,
    style: TextStyle(
      fontFamily: Strings.fontBold,
      fontSize: 13,
      color: CustomColors.gray4,
    ),
  );
}

Widget claimNotCheck(String title, String description){
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
      color: CustomColors.gray2,
        borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: Strings.fontBold,
              color: CustomColors.blueTitle,
            ),
          ),
          SizedBox(height: 10,),
          Text(
            description,
            style: TextStyle(
              fontFamily: Strings.fontRegular,
              color: CustomColors.gray4,
            ),
          ),
          SizedBox(height: 10,),
          btnCustom(150, Strings.serviceClient,CustomColors.blueTitle, Colors.white, null)
        ],
      ),
    ),
  );
}
