
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Bank.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';

import '../WidgetsGeneric.dart';

class DialogSelectBank extends StatefulWidget {
  @override
  _DialogSelectBankState createState() => _DialogSelectBankState();
}

class _DialogSelectBankState extends State<DialogSelectBank> {
  late ProviderSettings providerSettings;
  final prefs = SharePreference();

  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context, listen: false);
    getBanks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  Strings.selectBank,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: Strings.fontMedium),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height*.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child:providerSettings.ltsBanks.isEmpty
                              ? emptyData("ic_empty_location.png",
                              Strings.sorry,Strings.emptyBanks)
                              : listItemsBanks(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget listItemsBanks() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      itemCount: providerSettings.ltsBanks.isEmpty?0:providerSettings.ltsBanks.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (_, int index) {
        return itemBank(providerSettings.ltsBanks[index]);
      },
    );
  }

  Widget itemBank(Bank bank){
    return Container(
      child: ListTile(
        title: Text(bank.bankName!),
        leading: Radio(
          value: 1,
          groupValue: bank.valStatus,
          onChanged: (dynamic value) {
            bank.valStatus = value;
           actionSelectBank(bank);
          },
          activeColor: Colors.redAccent,
        ),
      ),
    );
  }



  actionSelectBank(Bank bankSelected) {
    Navigator.pop(context,bankSelected);
  }

  getBanks() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings = providerSettings.getBanks();
        await callSettings.then((msg) {}, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }
}
