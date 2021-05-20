import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  bool obscureTextCurrentPass = true;
  bool obscureTextPass = true;
  bool obscureTextConfirmPass = true;
  final passwordController = TextEditingController();
  final passwordCurrentController = TextEditingController();
  final passwordConfirmController = TextEditingController();

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
  _body(BuildContext context){
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
                      Strings.changePass,
                      textAlign: TextAlign.center,
                      style: TextStyle(

                          fontSize: 15,
                          fontFamily: Strings.fontRegular,
                          color: CustomColors.blackLetter
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: 23),
          Padding(
            padding: EdgeInsets.only(left: 27,right: 43),
            child: Container(
              width: double.infinity,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),

                  children: <Widget>[
                   Text(
                     Strings.changePass,
                     style: TextStyle(
                       fontSize: 18,
                       fontFamily: Strings.fontRegular,
                       color: CustomColors.blackLetter
                     ),
                   ),
                    Text(
                      Strings.inputPass,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: Strings.fontRegular,
                          color: CustomColors.blueGray
                      ),
                    ),
                    SizedBox(height: 28),
                    txtCurrentPassword(passwordCurrentController,Strings.passCurrent),
                    SizedBox(height: 17),
                    txtPassword(passwordController,Strings.password),
                    SizedBox(height: 25),
                    txtConfirmPassword(passwordConfirmController,Strings.confirmPassword),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.only(left: 20,right: 30),
                      child: btnCustomRounded(CustomColors.orange,CustomColors.white, Strings.saveDates, (){}, context),
                    ),
                    SizedBox(height: 25),

                  ],
              ),
          ),
            )
          )
        ]
      ),
    );
  }

  Widget txtCurrentPassword(TextEditingController passwordController,String hintText){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          //  width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
              border: Border.all(color: CustomColors.gray.withOpacity(.3) ,width: 1.3),
              color: CustomColors.white
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 35,
                    height: 35,
                    image: AssetImage("Assets/images/ic_padlock.png") ,

                  ),
                  SizedBox(width: 6,),
                  Expanded(
                    child: Container(
                      width: 200,
                      child: TextField(
                        obscureText:obscureTextCurrentPass,
                        controller: passwordController,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Strings.fontRegular,
                            color:CustomColors.blackLetter
                        ),

                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color:  CustomColors.grayLetter.withOpacity(.4),
                            fontSize: 16,
                            fontFamily: Strings.fontRegular,

                          ),
                          hintText: hintText,
                        ),
                        onChanged: (value){
                          // bloc.changePassword(value);
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Image(
                      width: 35,
                      height: 35,
                      image:obscureTextCurrentPass ? AssetImage("Assets/images/ic_no_show_grey.png") : AssetImage("Assets/images/ic_show_grey.png"),
                    ),
                    onTap: (){
                      obscureTextCurrentPass ? obscureTextCurrentPass = false : obscureTextCurrentPass = true;
                      setState(() {

                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        //SizedBox(height: 20,),

      ],
    );



  }




  Widget txtPassword(TextEditingController passwordController,String hintText){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          //  width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
              border: Border.all(color: CustomColors.gray.withOpacity(.3) ,width: 1.3),
              color: CustomColors.white
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 35,
                    height: 35,
                    image: AssetImage("Assets/images/ic_padlock.png") ,

                  ),
                  SizedBox(width: 6,),
                  Expanded(
                    child: Container(
                      width: 200,
                      child: TextField(
                        obscureText:obscureTextPass,
                        controller: passwordController,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Strings.fontRegular,
                            color:CustomColors.blackLetter
                        ),

                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color:  CustomColors.grayLetter.withOpacity(.4),
                            fontSize: 16,
                            fontFamily: Strings.fontRegular,

                          ),
                          hintText: hintText,
                        ),
                        onChanged: (value){
                          // bloc.changePassword(value);
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Image(
                      width: 35,
                      height: 35,
                      image:obscureTextPass? AssetImage("Assets/images/ic_no_show_grey.png") : AssetImage("Assets/images/ic_show_grey.png"),
                    ),
                    onTap: (){
                      obscureTextPass ? obscureTextPass = false : obscureTextPass = true;
                      setState(() {

                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        //SizedBox(height: 20,),

      ],
    );



  }



  Widget txtConfirmPassword(TextEditingController passwordController,String hintText){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          //  width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
              border: Border.all(color: CustomColors.gray.withOpacity(.3) ,width: 1.3),
              color: CustomColors.white
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 35,
                    height: 35,
                    image: AssetImage("Assets/images/ic_padlock.png") ,

                  ),
                  SizedBox(width: 6,),
                  Expanded(
                    child: Container(
                      width: 200,
                      child: TextField(
                        obscureText:obscureTextConfirmPass,
                        controller: passwordController,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: Strings.fontRegular,
                            color:CustomColors.blackLetter
                        ),

                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color:  CustomColors.grayLetter.withOpacity(.4),
                            fontSize: 16,
                            fontFamily: Strings.fontRegular,

                          ),
                          hintText: hintText,
                        ),
                        onChanged: (value){
                          // bloc.changePassword(value);
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Image(
                      width: 35,
                      height: 35,
                      image:obscureTextConfirmPass? AssetImage("Assets/images/ic_no_show_grey.png") : AssetImage("Assets/images/ic_show_grey.png"),
                    ),
                    onTap: (){
                      obscureTextConfirmPass ? obscureTextConfirmPass = false : obscureTextConfirmPass = true;
                      setState(() {

                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        //SizedBox(height: 20,),

      ],
    );



  }


}
