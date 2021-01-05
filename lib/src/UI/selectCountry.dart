import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wawamko/src/UI/RegisterStepTwo.dart';
import 'package:wawamko/src/UI/selectCity.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class SelectCountryPage extends StatefulWidget {
  @override
  _SelectCountryPageState createState() => _SelectCountryPageState();
}

class _SelectCountryPageState extends State<SelectCountryPage> {
  final countryController = TextEditingController();
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: CustomColors.white,
        child: _body(context),
      ),
    );
  }
  Widget _body(BuildContext context){
      return SingleChildScrollView(
        child: Stack(
          children: <Widget>[
        GestureDetector(
          child: Container(
            alignment: Alignment.topRight,
              child: Image(
                width: 80,
                height: 80,
                image: AssetImage("Assets/images/ic_arrow_menu.png"),
          ),
        ),
          onTap: (){
              Navigator.pop(context);
          },
    ),
    Container(
            margin: EdgeInsets.only(left: 29,top: 50),
              child: Image(
              width: 60,
              height: 60,
              image: AssetImage("Assets/images/ic_logo_l.png"),
    ),
    ),
            Padding(
              padding: EdgeInsets.only(top: 130,left: 39,right: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Strings.selectCountry,
                    style: TextStyle(
                      fontSize: 24,
                      color: CustomColors.blackLetter,
                      fontFamily: Strings.fontArialBold
                    ),
                  ),
                  SizedBox(height: 21),
                  boxSearch(context),
                  SizedBox(height: 21),
                  Container(
                    // margin: EdgeInsets.only(left: 23,right: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 0),
                      itemCount: 9,//productsInShopCar.length ?? 0,//this.productsZones?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {

                        return  AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 800),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                  child: itemCountry(context, index,(){selectItemCountry();})//itemBookings(context, data, _openBookingDetail),
                              ),
                            )
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),


                ],
              ),
            )
    ]
    ),
      );
  }

  selectItemCountry(){
   print("Select Item");
   Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.slideInLeft, child:SelectCityPage(), duration: Duration(milliseconds: 700)));

  }

  Widget boxSearch(BuildContext context){
    return Container(
      height: 47,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: CustomColors.grayBackground
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Image(
                width: 20,
                height: 20,
                image: AssetImage("Assets/images/ic_seeker.png"),
              ),
            ),
            Expanded(
              child: TextField(
                controller: countryController,
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
}
