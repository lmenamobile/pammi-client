import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wawamko/src/Models/Address/GetAddress.dart';
import 'package:wawamko/src/Providers/UserProvider.dart';
import 'package:wawamko/src/UI/addAddress.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import '../Models/Address.dart';

class MyAddressPage extends StatefulWidget {
  @override
  _MyAddressPageState createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  List<Address> addresses = [];
  bool loading = true;
  bool hasInternet = true;

  @override
  void initState() {
    serviceGetAddAddressUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.redTour,
      body: SafeArea(
        child: Container(
          color: AppColors.whiteBackGround,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("Assets/images/ic_header_red.png"),
                  fit: BoxFit.fill)),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 15,
                top: 15,
                child: GestureDetector(
                  child: Image(
                    width: 40,
                    height: 40,
                    color: Colors.white,
                    image: AssetImage("Assets/images/ic_blue_arrow.png"),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Center(
                child: Container(
                  child: Text(
                    Strings.myAddress,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: Strings.fontRegular,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20,),
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  hasInternet
                      ? !this.loading
                          ? this.addresses.isEmpty
                              ? Container(
                                  child: emptyAdd(
                                      "Assets/images/ic_receive.png",
                                      Strings.questionAddress,
                                      Strings.beginAddAddress,
                                      Strings.addAddres, () {
                                    Navigator.of(context).push(customPageTransition(pushToAddAddress(), PageTransitionType.rightToLeftWithFade));
                                  }, context),
                                )
                              : Column(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 20),
                                      width: double.infinity,
                                      child: ListView.builder(
                                          itemCount: this.addresses.length ?? 0,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return itemAddress(
                                                this.addresses[index],
                                                () {
                                                  serviceChangeAddressUser(
                                                      this.addresses[index]);
                                                },
                                                () {
                                                  pushToUpdateAddAddress(
                                                      this.addresses[index]);
                                                });
                                          }),
                                    ),
                                    SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 70, right: 60),
                                      child: btnCustomRounded(
                                          AppColors.blueSplash,
                                          AppColors.white,
                                          Strings.addAddres, () {
                                        pushToAddAddress();
                                      }, context),
                                    ),
                                    SizedBox(height: 25),
                                  ],
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
                              })))
                ]),
          ),
        )
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

          if (data.status!=null) {
            for (var address in data.data?.addresses??[]) {
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

          if (data.status!=null) {
            Navigator.pop(context);
            utils.showSnackBarGood(context, data.message!);
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

  pushToAddAddress() async {
    var data = await Navigator.push(
        context,
        customPageTransition(AddAddressPage(), PageTransitionType.rightToLeftWithFade));
    if (data!=null) {
        print("Reloading address...");
        this.loading = true;
        serviceGetAddAddressUser();
    }
  }

  pushToUpdateAddAddress(Address address) async {
    var data = await Navigator.push(
        context,
        customPageTransition(AddAddressPage(flagAddress: "update", address: address), PageTransitionType.rightToLeftWithFade));
    if (data!=null) {
        print("Update address...");
        serviceGetAddAddressUser();
        utils.showSnackBarGood(context, Strings.updateAddress);
    }
  }
}
