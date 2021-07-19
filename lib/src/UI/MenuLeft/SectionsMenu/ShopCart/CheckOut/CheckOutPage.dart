import 'package:flutter/material.dart';
import '../CheckOut/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class CheckOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.grayBackground,
          child: Column(
            children: [
              titleBar(Strings.order, "ic_blue_arrow.png", () => Navigator.pop(context)),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      sectionAddress(),
                      SizedBox(height: 8,),
                      sectionProducts(),
                      SizedBox(height: 8,),
                      sectionPayment(),
                      SizedBox(height: 8,),
                      sectionDiscount(),
                      SizedBox(height: 15,),
                      sectionTotal()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}