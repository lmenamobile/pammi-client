import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Offers/Widgets.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';

import '../../DrawerMenu.dart';

class OffersDayPage extends StatefulWidget{
  @override
  _OffersDayPageState createState() => _OffersDayPageState();
}

class _OffersDayPageState extends State<OffersDayPage> {
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  final searchController = TextEditingController();
  ProviderProducts providerProducts;
  int pageOffsetUnits = 0;

  @override
  void initState() {
    providerProducts = Provider.of<ProviderProducts>(context,listen: false);
    providerProducts.ltsOfferUnits.clear();
    getOffersType("units", "", pageOffsetUnits);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerProducts = Provider.of<ProviderProducts>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuOffersTheDay,
      ),
      body: SafeArea(
        child: Container(
          color: CustomColors.grayBackground,
          child:Column(
            children: [
              header(),
              Expanded(child: listOffersUnits())
            ],
          ) ,
        ),
      ),
    );
  }

  Widget header(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[CustomColors.redTour, CustomColors.redOne],
        ),
      ),
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    height: 30,
                    width: 30,
                    child: Image(
                      image: AssetImage(
                          "Assets/images/ic_backward_arrow.png"),
                    ),
                  ),
                  onTap: () => keyMenuLeft.currentState.openDrawer(),
                ),
                Text(
                  Strings.offersDay,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: Strings.fontBold),
                ),
                GestureDetector(
                  child: Container(
                    width: 30,
                    child: Image(
                      image: AssetImage("Assets/images/ic_car.png"),
                    ),
                  ),
                  onTap: null,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: boxSearchHome(searchController, null)),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.menu,
                        color:
                        CustomColors.graySearch.withOpacity(.3),
                      ),
                      onPressed: null)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listOffersUnits() {
    return ListView.builder(
      itemCount: providerProducts.ltsOfferUnits.isEmpty?0:providerProducts.ltsOfferUnits.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: itemOfferUnits(providerProducts.ltsOfferUnits[index]),
        );
      },
    );
  }

  getOffersType(String typeOffer,String brandId,int offset) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts = providerProducts.getOfferByType(typeOffer, brandId, offset);
        await callProducts.then((list) {

        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}