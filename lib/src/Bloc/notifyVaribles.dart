
import 'package:flutter/cupertino.dart';
import 'package:wawamko/src/Models/ModelsUpdate.dart';


class NotifyVariablesBloc with ChangeNotifier{



  bool _edit2 = false;
  bool _showHelpMap = true;
  bool _addCurrent = false;
  bool _moreSend = false;
  bool _showMarcaFilter = false;
  String _countrySelected = "";
  Login _intLogin = Login(validateEmail: false,validatePassword: false);
  ForgotPass _intForPass = ForgotPass(validateEmail: false);
  Register _register = Register(validateEmail: false,validConfirmPass: false,validPass: false);
  UpdatePass _updatePass = UpdatePass(validPass: false,validConfirmPass: false);

  bool  get edit2 => this._edit2;
  String get countrySelected => this._countrySelected;
  bool  get showHelpMap => this._showHelpMap;

  bool  get addCurrent => this._addCurrent;
  bool  get moreSend => this._moreSend;

  bool  get showMarcaFilter => this._showMarcaFilter;

  Login get intLogin => this._intLogin;
  ForgotPass get intForPass => this._intForPass;
  Register get intRegister => this._register;
  UpdatePass get intUpdatePass => this._updatePass;


  set edit2(bool val){
    this._edit2 = val;
    notifyListeners();
  }

  set showHelpMap(bool val){
    this._showHelpMap = val;
    notifyListeners();
  }

  set addCurrent(bool val){
    this._addCurrent = val;
    notifyListeners();
  }

  set moreSend(bool val){
    this._moreSend = val;
    notifyListeners();
  }

  set showMarcaFilter(bool val){
    this._showMarcaFilter = val;
    notifyListeners();
  }

  set countrySelected(String val){
    this._countrySelected = val;
    notifyListeners();
  }

  set intLogin(Login val){
    this._intLogin = val;
    notifyListeners();
  }

  set intForPass(ForgotPass val){
    this._intForPass = val;
    notifyListeners();
  }

  set intRegister(Register val){
    this._register = val;
    notifyListeners();
  }

  set intUpdatePass(UpdatePass val){
    this._updatePass = val;
    notifyListeners();
  }






}