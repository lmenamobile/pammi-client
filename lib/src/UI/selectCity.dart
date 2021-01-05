import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class SelectCityPage extends StatefulWidget {
  @override
  _SelectCityPageState createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
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
                    Strings.selectCity,
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
                                  child: itemCity(context, index,(){selectItemCountry();})//itemBookings(context, data, _openBookingDetail),
                              ),
                            )
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 37),
                  Padding(padding: EdgeInsets.only(left: 50,right: 50), child: btnCustomRounded(CustomColors.blueActiveDots,CustomColors.white,"Continuar",(){Navigator.pop(context);},context)),
                  SizedBox(height: 73),
                ],
              ),
            )
          ]
      ),
    );
  }

  selectItemCountry(){
    print("Select Item");
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
            Image(
              width: 40,
              height: 40,
              image: AssetImage(""),
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
