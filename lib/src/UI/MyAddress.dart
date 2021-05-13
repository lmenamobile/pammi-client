import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:wawamko/src/Models/Address/GetAddress.dart';
import 'package:wawamko/src/Providers/UserProvider.dart';
import 'package:wawamko/src/UI/addAddress.dart';
import 'package:wawamko/src/UI/addTarjet.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class MyAddressPage extends StatefulWidget {

  @override
  _MyAddressPageState createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  List<Address>addresses = List();
  bool loading = true;

  @override
  void initState() {
    serviceGetAddAddressUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: _body(context),
      ),
    );
  }
  Widget _body(BuildContext context){
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 9,
            color: CustomColors.blueSplash,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(top: 10),
            width: double.infinity,
            height: 90,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("Assets/images/ic_header.png"),
                fit: BoxFit.fitWidth
              )
            ),
            child:  Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 9,
                    color: CustomColors.blueSplash,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 15,
                  child: GestureDetector(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Image(
                        image: AssetImage("Assets/images/ic_back_w.png"),
                      ),
                    ),
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      //singleton.eventRefreshHome.broadcast();
                      Navigator.pop(context);
                      //singleton.eventRefreshCheckout.broadcast();
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 25),
                  child: Text(
                    Strings.myAddress,
                    style: TextStyle(
                        fontFamily: Strings.fontArial,
                        fontSize: 17,
                        color: CustomColors.white

                    ),
                  ),
                )
              ],
            ),
          ),

        ),
        Positioned(
          top: 90,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  !this.loading ? this.addresses.isEmpty ? Container(

                      child: emptyAdd("Assets/images/ic_receive.png", Strings.questionAddress, Strings.beginAddAddress, Strings.addAddres,(){Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, child:pushToAddAddress(), duration: Duration(milliseconds: 700)));}, context),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 90,
                  )
                    : Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20,right: 20),
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount: this.addresses.length ?? 0,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context,int index){
                              return itemAddress(this.addresses[index], (){serviceChangeAddressUser(this.addresses[index]);},context,(){pushToUpdateAddAddress(this.addresses[index]);});
                            }
                        ),
                      ),

                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 70,right: 60),
                        child: btnCustomRounded(CustomColors.blueSplash, CustomColors.white, Strings.addAddres,(){ pushToAddAddress();}, context),
                      ),
                      SizedBox(height: 25),
                    ],
                  ):Container()
                ],
              ),
            ),
          ),
        )
      ],

    );
  }


  serviceGetAddAddressUser() async {
    this.addresses = [];
    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);


        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => DialogLoadingAnimated()));
        Future callResponse = UserProvider.instance.getAddress(context,0);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          GetAddressResponse data = GetAddressResponse.fromJson(decodeJSON);

          if(data.status) {


            for(var address in data.data.addresses ){
              this.addresses.add(address);
            }
            Navigator.pop(context);
            setState(() {

            });

          }else{
            Navigator.pop(context);
            setState(() {

            });
           // utils.showSnackBarError(context,data.message);
          }

          loading = false;
        }, onError: (error) {
          print("Ocurrio un error: ${error}");
          loading = false;
          Navigator.pop(context);
        });
      }else{
        loading = false;
        utils.showSnackBarError(context,Strings.loseInternet);
      }
    });
  }

  serviceChangeAddressUser(Address address) async {

    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);


        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => DialogLoadingAnimated()));
        Future callResponse = UserProvider.instance.changeStatusAddress(context, address);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          ChangeStatusAddressResponse data = ChangeStatusAddressResponse.fromJson(decodeJSON);

          if(data.status) {
            Navigator.pop(context);
            utils.showSnackBarGood(context, data.message);
            serviceGetAddAddressUser();

          }else{
            Navigator.pop(context);
            setState(() {

            });
            utils.showSnackBarError(context,data.message);
          }


        }, onError: (error) {
          print("Ocurrio un error: ${error}");

          Navigator.pop(context);
        });
      }else{

        utils.showSnackBarError(context,Strings.loseInternet);
      }
    });
  }



  pushToAddAddress()async{
    var data = await Navigator.push(context, PageTransition(type: PageTransitionType.slideInLeft, child: AddAddressPage(), duration: Duration(milliseconds: 500)));
    if(data){
      if(data){
        print("Reloading address...");
        this.loading = true;
        serviceGetAddAddressUser();
        //serviceGetCar2(context);
        // serviceGetProdsInCat();

      }

    }
  }


  pushToUpdateAddAddress(Address address)async{
    var data = await Navigator.push(context, PageTransition(type: PageTransitionType.slideInLeft, child: AddAddressPage(flagAddress: "update",address:address), duration: Duration(milliseconds: 500)));
    if(data){
      if(data){
        print("Update address...");
        serviceGetAddAddressUser();
        utils.showSnackBarGood(context,Strings.updateAddress);
        //serviceGetCar2(context);
        // serviceGetProdsInCat();

      }

    }
  }
}
