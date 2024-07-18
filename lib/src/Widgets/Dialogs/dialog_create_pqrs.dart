import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';


class DialogCreatePqrs extends StatefulWidget {

  final String idTicket;
  final Function action;
  const DialogCreatePqrs({Key? key,required this.idTicket,required this.action}) : super(key: key);

  @override
  _DialogCreatePqrsState createState() => _DialogCreatePqrsState();
}

class _DialogCreatePqrsState extends State<DialogCreatePqrs> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.black2.withOpacity(.1),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: _body(context),
        ),
      ),
    );
  }
  Widget _body(BuildContext context){
    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: BounceInRight(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(19))
                  ),
                  child: Column(
                    children: <Widget>[
                      SvgPicture.asset("Assets/images/checkCreate.svg",width: 59,height: 59,),
                      SizedBox(height: 18),
                      Text(
                        "${Strings.ticket} ${widget.idTicket} creado.",
                        style: TextStyle(
                            fontSize: 18,
                            color: AppColors.black2,
                            fontFamily: Strings.fontBold
                        ),
                      ),
                      SizedBox(height: 18),
                      GestureDetector(
                        onTap: (){
                          widget.action();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 23,vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.blue
                          ),
                          child: Text(
                            Strings.understood,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: Strings.fontRegular
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),

                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
