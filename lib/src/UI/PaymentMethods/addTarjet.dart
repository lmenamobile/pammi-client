import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class AddTargetPage extends StatefulWidget {
  @override
  _AddTargetPageState createState() => _AddTargetPageState();
}

class _AddTargetPageState extends State<AddTargetPage> {
  final nameTargetController = TextEditingController();
  final numberTargetController = TextEditingController();
  final mountTajetController = TextEditingController();
  final ageTajetController = TextEditingController();
  final cvcTajetController = TextEditingController();

  //var textEditingController = TextEditingController(text: "12345678");
  var maskFormatter = new MaskTextInputFormatter(
      mask: '####  ####  ####  ####', filter: {"#": RegExp(r'[0-9]')});
  var maskMountFormatter =
      new MaskTextInputFormatter(mask: '##', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.grayBackground,
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: <Widget>[
        titleBar(Strings.addTarjet, "ic_blue_arrow.png",
            () => Navigator.pop(context)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            customTextFieldCreditCard(nameTargetController,Strings.nameCard,Icons.account_circle_rounded),
            SizedBox(height: 30,),
            customTextFieldCreditCard(numberTargetController,Strings.numberCard,Icons.credit_card),

          ],
        ),
      ],
    );
  }

  Widget customTextFieldCreditCard(TextEditingController controller,String hintText,IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        style: TextStyle(
          fontFamily: Strings.fontRegular,
          fontSize: 15,
          color: CustomColors.blackLetter,
        ),
        controller: controller,
        decoration: InputDecoration(
            suffixIcon: Icon(icon,color: CustomColors.blueSplash,),
            hintText: hintText,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CustomColors.blueSplash),
            ),
            hintStyle: TextStyle(
                fontFamily: Strings.fontRegular,
                fontSize: 15,
                color: CustomColors.gray7.withOpacity(.4))),
      ),
    );
  }

}
