
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Models/Order/PackageProvider.dart';
import 'package:wawamko/src/Providers/ProviderChat.dart';
import 'package:wawamko/src/Providers/ProviderOder.dart';
import 'package:wawamko/src/Providers/SocketService.dart';
import 'package:wawamko/src/UI/Chat/ChatPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/ClaimPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/QualificationOrder/QualificationPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/Widgets.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class DetailOrderPage extends StatefulWidget {
  final String idOrder;
  final bool isActiveOrder;
  final bool isOrderFinish;
  const DetailOrderPage({required this.idOrder, required this.isActiveOrder,required this.isOrderFinish});
  @override
  _DetailOrderPageState createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  ProviderOrder? providerOrder;
  late ProviderChat providerChat;
  late SocketService socketService;
  final prefs = SharePreference();

  @override
  void initState() {
    providerOrder = Provider.of<ProviderOrder>(context,listen: false);
    getDetailOrder(widget.idOrder);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerOrder = Provider.of<ProviderOrder>(context);
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
                  headerView( Strings.orderId+" ${providerOrder?.orderDetail?.id??''}",()=>Navigator.pop(context)),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          providerOrder?.orderDetail!=null? providerOrder!.orderDetail!.packagesProvider![0].providerProduct==null?listGiftCards():listProviders():Container(),
                          providerOrder?.orderDetail?.seller!=null?
                          sectionSeller(providerOrder!.orderDetail!.packagesProvider![0],providerOrder?.orderDetail,providerOrder?.orderDetail?.seller,openQualificationPage,widget.isActiveOrder,openChatSeller):
                          Container(),
                          sectionAddressOrder(providerOrder?.orderDetail?.shippingAddress??''),
                          sectionTotalOrder(providerOrder?.orderDetail),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: providerOrder!.isLoading, child: LoadingProgress()
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listProviders() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: NeverScrollableScrollPhysics(),
        itemCount: providerOrder?.orderDetail?.packagesProvider==null?0:providerOrder!.orderDetail!.packagesProvider!.length,
        itemBuilder: (_, int index) {
          return itemProductsProvider(context,providerOrder!.orderDetail!.packagesProvider![index],widget.isActiveOrder,widget.isOrderFinish,openQualificationPage,openChat,openGuide,openClaimOrder);
        },
      ),
    );
  }

  Widget listGiftCards() {
    return Container(
      width: 180,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: providerOrder?.orderDetail?.packagesProvider==null?0:providerOrder!.orderDetail!.packagesProvider![0].productsProvider!.length,
        itemBuilder: (_, int index) {
          return itemGift(providerOrder!.orderDetail!.packagesProvider![0].productsProvider![index].giftCard);
        },
      ),
    );
  }

   openQualificationPage(int optionView,String idQualification,String idSubOrder,String data,PackageProvider providerPackage)async{
    switch (optionView) {
      case 0:
        await saveImagesBrands(providerPackage);
        Navigator.push(context, customPageTransition(QualificationPage(optionView: optionView,idQualification: idQualification,subOrderId: idSubOrder,),
        PageTransitionType.fade)).
        then((value) => getDetailOrder(widget.idOrder));
        break;
      case 1:
        Navigator.push(context, customPageTransition(QualificationPage(optionView: optionView,idQualification: idQualification,subOrderId: idSubOrder,data: data,),
        PageTransitionType.fade)
        ).then((value) => getDetailOrder(widget.idOrder));
        break;
      case 2:
        Navigator.push(context, customPageTransition(QualificationPage(optionView: optionView,idQualification: idQualification,subOrderId: idSubOrder,data: data,),
        PageTransitionType.fade)).then((value) => getDetailOrder(widget.idOrder));
        break;

    }
  }
//String providerId,String suborderId
  openChat(String providerId,String suborderId){
    getRoomProvider(providerId, suborderId);
  }

  saveImagesBrands(PackageProvider providerPackage){
    providerOrder!.lstImagesBrands.clear();
    providerPackage.productsProvider!.forEach((element) {
      //providerOrder!.setImageBrand = element.reference!.brandAndProduct!.brandProvider!.brand!.image;
    });

  }

  openClaimOrder(String idPackage){
    print("id orden $idPackage");
    Navigator.push(context, customPageTransition(ClaimPage(idPackage: idPackage,),
    PageTransitionType.fade));
  }


  openChatSeller(String sellerId,String orderId, String imageSeller){
    getRoomSeller(sellerId, orderId,imageSeller);
  }

  openGuide(String guide){
    if(guide.isNotEmpty) {
      launch(Constants.urlGuide + "$guide");
    }else{
      utils.showSnackBar(context, Strings.errorNotGuideOrder);
    }
  }

  getDetailOrder(String idOrder) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callOrder = providerOrder!.getOrderDetail(idOrder);
        await callOrder.then((product) {

        }, onError: (error) {
          Navigator.pop(context);
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
          PageTransitionType.fade));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  getRoomSeller(String sellerId,String orderId,String imageSeller) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callChat = providerChat.getRomSeller(sellerId, orderId);
        await callChat.then((id) {
          if(socketService.serverStatus!=ServerStatus.Online){
            socketService.connectSocket(Constants.typeSeller, id,orderId);
          }
          Navigator.push(context, customPageTransition(ChatPage(roomId:id ,orderId: orderId,typeChat: Constants.typeSeller,imageProfile: imageSeller,fromPush: false),
          PageTransitionType.fade));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}