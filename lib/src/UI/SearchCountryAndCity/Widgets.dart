import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wawamko/src/Models/City.dart';
import 'package:wawamko/src/Models/CountryUser.dart';
import 'package:wawamko/src/Models/StatesCountry.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

Widget boxSearchCountries(TextEditingController controllerSearch,Function search) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 26,vertical: 10),
    width: double.infinity,
    decoration: BoxDecoration(
        border: Border.all(color: CustomColors.gray4.withOpacity(.3),width: 1),
        borderRadius: BorderRadius.all(Radius.circular(26)),
        color: Colors.transparent),
    child: Center(
      child: Row(
        children: <Widget>[
          Image(
            width: 20,
            height: 20,
            color: CustomColors.blue,
            image: AssetImage("Assets/images/ic_seeker.png"),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: TextField(
              onSubmitted: (value) {
                search(value);
              },
              textInputAction: TextInputAction.search,
              controller: controllerSearch,
              style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  fontSize: 15,
                  color: CustomColors.blackLetter),
              decoration: InputDecoration(
                  hintText: Strings.search,
                  isDense: true,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      fontFamily: Strings.fontRegular,
                      fontSize: 15,
                      color: CustomColors.gray7)),
            ),
          )
        ],
      ),
    ),
  );
}

Widget itemCountrySelect(CountryUser country, Function action) {
  return GestureDetector(
    child: Container(
      width: double.infinity,
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            color: CustomColors.grayBackground,
                            borderRadius: BorderRadius.all(Radius.circular(100))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: SvgPicture.network(
                            country.flag!,
                            height: 30,
                            width: 30,
                            fit: BoxFit.fitHeight,
                          ),
                        )),
                    SizedBox(width: 15),
                    Text(
                      country.country!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                          color: CustomColors.blackLetter,
                          fontFamily: Strings.fontRegular),
                    ),
                  ]),
              customDivider(),
            ],
          ),
        ),
      ),
    ),
    onTap: () => action(country),
  );
}

Widget itemCountry(CountryUser country, Function action) {
  return GestureDetector(
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color:  CustomColors.gray.withOpacity(.3), width: .8),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Row(
            children: <Widget>[
              Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: CustomColors.grayBackground,
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: SvgPicture.network(
                      country.flag!,
                      height: 30,
                      width: 30,
                      fit: BoxFit.fitHeight,
                    ),
                  )),
              SizedBox(width: 50),
              Text(
                country.country!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.blackLetter,
                    fontFamily: Strings.fontBold),
              ),
            ]),
      ),
    ),
    onTap: () => action(country),
  );
}

Widget itemStateCountry(StatesCountry state, Function action) {
  return GestureDetector(
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color:  CustomColors.gray.withOpacity(.3), width: .8),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Container(
          margin: EdgeInsets.only(left:30),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Text(
                    state.name!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.gray15,
                        fontFamily: Strings.fontBold),
                  ),
                ),
              ]),
        ),
      ),
    ),
    onTap: () => action(state),
  );
}

Widget cityItem(City city, Function action) {
  return GestureDetector(
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color:  CustomColors.gray.withOpacity(.3), width: .8),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Container(
          margin: EdgeInsets.only(left:30),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  city.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.gray15,
                      fontFamily: Strings.fontRegular),
                ),
              ]),
        ),
      ),
    ),
    onTap: () => action(city),
  );
}
