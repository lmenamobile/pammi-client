import 'package:flutter/material.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

class ProductCategoryPage extends StatefulWidget {
  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: CustomColors.redTour,
     body: SafeArea(
       child: Container(
         color: CustomColors.grayBackground,
         child: Column(
           children: [
             Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.only(
                   bottomRight: Radius.circular(20),
                   bottomLeft: Radius.circular(20),
                 ),
                 gradient: LinearGradient(
                   begin: Alignment.centerLeft,
                   end: Alignment.centerRight,
                   colors: <Color>[CustomColors.redTour, CustomColors.redOne],
                 ),
               ),
               child: Container(
                 height: 100,
                 margin: EdgeInsets.symmetric(horizontal: 10),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Row(
                       mainAxisSize: MainAxisSize.max,
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: <Widget>[
                         GestureDetector(
                           child: Container(
                             height: 30,
                             width: 30,
                             child: Image(
                               image: AssetImage(
                                   "Assets/images/ic_backward_arrow.png"),
                             ),
                           ),
                           onTap: () => Navigator.pop(context),
                         ),
                         Text(
                           Strings.categories,
                           style: TextStyle(
                               fontSize: 15,
                               color: Colors.white,
                               fontFamily: Strings.fontBold),
                         ),
                         GestureDetector(
                           child: Container(
                             width: 30,
                             child: Image(
                               image: AssetImage("Assets/images/ic_car.png"),
                             ),
                           ),
                           onTap: null,
                         ),
                       ],
                     ),
                     SizedBox(
                       height: 10,
                     ),
                     Container(
                       margin: EdgeInsets.symmetric(horizontal: 20),
                       child: Row(
                         mainAxisSize: MainAxisSize.max,
                         children: [
                           Expanded(child: boxSearchHome(searchController,null)),
                           SizedBox(width: 10,),
                           IconButton(icon: Icon(Icons.menu,color:  CustomColors.graySearch.withOpacity(.3),), onPressed: null)
                         ],
                       ),
                     )
                   ],
                 ),
               ),
             ),
           ],
         ),
       ),
     ),
   );
  }
}