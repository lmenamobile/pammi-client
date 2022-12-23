import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class LoadingProgress extends StatefulWidget{
  @override
  _LoadingProgressState createState() => _LoadingProgressState();
}

class _LoadingProgressState extends State<LoadingProgress> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return WillPopScope(
     onWillPop: () async => false,
     child: Scaffold(
       backgroundColor: Colors.black.withOpacity(.1),
       body: Container(
         height: MediaQuery.of(context).size.height,
         child: Center(
           child:loadingWidget(_controller)
         ),
       ),
     ),
   );
  }

  Widget loadingWidget(AnimationController controller){
    controller.duration = Duration(milliseconds: 3000);
    controller.repeat();
    return Lottie.asset(
      'Assets/images/loanding.json',
      width: 200,
      height: 200,
      controller: controller,
      fit: BoxFit.contain,
      repeat: true,
      onLoaded: (composition) {
        controller..duration = composition.duration;
      },
    );
  }
}