import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wawamko/src/Models/Country.dart';
import 'package:wawamko/src/Providers/Onboarding.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class StatesPage extends StatefulWidget {
  final Country country;
  StatesPage({Key key,this.country}) : super(key: key);

  @override
  _StatesPageState createState() => _StatesPageState();
}

class _StatesPageState extends State<StatesPage> {


  final searchStateController = TextEditingController();
  List<States> states = List();
  bool loading = true;

  @override
  void initState() {
    _sertviceGetStates("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: CustomColors.white,
          child: _body(context),
        ),
      ),
    );
  }


  Widget _body(BuildContext context){
    return Stack(
      children: <Widget>[
        Positioned(
          top: 20,
          left: 20,
          child: GestureDetector(
            child: Image(
              width: 40,
              height: 40,
              image: AssetImage("Assets/images/ic_back.png"),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
        ),
        Positioned(
          top: 70,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            child: Stack(
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(top: 8,left: 39,right: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Strings.selectState,
                          style: TextStyle(
                              fontSize: 24,
                              color: CustomColors.blackLetter,
                              fontFamily: Strings.fontArialBold
                          ),
                        ),
                        SizedBox(height: 21),
                        boxSearch(context),
                        SizedBox(height: 21),
                        !this.loading  ?    this.states.isEmpty  ? Container(  child: Center(child: notifyUser("Assets/images/ic_from_empty.png", Strings.titleAmSorry, Strings.cobertCountry),)) : Container(
                          // margin: EdgeInsets.only(left: 23,right: 15),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(top: 0),
                            itemCount: states?.length ?? 0,//productsInShopCar.length ?? 0,//this.productsZones?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {

                              return  AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 800),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                        child: itemState(context, index,this.states[index])//itemBookings(context, data, _openBookingDetail),
                                    ),
                                  )
                              );
                            },
                          ),
                        ) : Container(),
                        SizedBox(height: 37),
                        //Padding(padding: EdgeInsets.only(left: 50,right: 50), child: btnCustomRounded(CustomColors.blueActiveDots,CustomColors.white,"Continuar",(){Navigator.pop(context);},context)),
                        //SizedBox(height: 73),
                      ],
                    ),
                  )
                ]
            ),
          ),
        ),

      ],
    );
  }


  Widget boxSearch(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      height: 47,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: CustomColors.grayBackground
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            Image(
              width: 20,
              height: 20,
              image: AssetImage("Assets/images/ic_seeker.png"),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: TextField(
                onChanged: (value){
                  _sertviceGetStates2(value);
                },
                controller: searchStateController,
                style: TextStyle(
                    fontFamily: Strings.fontArial,
                    fontSize: 15,
                    color: CustomColors.blackLetter
                ),
                decoration: InputDecoration(
                    hintText: "Buscar",
                    isDense: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontFamily: Strings.fontArial,
                        fontSize: 15,
                        color: CustomColors.grayLetter
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );

  }




  _sertviceGetStates(String search) async {




    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);
        Future callUser = OnboardingProvider.instance.getStates(context, search ?? "", 0,widget.country);
        await callUser.then((countryResponse) {

          var decodeJSON = jsonDecode(countryResponse);
          StatesResponse data = StatesResponse.fromJsonMap(decodeJSON);


          if(data.code.toString() == "100") {
            this.loading = false;

            this.states = [];
            if (data.data != null){
              for (var state in data.data.states){
                this.states.add(state);
              }
            }


            setState(() {

            });

            Navigator.pop(context);
          } else {
            this.loading = false;

            Navigator.pop(context);
            setState(() {

            });
            utils.showSnackBar(context, data.message);

          }
        }, onError: (error) {
          this.loading = false;
          Navigator.pop(context);
          setState(() {

          });
          utils.showSnackBar(context, Strings.serviceError);


        });
      } else {
        this.loading = false;
        Navigator.pop(context);
        setState(() {

        });
        utils.showSnackBar(context, Strings.internetError);


      }
    });
  }


  _sertviceGetStates2(String search) async {




    utils.checkInternet().then((value) async {
      if (value) {
        //utils.startProgress(context);
        Future callUser = OnboardingProvider.instance.getStates(context, search ?? "", 0,widget.country);
        await callUser.then((countryResponse) {

          var decodeJSON = jsonDecode(countryResponse);
         StatesResponse data = StatesResponse.fromJsonMap(decodeJSON);


          if(data.code.toString() == "100") {

            this.states = [];
            for (var state in data.data.states){
              this.states.add(state);
            }

            setState(() {

            });

            //Navigator.pop(context);
          } else {

            //Navigator.pop(context);
           // utils.showSnackBar(context, data.message);

          }
        }, onError: (error) {

          //Navigator.pop(context);
          utils.showSnackBar(context, Strings.serviceError);


        });
      } else {
        //Navigator.pop(context);
        utils.showSnackBar(context, Strings.internetError);


      }
    });
  }




}
