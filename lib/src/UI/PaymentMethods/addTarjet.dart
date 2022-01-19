import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class AddTargetPage extends StatefulWidget {
  @override
  _AddTargetPageState createState() => _AddTargetPageState();
}

class _AddTargetPageState extends State<AddTargetPage> {
  final nameTargetController = TextEditingController();
  final numberTargetController = TextEditingController();
  final cvcTargetController = TextEditingController();

  late ProfileProvider profileProvider;
  List<DropdownMenuItem<String>>? _dropdownMenuItemsYears;
  String? selectedYear;
  List<DropdownMenuItem<String>>? _dropdownMenuItemsMonths;
  String? selectedMonth;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '####  ####  ####  ####', filter: {"#": RegExp(r'[0-9]')});
  var maskMountFormatter =
      new MaskTextInputFormatter(mask: '##', filter: {"#": RegExp(r'[0-9]')});

  String msgError = '';

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _dropdownMenuItemsMonths = buildDropItems(utils.listMonths());
      _dropdownMenuItemsYears = buildDropItems(utils.listYears());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: CustomColors.grayBackground,
              child: _body(context),
            ),
            Visibility(
                visible: profileProvider.isLoading, child: LoadingProgress()),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: <Widget>[
        titleBar(Strings.addTarjet, "ic_blue_arrow.png",
            () => Navigator.pop(context)),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                card(),
                SizedBox(height: 30),
                customTextFieldCreditCard(
                    nameTargetController,
                    Strings.nameCard,
                    Icons.account_circle_rounded,
                    [LengthLimitingTextInputFormatter(20)],
                    TextInputType.name),
                SizedBox(
                  height: 30,
                ),
                customTextFieldCreditCard(
                    numberTargetController,
                    Strings.numberCard,
                    Icons.credit_card,
                    [
                      LengthLimitingTextInputFormatter(20),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    TextInputType.number),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(
                              top: 8,
                            ),
                            child: _dropDownMonths()),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(
                              top: 8,
                            ),
                            child: _dropDownYears()),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                customTextFieldCreditCard(
                    cvcTargetController,
                    Strings.cvc,
                    Icons.credit_card,
                    [
                      LengthLimitingTextInputFormatter(4),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    TextInputType.number),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  child: btnCustomRounded(
                      CustomColors.blueSplash,
                      CustomColors.white,
                      Strings.addTarjet,
                      callServiceAddCreditCart,
                      context),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget customTextFieldCreditCard(
    TextEditingController controller,
    String hintText,
    IconData icon,
    List<TextInputFormatter> formatter,
    TextInputType inputType,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        inputFormatters: formatter,
        keyboardType: inputType,
        style: TextStyle(
          fontFamily: Strings.fontRegular,
          fontSize: 15,
          color: CustomColors.blackLetter,
        ),
        controller: controller,
        decoration: InputDecoration(
            suffixIcon: Icon(
              icon,
              color: CustomColors.blueSplash,
            ),
            hintText: hintText,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CustomColors.blueSplash),
            ),
            hintStyle: TextStyle(
                fontFamily: Strings.fontRegular,
                fontSize: 15,
                color: CustomColors.gray7.withOpacity(.4))),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _dropDownYears() {
    return DropdownButton(
      value: selectedYear,
      items: _dropdownMenuItemsYears,
      isExpanded: true,
      iconEnabledColor: CustomColors.blueSplash,
      underline: Container(height: 1, color: CustomColors.blueSplash),
      style: TextStyle(
          fontFamily: Strings.fontRegular,
          fontSize: 15,
          color: CustomColors.blackLetter),
      hint: Text(
        Strings.selectedYear,
        style: TextStyle(
            fontFamily: Strings.fontRegular,
            fontSize: 15,
            color: CustomColors.gray7.withOpacity(.4)),
        textAlign: TextAlign.center,
      ),
      onChanged: (dynamic option) {
        setState(() {
          selectedYear = option;
        });
      },
    );
  }

  Widget _dropDownMonths() {
    return DropdownButton(
      value: selectedMonth,
      items: _dropdownMenuItemsMonths,
      isExpanded: true,
      iconEnabledColor: CustomColors.blueSplash,
      underline: Container(height: 1, color: CustomColors.blueSplash),
      style: TextStyle(
          fontFamily: Strings.fontRegular,
          fontSize: 15,
          color: CustomColors.blackLetter),
      hint: Text(
        Strings.selectedMonth,
        style: TextStyle(
            fontFamily: Strings.fontRegular,
            fontSize: 15,
            color: CustomColors.gray7.withOpacity(.4)),
        textAlign: TextAlign.center,
      ),
      onChanged: (dynamic option) {
        setState(() {
          selectedMonth = option;
        });
      },
    );
  }

  List<DropdownMenuItem<String>> buildDropItems(List items) {
    List<DropdownMenuItem<String>> list = [];
    items.forEach((item) {
      list.add(DropdownMenuItem(
        child: Text(
          item,
          style: TextStyle(fontFamily: Strings.fontMedium, fontSize: 13),
        ),
        value: item,
      ));
    });
    return list;
  }

  Widget card() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(.2),
            offset: Offset(0, .5),
          ),
        ],
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'Assets/images/ic_img_chip.png',
              width: 40,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              numberTargetController.text.isEmpty?'******** 0000':"******** "+numberTargetController.text.substring(numberTargetController.text.length>4?numberTargetController.text.length-4:0),
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: Strings.fontBold,
                  color: CustomColors.blackLetter),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nameTargetController.text.isEmpty
                      ? Strings.hintName
                      : nameTargetController.text,
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.blackLetter),
                ),
                Text(
                  selectedMonth == null
                      ? Strings.hintDate
                      : selectedYear == null
                          ? Strings.hintDate
                          : selectedMonth! + "/" + selectedYear!,
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.blackLetter),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool validateForm() {
    bool validateForm = true;
    if (nameTargetController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.nameCardEmpty;
    } else if (numberTargetController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.numberCardEmpty;
    } else if (numberTargetController.text.length < 15) {
      validateForm = false;
      msgError = Strings.numberCardLength;
    } else if (selectedMonth == null) {
      validateForm = false;
      msgError = Strings.mountCardEmpty;
    } else if (selectedYear == null) {
      validateForm = false;
      msgError = Strings.yearCardEmpty;
    } else if (cvcTargetController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.cvcEmpty;
    } else if (cvcTargetController.text.length < 3) {
      validateForm = false;
      msgError = Strings.cvcLength;
    }
    return validateForm;
  }

  callServiceAddCreditCart() {
    if (validateForm()) {
      addCreditCard();
    } else {
      utils.showSnackBar(context, msgError.toString());
    }
  }

  void addCreditCard() {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = profileProvider.addCreditCard(
            nameTargetController.text,
            numberTargetController.text,
            selectedMonth,
            selectedYear,
            cvcTargetController.text);
        await callUser.then((msg) {
          Navigator.pop(context);
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
          profileProvider.isLoading = false;
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
