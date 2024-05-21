import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Pqrs/response_pqrs.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';



class DetailPqrs extends StatefulWidget {
  final ItemPqrs itemPqrs;
  const DetailPqrs({Key? key,required this.itemPqrs}) : super(key: key);

  @override
  _DetailPqrsState createState() => _DetailPqrsState();
}

class _DetailPqrsState extends State<DetailPqrs> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(context, Strings.pqrs, CustomColors.redDot, () => Navigator.pop(context)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
          decoration: BoxDecoration(
            color: CustomColors.gray5.withOpacity(.1),
          ),
          child: Text(
            "${Strings.ticket} ${widget.itemPqrs.id}",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
              color: CustomColors.blackLetter,
              fontFamily: Strings.fontBold
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.supportType,
                  style: TextStyle(
                      fontFamily: Strings.fontMedium,
                      fontSize: 15,
                      color: CustomColors.blue
                  ),
                ),
                SizedBox(height: 11),
                Text(
                  getTypeSupport(widget.itemPqrs.supportType ?? ""),
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.blackLetter
                  ),
                ),
                SizedBox(height: 37),
                Text(
                  Strings.topic,
                  style: TextStyle(
                      fontFamily: Strings.fontMedium,
                      fontSize: 15,
                      color: CustomColors.blue
                  ),
                ),
                SizedBox(height: 11),
                Text(
                  widget.itemPqrs.subject ?? "",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.blackLetter
                  ),
                ),
                SizedBox(height: 37),
                Text(
                  Strings.message,
                  style: TextStyle(
                      fontFamily: Strings.fontMedium,
                      fontSize: 15,
                      color: CustomColors.blue
                  ),
                ),
                SizedBox(height: 11),
                Text(
                  widget.itemPqrs.message ?? "",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.blackLetter
                  ),
                ),
                SizedBox(height: 37),
                Text(
                  Strings.status,
                  style: TextStyle(
                      fontFamily: Strings.fontMedium,
                      fontSize: 15,
                      color: CustomColors.blue
                  ),
                ),
                SizedBox(height: 11),
                Text(
                  getStatusPqrs(widget.itemPqrs.status ?? ""),
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.blackLetter
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),



      ],
    );
  }

  String getTypeSupport(String typeSupport){
    String typeSupportTemp = "";
    switch(typeSupport){
      case "suggestion":
        typeSupportTemp = "Sugerencia";
        break;
      case "claim":
        typeSupportTemp = "Reclamo";
        break;
      case "complaint":
        typeSupportTemp = "Queja";
        break;
      case "petition":
        typeSupportTemp = "Petición";
        break;
      default:
        typeSupportTemp = typeSupport;
        break;
    }
    return typeSupportTemp;
  }


}
