import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Pqrs/response_pqrs.dart';
import 'package:wawamko/src/Providers/pqrs_provider.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';



class ListTypeSupportPage extends StatefulWidget {
  const ListTypeSupportPage({Key? key}) : super(key: key);

  @override
  _ListTypeSupportPageState createState() => _ListTypeSupportPageState();
}

class _ListTypeSupportPageState extends State<ListTypeSupportPage> {

  late PQRSProvider pqrsProvider;

  @override
  void initState() {
    pqrsProvider = Provider.of<PQRSProvider>(context,listen: false);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      pqrsProvider.initTypesSupport();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context){
    pqrsProvider = Provider.of<PQRSProvider>(context);
    return Column(
      children: [
        header(context, Strings.pqrs, CustomColors.redDot, () => Navigator.pop(context)),
        SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                  child: Text(
                    Strings.supportType,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 19,
                      color: CustomColors.black1,
                      fontFamily: Strings.fontBold
                    ),
                  ),
                ),
                ListView.builder(
                   shrinkWrap: true,
                   physics: NeverScrollableScrollPhysics(),
                   itemCount: pqrsProvider.typesSupport.length,
                   itemBuilder: (context, index){
                      return itemTypeSupport(pqrsProvider.typesSupport[index], _selectTypeSupport);
                    }),
                SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: btnCustom(double.infinity,Strings.continue1, CustomColors.blueSplash, Colors.white, _continueSelectTypeSupport)
                ),
                SizedBox(height: 40),

              ],
            ),
          ),
        )
      ],
    );
  }

  _selectTypeSupport(TypeSupport typeSupport){
    pqrsProvider.selectedTypeSupport(typeSupport);
  }

  _continueSelectTypeSupport(){
    Navigator.pop(context,"update");
  }

  Widget itemTypeSupport(TypeSupport typeSupport,Function action){
    return GestureDetector(
      onTap: (){
        action(typeSupport);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 29,vertical: 26),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color:typeSupport.selected ? CustomColors.red2 : CustomColors.gray5,width: 1)
        ),
        child: Text(
          typeSupport.typeSupport ?? "",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: Strings.fontRegular,
            fontSize: 14,
            color: typeSupport.selected ? CustomColors.red2 : CustomColors.gray
          ),
        ),
      ),
    );
  }



}


