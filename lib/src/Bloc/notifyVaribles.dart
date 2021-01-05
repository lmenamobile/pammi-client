
import 'package:flutter/cupertino.dart';


class NotifyVariablesBloc with ChangeNotifier{



  bool _edit2 = false;
  bool  get edit2 => this._edit2;

  set edit2(bool val){
    this._edit2 = val;
    notifyListeners();
  }





}