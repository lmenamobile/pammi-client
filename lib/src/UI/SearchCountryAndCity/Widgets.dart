
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wawamko/src/Models/CountryUser.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget boxSelect(){
  return  Center(
    child: Container(
      height: 35,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: CustomColors.blueSplash, width: 1.0),
          bottom: BorderSide(color:  CustomColors.blueSplash, width: 1.0),
        ),
      ),
    ),
  );
}

Widget itemCountry(CountryUser country, Function action) {
  return GestureDetector(
    child: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: CustomColors.grayBackground,
                              borderRadius:
                              BorderRadius.all(Radius.circular(100))),
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(100)),
                            child: SvgPicture.network(
                              country.flag,
                              height: 30,
                              width: 30,
                              fit: BoxFit.fitHeight,
                            ),
                          )),
                      SizedBox(width: 15),
                      Text(
                        country.country,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            color: CustomColors.blackLetter,
                            fontFamily: Strings.fontBold),
                      ),
                    ]),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: CustomColors.grayBackground.withOpacity(.4),
          width: double.infinity,
        ),
      ],
    ),
    onTap: () => action,
  );
}