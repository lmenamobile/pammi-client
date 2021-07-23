import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/Products/Widgets.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/GiftCards/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

class FilterGiftCartPage extends StatelessWidget{
  ProviderSettings providerSettings;
  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
      return Scaffold(
        body: SafeArea(
          child: Container(
            color: CustomColors.whiteBackGround,
            child: Column(
              children: [
                titleBarWithDoubleAction(
                    Strings.filter,
                    "ic_menu_w.png",
                    "ic_car.png", () => Navigator.pop(context), null),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                      ),

                  margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Strings.categories,
                          style: TextStyle(
                            fontFamily: Strings.fontBold,
                            fontSize: 17,
                            color: CustomColors.blackLetter
                          ),),
                          listItemsCategory(),
                        ],
                      ),
                    ))

              ],
            ),
          ),
        ),
      );
  }

  Widget listItemsCategory() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: providerSettings.ltsCategories.isEmpty?0:providerSettings.ltsCategories.length,
        itemBuilder: (_, int index) {
          return categoryItem(providerSettings.ltsCategories[index]);
        },
      ),
    );
  }

}