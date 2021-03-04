import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/colors.dart';

class ProductsByCategoriePage extends StatefulWidget {
  @override
  _ProductsByCategoriePageState createState() => _ProductsByCategoriePageState();
}

class _ProductsByCategoriePageState extends State<ProductsByCategoriePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteBackGround,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: _body(context),

      ),
    );
  }

  Widget _body(BuildContext context){
    return Stack(
      children: <Widget>[

      ],
    );
  }
}
