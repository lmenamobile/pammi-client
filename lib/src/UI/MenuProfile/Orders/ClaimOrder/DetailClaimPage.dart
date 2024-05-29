import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Models/Claim/DetailClaim.dart' as d;
import 'package:wawamko/src/Providers/ProviderChat.dart';
import 'package:wawamko/src/Providers/ProviderClaimOrder.dart';
import 'package:wawamko/src/Providers/SocketService.dart';
import 'package:wawamko/src/UI/Chat/ChatPage.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/WidgetsClaim.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/ExpansionWidget.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import 'CloseClaimPage.dart';

class DetailClaimPage extends StatefulWidget {
  final String idClaim;

  const DetailClaimPage({required this.idClaim});

  @override
  _DetailClaimPageState createState() => _DetailClaimPageState();
}

class _DetailClaimPageState extends State<DetailClaimPage> {
  late ProviderClaimOrder providerClaimOrder;
  late ProviderChat providerChat;
  late SocketService socketService;
  final prefs = SharePreference();

  @override
  void initState() {
    providerClaimOrder =
        Provider.of<ProviderClaimOrder>(context, listen: false);
    getDetailClaim(widget.idClaim);
    super.initState();
  }

  openChatProvider(String providerId,String subOrderId){
    getRoomProvider(providerId, subOrderId);
  }

  openChatAdmin(){
    getRoomSupport(context);
  }

  getRoomSupport(BuildContext context) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callChat = providerChat.getRomAdmin();
        await callChat.then((id) async {
          if(socketService.serverStatus!=ServerStatus.Online){
            socketService.connectSocket(Constants.typeAdmin, id,"");
          }
          Navigator.push(context, customPageTransition(ChatPage(roomId: id, typeChat: Constants.typeAdmin,imageProfile: Constants.profileAdmin,fromPush: false),
          PageTransitionType.rightToLeftWithFade));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }



  getRoomProvider(String providerId,String subOrderId) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callChat = providerChat.getRomProvider(subOrderId, providerId);
        await callChat.then((id) {
          if(socketService.serverStatus!=ServerStatus.Online){
            socketService.connectSocket(Constants.typeProvider, id,subOrderId);
          }
          Navigator.push(context, customPageTransition(ChatPage(roomId:id ,subOrderId:subOrderId,typeChat: Constants.typeProvider,imageProfile: Constants.profileProvider,fromPush: false),
              PageTransitionType.rightToLeftWithFade));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    providerClaimOrder = Provider.of<ProviderClaimOrder>(context);
    providerChat = Provider.of<ProviderChat>(context);
    socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [

                  headerView( Strings.orderId + " ${providerClaimOrder.detailClaim?.id ?? ''}", () => Navigator.pop(context)),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: sectionProvider(providerClaimOrder.detailClaim ?? d.DetailClaim(),openChatProvider),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
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
                            child: ExpansionWidget(
                              initiallyExpanded: true,
                              iconColor: CustomColorsAPP.gray7,
                              title: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: Offset(0, 2), // changes position of shadow
                                      ),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Strings.claim,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: Strings.fontBold,
                                            color: CustomColorsAPP.blackLetter),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 50),
                                        decoration: BoxDecoration(
                                            color: getStatusColorClaim(providerClaimOrder.detailClaim?.state ?? ''),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          child: Text(getStatusClaim(providerClaimOrder.detailClaim?.state ?? ''),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: Strings.fontRegular),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      itemDescriptionDetailClaim(Strings.claimCreate,
                                          formatDate(providerClaimOrder.detailClaim?.optionsDates?.createdAt ?? DateTime.now(), 'd MMMM yyyy hh:mm a', 'es_CO')),
                                      Visibility(
                                          visible: providerClaimOrder.detailClaim?.closeDate == null ? false : true,
                                          child: itemDescriptionDetailClaim(
                                              Strings.claimFinish, formatDate(providerClaimOrder.detailClaim?.closeDate ?? DateTime.now(), 'd MMMM yyyy hh:mm a', 'es_CO'))),
                                      Visibility(
                                        visible: getStatusClaim(providerClaimOrder.detailClaim?.state??'')!='Cerrado'?true:false,
                                        child: Center(
                                          child: Container(
                                              margin: EdgeInsets.symmetric(vertical: 30),
                                              child: btnCustom(200, Strings.closeClaim,CustomColorsAPP.green,
                                                  Colors.white,(){
                                                    openCloseClaim(providerClaimOrder.detailClaim?.id ?? '');
                                                  })),
                                        ),
                                      ),
                                      customDivider(),
                                      itemDescription(
                                          Strings.claimType, utils.getLtsTypeClaim.firstWhere((element) =>
                                                      element.valueTypeClaim == providerClaimOrder.detailClaim?.type).typeClaim ?? ''),
                                      itemDescription(
                                          Strings.reason,
                                          utils.getLtsTypeReason.firstWhere((element) =>
                                                      element.valueTypeReason == providerClaimOrder.detailClaim?.reasonOpen).typeReason ?? ''),
                                      Text(
                                        Strings.comment,
                                        style: TextStyle(
                                            fontFamily: Strings.fontBold,
                                            color: CustomColorsAPP.blueTitle),
                                      ),
                                      Text(
                                        providerClaimOrder.detailClaim?.message ?? '',
                                        style: TextStyle(
                                            fontFamily: Strings.fontRegular,
                                            color: CustomColorsAPP.grayTwo),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        Strings.image,
                                        style: TextStyle(
                                            fontFamily: Strings.fontBold,
                                            color: CustomColorsAPP.blueTitle),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: CustomColorsAPP.blue),
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: ()=>launch(providerClaimOrder.detailClaim?.image??''),
                                            child: Row(
                                              children: [
                                                Icon(Icons.image_rounded, color: CustomColorsAPP.blue,),
                                                Expanded(
                                                  child : Text(
                                                    "File.jpg",
                                                    style: TextStyle(
                                                        fontFamily: Strings.fontBold,
                                                        color: CustomColorsAPP.blue),
                                                  ),
                                                ),
                                                Icon(Icons.arrow_circle_down, color: CustomColorsAPP.blue,),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        Strings.devolutionClaim,
                                        style: TextStyle(
                                            fontFamily: Strings.fontBold,
                                            color: CustomColorsAPP.blueTitle),
                                      ),
                                      Text(
                                        utils.getLtsMethodDevolution.firstWhere((element) =>
                                                    element.valueMethodDevolution! == providerClaimOrder.detailClaim?.methodDevolution!).methodDevolution ?? '',
                                        style: TextStyle(
                                            fontFamily: Strings.fontRegular,
                                            color: CustomColorsAPP.grayTwo),
                                      ),
                                      getCardByStatusClaim(providerClaimOrder.detailClaim?.state ?? '',providerClaimOrder.detailClaim?.reasonClose??'',openChatAdmin),
                                      Visibility(
                                        visible: (providerClaimOrder.detailClaim!.guide!.isEmpty&&(getStatusClaim(providerClaimOrder.detailClaim?.state ?? '')== Constants.approved))?true:false,
                                          child: sectionDataGuide()),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          sectionProduct()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: providerClaimOrder.isLoading,
                  child: LoadingProgress()),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionProduct(){
    return Container(
      margin: EdgeInsets.only(bottom: 15),
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
      child: ExpansionWidget(
        initiallyExpanded: true,
        iconColor: CustomColorsAPP.gray7,
        title: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              Strings.products,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: Strings.fontBold,
                  color: CustomColorsAPP.blackLetter),
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: itemProductClaim(providerClaimOrder.detailClaim!.orderPackageDetail!),
          )
        ],
      ),
    );
  }



  getDetailClaim(String id) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callClaim = providerClaimOrder.getClaimDetail(id);
        await callClaim.then((product) {}, onError: (error) {
          Navigator.pop(context);
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  openCloseClaim(String id){
    print("id de la orden $id");
    Navigator.push(context, customPageTransition(CloseClaimPage(idPackage: id),PageTransitionType.rightToLeftWithFade));
  }
}
