


import 'package:flutter/material.dart';


class DialogLoadingAnimated extends StatefulWidget{

  @override
  DialogLoadingAnimatedState createState()=> DialogLoadingAnimatedState();
}

class DialogLoadingAnimatedState extends State<DialogLoadingAnimated>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(.2),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: Image(
                height: 300,
                width: 300,
                image: AssetImage(
                    'Assets/images/Loading.gif'
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ));
  }

}
