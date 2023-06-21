import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/Home/Products/Widgets.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/GiftCards/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class FilterGiftCartPage extends StatefulWidget {
  @override
  _FilterGiftCartPageState createState() => _FilterGiftCartPageState();
}

class _FilterGiftCartPageState extends State<FilterGiftCartPage> {
  late ProviderSettings providerSettings;

  RangeValues values = RangeValues(0, 50);

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: Column(
            children: [
              headerDoubleTapMenu(context, Strings.filter, "ic_remove_white.png", "ic_back.png", CustomColors.redDot, "0", () => Navigator.pop(context), ()=>clearFilter()),
              Expanded(
                child: providerSettings.hasConnection?SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        sliderRange(),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Strings.categories,
                                    style: TextStyle(
                                        fontFamily: Strings.fontBold,
                                        fontSize: 17,
                                        color: CustomColors.blackLetter),
                                  ),
                                  listItemsCategory(),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        btnCustom(200, Strings.apply, CustomColors.blueSplash,
                            Colors.white, returnDataFilter)
                      ],
                    ),
                  ),
                ):notConnectionInternet(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listItemsCategory() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: providerSettings.ltsCategories.isEmpty
            ? 0
            : providerSettings.ltsCategories.length,
        itemBuilder: (_, int index) {
          return InkWell(
              onTap: () =>
                  selectCategory(providerSettings.ltsCategories[index]),
              child: categoryItem(providerSettings.ltsCategories[index]));
        },
      ),
    );
  }

  Widget sliderRange() {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.price,
              style: TextStyle(
                  fontFamily: Strings.fontBold,
                  fontSize: 17,
                  color: CustomColors.blackLetter),
            ),
            Text(
              formatMoney(values.end.round().toString()),
              style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  fontSize: 15,
                  color: CustomColors.blackLetter),
            ),
            customDivider(),
            Column(
              children: [
                RangeSlider(
                    values: values,
                    min: 0,
                    max: 100,
                    activeColor: CustomColors.orange,
                    inactiveColor: CustomColors.gray6,
                    labels: RangeLabels(values.start.round().toString(),
                        values.end.round().toString()),
                    onChanged: (values) => setState(() {
                          this.values = values;
                        })),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildSlideText(values.start),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildSlideText(double value) {
    return Text(
      value.round().toString(),
      style: TextStyle(
          color: CustomColors.blackLetter,
          fontSize: 13,
          fontFamily: Strings.fontRegular),
    );
  }

  selectCategory(Category category) {
    providerSettings.selectCategory = category;
  }

  returnDataFilter() async {
    if (providerSettings.selectCategory != null) {
      Navigator.pop(context, true);
    } else {
      showCustomAlertDialog(context, Strings.sorry, Strings.textAlertFilter);
    }
  }

  clearFilter(){
    providerSettings.selectCategory = null;
  }
}
