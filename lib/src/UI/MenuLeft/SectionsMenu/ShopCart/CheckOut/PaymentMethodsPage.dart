import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/PaymentMethod.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class PaymentMethodsPage extends StatefulWidget {
  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  late ProviderCheckOut providerCheckOut;
  late ProviderSettings providerSettings;

  @override
  void initState() {
    providerCheckOut = Provider.of<ProviderCheckOut>(context,listen: false);
    getLtsPaymentMethods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              //titleBar(Strings.paymentMethods, "ic_blue_arrow.png", () => Navigator.pop(context)),
              header(context, Strings.paymentMethods, CustomColors.redDot, () => Navigator.pop(context)),
              Expanded(child: providerSettings.hasConnection?listPayments():notConnectionInternet())

            ],
          ),
        ),
      ),
    );
  }

  Widget itemPayment(PaymentMethod payment,Function selectedPayment){
    return InkWell(
      onTap: (){
        selectedPayment(payment);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: CustomColors.gray10)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 50,
                height: 50,
               child: SvgPicture.network(payment.image!),
              ),
              SizedBox(width: 15,),
              Expanded(
                child: Text(
                  payment.methodPayment!,
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 16,
                      color: CustomColors.blackLetter
                  ),
                ),
              ),
              SizedBox(width: 15,),
              Container(
                decoration: BoxDecoration(
                  color: CustomColors.greyBorder,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_forward,color: CustomColors.gray7,size: 15,),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listPayments() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: ListView.builder(
        itemCount: providerCheckOut.ltsPaymentMethod.isEmpty?0:providerCheckOut.ltsPaymentMethod.length,
        itemBuilder: (_, int index) {
          return itemPayment(providerCheckOut.ltsPaymentMethod[index],selectedPayment);
        },
      ),
    );
  }

  selectedPayment(PaymentMethod payment){
    providerCheckOut.paymentSelected = payment;
    Navigator.pop(context);
  }

  getLtsPaymentMethods() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings = providerCheckOut.getPaymentMethods();
        await callSettings.then((list) {

        }, onError: (error) {
          //utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}