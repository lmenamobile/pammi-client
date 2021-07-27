import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class DetailOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              titleBar("Numero de orden aca", "ic_back.png", () => Navigator.pop(context)),

            ],
          ),
        ),
      ),
    );
  }

}