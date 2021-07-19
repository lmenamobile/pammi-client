import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Address.dart';
import 'package:wawamko/src/Models/Address/GetAddress.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
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
  List<Address> addresses = List();
  bool loading = true;
  bool hasInternet = true;
  ProviderCheckOut providerCheckOut;

  @override
  void initState() {
    serviceGetAddAddressUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          child: hasInternet
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
                                    itemCount: this.addresses.length ?? 0,
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
              : Container(
                  child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height - 90,
                      child: notifyInternet(
                          "Assets/images/ic_img_internet.png",
                          Strings.titleAmSorry,
                          Strings.loseInternet,
                          context, () {
                        serviceGetAddAddressUser();
                      }))),
        ),
      ],
    );
  }

  serviceGetAddAddressUser() async {
    this.addresses = [];
    utils.checkInternet().then((value) async {
      if (value) {
        hasInternet = true;
        utils.startProgress(context);
        Future callResponse = UserProvider.instance.getAddress(context, 0);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          GetAddressResponse data = GetAddressResponse.fromJson(decodeJSON);

          if (data.status) {
            for (var address in data.data.addresses) {
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
          print("Ocurrio un error: ${error}");
          loading = false;
          Navigator.pop(context);
        });
      } else {
        hasInternet = false;
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

          if (data.status) {
            Navigator.pop(context);
            utils.showSnackBarGood(context, data.message);
            serviceGetAddAddressUser();
          } else {
            Navigator.pop(context);
            setState(() {});
            utils.showSnackBarError(context, data.message);
          }
        }, onError: (error) {
          print("Ocurrio un error: ${error}");

          Navigator.pop(context);
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  openAddAddress() async {
    var data =
        await Navigator.push(context, customPageTransition(AddAddressPage()));
    if (data) {
      serviceGetAddAddressUser();
    }
  }

  pushToAddAddress() async {
    var data = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.slideInLeft,
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
            type: PageTransitionType.slideInLeft,
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
      Navigator.pop(context);
  }
}
