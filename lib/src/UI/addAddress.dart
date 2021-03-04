import 'package:flutter/material.dart';


class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

        ],
      ),
    );
  }
}
