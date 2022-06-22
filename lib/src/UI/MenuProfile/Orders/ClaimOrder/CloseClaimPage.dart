import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Claim/ReasonClose.dart';
import 'package:wawamko/src/Models/Order/MethodDevolution.dart';
import 'package:wawamko/src/Models/Claim/TypeClaim.dart';
import 'package:wawamko/src/Models/Claim/TypeReason.dart';
import 'package:wawamko/src/Providers/ProviderClaimOrder.dart';
import 'package:wawamko/src/UI/Home/HomePage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/MyClaimPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/WidgetsClaim.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Utils/utilsPhoto/image_picker_handler.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class CloseClaimPage extends StatefulWidget {
  final String idPackage;

  const CloseClaimPage({required this.idPackage});
  @override
  _CloseClaimPageState createState() => _CloseClaimPageState();
}

class _CloseClaimPageState extends State<CloseClaimPage> {
  late ProviderClaimOrder providerClaimOrder;


  @override
  void initState() {
    providerClaimOrder = Provider.of<ProviderClaimOrder>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    providerClaimOrder = Provider.of<ProviderClaimOrder>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: Stack(
            children: [
              Column(
                children: [
                  titleBar(
                      Strings.claim, "ic_back.png", () =>Navigator.pop(context)),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      Strings.becauseReasonClose,
                      style: TextStyle(
                          color: CustomColors.blue, fontFamily: Strings.fontMedium,fontSize: 16),
                    ),
                  ),
                  Expanded(child: SingleChildScrollView(child: listReasonClose())),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: btnCustom(200, Strings.closeClaim,CustomColors.blue,
                        Colors.white,(){
                          providerClaimOrder.reasonCloseSelected==null?
                          utils.showSnackBar(context, Strings.errorReasonClaim)
                              :closeClaim(widget.idPackage);
                        })),

                ],
              ),
              Visibility(
                  visible: providerClaimOrder.isLoading, child: LoadingProgress())
            ],
          ),
        ),
      ),
    );
  }

  Widget listReasonClose() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: NeverScrollableScrollPhysics(),
        itemCount: utils.getLtsReasonClose.length,
        itemBuilder: (_, int index) {
          return InkWell(
              onTap: () => selectReasonClaim(
                  utils.getLtsReasonClose.elementAt(index)),
              child: itemReasonClaim(
                  utils.getLtsReasonClose.elementAt(index).reasonClose ?? '',
                  providerClaimOrder.reasonCloseSelected?.reasonClose ?? ''));
        },
      ),
    );
  }

  selectReasonClaim(ReasonClose reasonClose) {
    providerClaimOrder.selectReasonClose = reasonClose;
  }

  closeClaim(String id) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callClaim = providerClaimOrder.closeClaim(id, providerClaimOrder.reasonCloseSelected?.valueReason??'');
        await callClaim.then((list) async{
          var state = await startAlertCustomImage(context,Strings.reasonCloseApproved,Strings.messageClosereason,"ic_correct.png");
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage()), (Route<dynamic> route) => false);
          Navigator.push(context, customPageTransition(MyClaimPage()));
        }, onError: (error) {
           utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }



}
