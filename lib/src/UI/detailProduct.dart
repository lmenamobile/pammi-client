import 'package:flutter/material.dart';


class DetailProductPage extends StatefulWidget {
  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext cotext){
    return Stack(children: <Widget>[
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: ,
      )
    ],);
  }
}
