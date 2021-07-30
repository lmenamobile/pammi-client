import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProviderOder.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/QualificationOrder/QualificationPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class DetailOrderPage extends StatefulWidget {
  final String idOrder;
  final bool isActiveOrder;
  const DetailOrderPage({@required this.idOrder, @required this.isActiveOrder});
  @override
  _DetailOrderPageState createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  ProviderOrder providerOrder;

  @override
  void initState() {
    providerOrder = Provider.of<ProviderOrder>(context,listen: false);
    getDetailOrder(widget.idOrder);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerOrder = Provider.of<ProviderOrder>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  titleBar(Strings.orderId+" ${providerOrder?.orderDetail?.id??''}", "ic_back.png", () => Navigator.pop(context)),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          listProviders(),
                          providerOrder?.orderDetail?.seller!=null?
                          sectionSeller(providerOrder?.orderDetail,providerOrder?.orderDetail?.seller,openQualificationPage,widget.isActiveOrder):
                          Container(),
                          sectionAddressOrder(providerOrder?.orderDetail?.shippingAddress??''),
                          sectionTotalOrder(providerOrder?.orderDetail),
                          SizedBox(height: 15,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
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
                                      Colors.white, null),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: providerOrder.isLoading, child: LoadingProgress()),
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
        itemCount: providerOrder?.orderDetail?.packagesProvider==null?0:providerOrder.orderDetail.packagesProvider.length,
        itemBuilder: (_, int index) {
          return itemProductsProvider(providerOrder?.orderDetail?.packagesProvider[index],widget.isActiveOrder,openQualificationPage);
        },
      ),
    );
  }

  openQualificationPage(int optionView,String idQualification,String idSubOrder,String data){
    switch (optionView) {
      case 0:
        Navigator.push(context, customPageTransition(QualificationPage(optionView: optionView,idQualification: idQualification,subOrderId: idSubOrder,)));
        break;
      case 1:
        Navigator.push(context, customPageTransition(QualificationPage(optionView: optionView,idQualification: idQualification,subOrderId: idSubOrder,data: data,)));
        break;
      case 2:
        Navigator.push(context, customPageTransition(QualificationPage(optionView: optionView,idQualification: idQualification,subOrderId: idSubOrder,data: data,)));
        break;

    }
  }

  getDetailOrder(String idOrder) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callOrder = providerOrder.getOrderDetail(idOrder);
        await callOrder.then((product) {

        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}