import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/colors.dart';


class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: _body(context),
      ),
      backgroundColor: CustomColors.whiteBackGround,
    );
  }

  Widget _body(BuildContext context){
    return Stack(
      children: <Widget>[

      ],
    );
  }
}
