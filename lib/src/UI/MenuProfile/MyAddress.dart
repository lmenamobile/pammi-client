import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Address.dart';
import 'package:wawamko/src/Models/Address/GetAddress.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/UserProvider.dart';
import 'package:wawamko/src/UI/addAddress.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class MyAddressPage extends StatefulWidget {
  @override
  _MyAddressPageState createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  List<Address> addresses = [];
  bool loading = true;
  late ProviderCheckOut providerCheckOut;
  late ProviderSettings providerSettings;

  @override
  void initState() {
    serviceGetAddAddressUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: <Widget>[
        titleBar(Strings.myAddress, "ic_blue_arrow.png",
            () => Navigator.pop(context)),
        SizedBox(
          height: 20,
        ),
        Container(
          child:providerSettings.hasConnection
              ? !this.loading
                  ? this.addresses.isEmpty
                      ? Expanded(
                          child: emptyDataWithAction(
                              "ic_receive.png",
                              Strings.questionAddress,
                              Strings.beginAddAddress,
                              Strings.addAddres,
                              () => openAddAddress()),
                        )
                      : SingleChildScrollView(
                        child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                width: double.infinity,
                                child: ListView.builder(
                                    itemCount: this.addresses.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return itemAddress(
                                          this.addresses[index],
                                          () {
                                            serviceChangeAddressUser(this.addresses[index]);
                                          },
                                          () {
                                            selectAddress(this.addresses[index]);
                                          });
                                    }),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 70, right: 60),
                                child: btnCustomRounded(CustomColors.blueSplash,
                                    CustomColors.white, Strings.addAddres, () {
                                  pushToAddAddress();
                                }, context),
                              ),
                              SizedBox(height: 25),
                            ],
                          ),
                      )
                  : Container()
              : notConnectionInternet(),
        ),
      ],
    );
  }

  serviceGetAddAddressUser() async {
    this.addresses = [];
    utils.checkInternet().then((value) async {
      if (value) {

        utils.startProgress(context);
        Future callResponse = UserProvider.instance.getAddress(context, 0);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          GetAddressResponse data = GetAddressResponse.fromJson(decodeJSON);

          if (data.status!) {
            for (var address in data.data!.addresses!) {
              this.addresses.add(address);
            }
            Navigator.pop(context);
            setState(() {});
          } else {
            Navigator.pop(context);
            setState(() {});
          }

          loading = false;
        }, onError: (error) {
          print("Ocurrio un error: $error");
          loading = false;
          Navigator.pop(context);
        });
      } else {

        setState(() {});
        //utils.showSnackBarError(context,Strings.loseInternet);
      }
    });
  }

  serviceChangeAddressUser(Address address) async {
    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callResponse =
            UserProvider.instance.changeStatusAddress(context, address);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          ChangeStatusAddressResponse data =
              ChangeStatusAddressResponse.fromJson(decodeJSON);

          if (data.status!) {
            Navigator.pop(context);
            utils.showSnackBarGood(context, data.message!);
            serviceGetAddAddressUser();
          } else {
            Navigator.pop(context);
            setState(() {});
            utils.showSnackBarError(context, data.message);
          }
        }, onError: (error) {
          print("Ocurrio un error: $error");

          Navigator.pop(context);
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  openAddAddress() async {
    dynamic data = await Navigator.push(context, customPageTransition(AddAddressPage()));
    if (data as bool) {
      serviceGetAddAddressUser();
    }
  }

  pushToAddAddress() async {
    var data = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight,
            child: AddAddressPage(),
            duration: Duration(milliseconds: 500)));
    if (data) {
      this.loading = true;
      serviceGetAddAddressUser();
    }
  }

  pushToUpdateAddAddress(Address address) async {
    var data = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight,
            child: AddAddressPage(flagAddress: "update", address: address),
            duration: Duration(milliseconds: 500)));
    if (data) {
      if (data) {
        serviceGetAddAddressUser();
        utils.showSnackBarGood(context, Strings.updateAddress);
      }
    }
  }

  selectAddress(Address address){
      providerCheckOut.addressSelected = address;
      Navigator.pop(context,true);
  }
}
