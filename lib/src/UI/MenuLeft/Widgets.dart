import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget itemBtnReferred(Function action) {
  return InkWell(
    onTap: () => action(),
    child: Container(
      height: 44,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[CustomColors.redTour, CustomColors.grayGradient],
          ),
          borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 8,
                ),
                Image.asset(
                  "Assets/images/ic_coin.png",
                  width: 30,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    Strings.wingsReferred,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: Strings.fontMedium,
                        fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Image.asset(
            "Assets/images/ic_following.png",
            width: 30,
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    ),
  );
}

openBottomSheet(BuildContext context,Function actionShare) {
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
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      CustomColors.redTour,
                      CustomColors.grayGradient
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal:20,vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Strings.shareAndEnjoy,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: Strings.fontBold,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              Strings.textInfoReferred,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: Strings.fontRegular,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Image.asset("Assets/images/ic_referred.png",width: 140,)
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                height: 120,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.shareCode,
                      style: TextStyle(
                          color: CustomColors.grayLetter,
                          fontFamily: Strings.fontBold,),
                    ),
                    SizedBox(height: 8,),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: CustomColors.greyBorder,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),

                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "IYAISIASG123",
                              style: TextStyle(
                                color: CustomColors.blueSplash,
                                fontFamily: Strings.fontBold,),
                            ),
                            InkWell(
                              onTap: ()=>actionShare(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CustomColors.redTour,
                                  borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                  child: Text(
                                    Strings.share,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: Strings.fontBold,),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      });
}
