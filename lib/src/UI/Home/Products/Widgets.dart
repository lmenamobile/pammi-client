import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

Widget titleBarWithDoubleAction(String title, String icon, String iconTwo,
    Function action, Function actionTwo) {
  return Container(
    width: double.infinity,
    height: 70,
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("Assets/images/ic_header_red.png"),
            fit: BoxFit.fill)),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          child: Image(
            width: 40,
            height: 40,
            color: Colors.white,
            image: AssetImage("Assets/images/$icon"),
          ),
          onTap: () => action(),
        ),
        Center(
          child: Container(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: Strings.fontRegular,
                  color: Colors.white),
            ),
          ),
        ),
        GestureDetector(
          child: Image(
            width: 40,
            height: 40,
            color: Colors.white,
            image: AssetImage("Assets/images/$iconTwo"),
          ),
          onTap: () => action(),
        ),
      ],
    ),
  );
}

Widget itemImageReference(double size, String asset) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: CustomColors.orange)),
    child: Padding(
      padding: const EdgeInsets.all(3),
      child: FadeInImage(
        fit: BoxFit.fill,
        image: NetworkImage(asset),
        placeholder: AssetImage("Assets/images/spinner.gif"),
      ),
    ),
  );
}

Widget imageReference(double size, String asset){
  return Container(
    width: size,
    height: size,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: FadeInImage(
        fit: BoxFit.fill,
        image: NetworkImage(asset),
        placeholder: AssetImage("Assets/images/spinner.gif"),
      ),
    ),
  );
}

Widget itemReference(String asset,String nameReference, bool isSelected){
  return Container(
    decoration: BoxDecoration(
        color: isSelected?CustomColors.grayBackground:Colors.transparent,
        borderRadius:
        BorderRadius.all(Radius.circular(5))),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                child: FadeInImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(asset),
                  placeholder: AssetImage("Assets/images/spinner.gif"),
                ),
              ),
              SizedBox(
                width: 13,
              ),
              Text(
                nameReference,
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.gray7),
              )
            ],
          ),
        ],
      ),
    ),
  );
}

openBottomSheetLtsReferences(BuildContext context,Function selectReference,List<Reference> ltsReferences) {
  return showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      barrierColor: CustomColors.blueSplash.withOpacity(.6),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height*.65,
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               Text(
                 Strings.references,
                 style: TextStyle(
                   fontFamily: Strings.fontBold,
                   fontSize: 18,
                   color:CustomColors.black1
                 ),
               ),
                SizedBox(height: 15,),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      itemCount: ltsReferences==null?0:ltsReferences.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: InkWell(
                            onTap: ()=>selectReference(ltsReferences[index]),
                              child: itemReference(ltsReferences[index].images[0].url, ltsReferences[index].reference,ltsReferences[index].isSelected)),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Visibility(
                  visible: false,
                  child: btnCustom(
                      190,
                      Strings.next,
                      CustomColors.blueSplash,
                      Colors.white,
                      null),
                ),
              ],
            ),
          ),
        );
      });
}

