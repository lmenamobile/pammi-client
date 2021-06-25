import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import '../DrawerMenu.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  GlobalKey<ScaffoldState> keyMenuLeft = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyMenuLeft,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuFavorites,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              titleBar(Strings.favorites, "ic_menu_w.png", ()=>keyMenuLeft.currentState.openDrawer())
            ],
          ),
        ),
      ),
    );
  }
}