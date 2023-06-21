


import 'package:flutter/material.dart';


class DialogLoadingAnimated extends StatefulWidget{

  @override
  DialogLoadingAnimatedState createState()=> DialogLoadingAnimatedState();
}

class DialogLoadingAnimatedState extends State<DialogLoadingAnimated>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(.2),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Image(
              height: 200,
              width: 200,
              image: AssetImage(
                  'assets/images/loadingN.gif'
              ),
              fit: BoxFit.contain,
            ),
          ),
        ));
  }

}
