import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class AddTargetPage extends StatefulWidget {
  @override
  _AddTargetPageState createState() => _AddTargetPageState();
}

class _AddTargetPageState extends State<AddTargetPage> {
  final nameTajetController = TextEditingController();
  final numberTajetController = TextEditingController();
  final mountTajetController = TextEditingController();
  final ageTajetController = TextEditingController();
  final cvcTajetController = TextEditingController();


  //var textEditingController = TextEditingController(text: "12345678");
  var maskFormatter = new MaskTextInputFormatter(mask: '####  ####  ####  ####', filter: { "#": RegExp(r'[0-9]') });
  var maskMountFormatter = new MaskTextInputFormatter(mask: '##', filter: { "#": RegExp(r'[0-9]') });



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteBackGround,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 30),
          Container(
            height: 74,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                color: CustomColors.white
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 20,
                  top:20,
                  child: GestureDetector(
                    child: Image(
                      width: 30,
                      height: 30,
                      image: AssetImage("Assets/images/ic_blue_arrow.png"),

                    ),
                    onTap: (){Navigator.pop(context);},
                  ),
                ),

                Center(
                  child: Container(
                    //alignment: Alignment.center,

                    child: Text(
                      Strings.creditTarjet,
                      textAlign: TextAlign.center,
                      style: TextStyle(

                          fontSize: 15,
                          fontFamily: Strings.fontArialBold,
                          color: CustomColors.blackLetter
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 21,right: 21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                SizedBox(height: 12),
                Text(
                  Strings.infoCard,
                  style: TextStyle(
                      fontSize: 15,
                      color: CustomColors.blackLetter,
                      fontFamily: Strings.fontArialBold
                  ),


                ),
                SizedBox(height: 30),
                containerNameTarget(),
                SizedBox(height: 17),
                containerNumberTarget(),
                SizedBox(height: 14),

                // -> "1234-5678"


              ],
            ),
          ),
          datesTarget()
        ],
      )
    );
  }


  Widget containerNameTarget(){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: CustomColors.gray.withOpacity(.3) ,width: 1.3),
          color: CustomColors.white,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 14,left: 20,right: 40),
            child: Row(
              children: <Widget>[
                Image(
                  width: 29,
                  height: 29,
                  image: AssetImage("Assets/images/ic_data.png"),
                ),
                Text(
                  Strings.nameCard,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: Strings.nameCard,
                    color: CustomColors.blackLetter
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20,right: 40),
            child: Column(
              children: <Widget>[
                TextField(

                  style: TextStyle(

                    fontFamily: Strings.fontArial,
                    fontSize: 15,
                    color: CustomColors.blackLetter,
                  ),
                  controller: nameTajetController,

                  decoration: InputDecoration(

                    border: InputBorder.none,
                    hintText:  Strings.nameCard,
                    hintStyle: TextStyle(
                      fontFamily: Strings.fontArial,
                      fontSize: 15,
                      color: CustomColors.grayLetter.withOpacity(.4)
                    )
                  ),
                ),
                Container(

                  width: double.infinity,
                  color: CustomColors.blueActiveDots,
                  height: 2,
                ),
                SizedBox(height:20),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget containerNumberTarget(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.gray.withOpacity(.3) ,width: 1.3),
        color: CustomColors.white,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 14,left: 20,right: 40),
            child: Row(
              children: <Widget>[
                Image(
                  width: 29,
                  height: 29,
                  image: AssetImage("Assets/images/ic_data.png"),
                ),
                Text(
                  Strings.numberCard,
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: Strings.nameCard,
                      color: CustomColors.blackLetter
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20,right: 40),
            child: Column(
              children: <Widget>[
                TextField(

                  style: TextStyle(

                    fontFamily: Strings.fontArial,
                    fontSize: 15,
                    color: CustomColors.blackLetter,
                  ),
                  controller: numberTajetController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskFormatter],
                  decoration: InputDecoration(

                      border: InputBorder.none,
                      hintText:  Strings.numberCard,
                      hintStyle: TextStyle(
                          fontFamily: Strings.fontArial,
                          fontSize: 15,
                          color: CustomColors.grayLetter.withOpacity(.4)
                      )
                  ),
                ),
                Container(

                  width: double.infinity,
                  color: CustomColors.blueActiveDots,
                  height: 2,
                ),
                SizedBox(height:20),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget containerMonthTarget(TextEditingController controller,String txt){
    return Container(
      width: 120,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: <Widget>[
              Image(
                fit: BoxFit.fill,
                width: 30,
                height: 30,
                image: AssetImage("Assets/images/ic_big_calendar.png"),
              ),
              Expanded(
                child: Text(
                  txt,
                  style: TextStyle(
                    fontFamily: Strings.fontArial,
                    fontSize: 15,
                    color: CustomColors.blackLetter
                  ),
                ),
              )
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [maskMountFormatter],
                style: TextStyle(
                  fontFamily: Strings.fontArial,
                  fontSize: 15,
                  color: CustomColors.blackLetter,
                ),
                decoration: InputDecoration(
                  hintText:"00",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontFamily: Strings.fontArial,
                    fontSize: 15,
                    color: CustomColors.grayLetter.withOpacity(.4),

                  )
                ),
              ),
              Container(
                height: 2,
                width: double.infinity,
                color: CustomColors.blueActiveDots,
              )
            ],
          )
        ],
      )

    );
  }


  Widget
  datesTarget(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30)),
        color: CustomColors.white
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25,left: 30,right: 30),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[
                 containerMonthTarget(mountTajetController,Strings.mountCard),
                 SizedBox(width: 30),
                 containerMonthTarget(ageTajetController,Strings.yearCard)

               ],
            ),
          ),
          SizedBox(height: 50),
          Padding(
          padding: const EdgeInsets.only(top: 25,left: 40,right: 30),
          child:Row(
            children: <Widget>[
              containerMonthTarget(cvcTajetController,Strings.cvc),
            ],
          )
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.only(left: 50,right: 50),
            child: btnCustomRounded(CustomColors.orange, CustomColors.white, Strings.save, (){}, context),
          ),
          SizedBox(height: 30),
        ],

      ),
    );
  }

}
