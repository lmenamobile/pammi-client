import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:http/http.dart' as http;
import 'package:wawamko/src/Utils/utils.dart';

class OnboardingProvider with ChangeNotifier {
  final _prefs = SharePreference();

  bool _isLoading = false;
  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  bool _stateDates = false;
  bool get stateDates => this._stateDates;
  set stateDates(bool value) {
    this._stateDates = value;
    notifyListeners();
  }

  bool _stateTerms = false;
  bool get stateTerms => this._stateTerms;
  set stateTerms(bool value) {
    this._stateTerms = value;
    notifyListeners();
  }

  bool _stateCentrals = false;
  bool get stateCentrals => this._stateCentrals;
  set stateCentrals(bool value) {
    this._stateCentrals = value;
    notifyListeners();
  }

  Future getAccessToken() async {
    final response = await http
        .get(Constants.baseURL + "wa/generate-access-token")
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        _prefs.accessToken = decodeJson['data']['accessToken'];
        return decodeJson['data']['accessToken'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      throw decodeJson['message'];
    }
  }

  Future registerUserSocialNetwork(
      String name, String email, String typeRegister, String cityId) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Map encrypt = utils.encryptPwdIv(Constants.pwdSocialNetwork);
    var params = {
      'fullname': name,
      'email': email,
      'password': encrypt['encrypted'],
      "type": typeRegister,
      'city': cityId,
      "iv": encrypt['iv'],
      'platform': Platform.isIOS ? "i" : "a",
      'pushToken': "",
      'version': packageInfo.version.toString(),
    };
    var header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
    };
    var body = jsonEncode(params);
    final response = await http
        .post(Constants.baseURL + "onboarding/create-account",
            headers: header, body: body)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 201) {
      if (decodeJson['code'] == 100) {
      } else {
        throw decodeJson['message'];
      }
    } else {
      throw decodeJson['message'];
    }
  }

  Future<UserResponse> loginUserSocialNetWork(
      String email, String typeLogin) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Map encrypt = utils.encryptPwdIv(Constants.pwdSocialNetwork);
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
    };
    Map jsonData = {
      'email': email,
      'password': encrypt['encrypted'],
      'iv': encrypt['iv'],
      'type': typeLogin,
      'pushToken': "",
      'version': packageInfo.version,
      'platform': Platform.isIOS ? "i" : "a",
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Constants.baseURL + "onboarding/login",
            headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        var response = DataUser.fromJsonMap(decodeJson['data']);
        _prefs.authToken = response.authToken;
        _prefs.nameUser = response.user.fullname;
        _prefs.countryIdUser = response.user.countryUser.id;
        _prefs.dataUser = jsonEncode(response.user);
        _prefs.referredCode = response.user.referredCode;
        _prefs.userID = response.user.id.toString();
        return response.user;
      } else {
        throw decodeJson['message'];
      }
    } else {
      throw decodeJson['message'];
    }
  }

  Future<UserResponse> loginUser(String email, String password) async {
    this.isLoading = true;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var jsonIV = utils.encryptPwdIv(password);
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
    };
    Map jsonData = {
      'email': email,
      'password': jsonIV['encrypted'],
      'iv': jsonIV['iv'],
      'type': "lc",
      'pushToken': "",
      'version': packageInfo.version,
      'platform': Platform.isIOS ? "i" : "a",
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Constants.baseURL + "onboarding/login",
            headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        var response = DataUser.fromJsonMap(decodeJson['data']);
        _prefs.authToken = response.authToken;
        _prefs.nameUser = response.user.fullname;
        _prefs.countryIdUser = response.user.countryUser.id;
        _prefs.dataUser = jsonEncode(response.user);
        _prefs.referredCode = response.user.referredCode;
        _prefs.codeShare = response.user.codeShare;
        _prefs.userID = response.user.id.toString();
        return response.user;
      } else {
        throw decodeJson['message'];
      }
    } else if (response.statusCode == 400) {
      this.isLoading = false;
      if (decodeJson['code'] == 103) {
        //Usuario no validado
        throw 103;
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }
  }

  Future passwordRecovery(String email) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
    };
    Map jsonData = {
      'user': email,
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Constants.baseURL + "onboarding/password-recovery",
            headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        return decodeJson['message'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }
  }

  Future sendAgainCode(String email) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
    };
    Map jsonData = {
      'email': email,
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Constants.baseURL + "onboarding/send-code-client",
            headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }
  }

  Future<dynamic> verificationCode(String code, String email) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
    };
    Map jsonData = {
      'user': email,
      'code': code,
    };
    var body = jsonEncode(jsonData);

    final response = await http
        .post(Constants.baseURL + "onboarding/verify-code",
            headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        _prefs.authToken = decodeJson['data']['authToken'];
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }
  }

  Future<dynamic> updatePassword(String password) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": _prefs.authToken.toString()
    };
    var jsonIV = utils.encryptPwdIv(password);
    Map jsonData = {'password': jsonIV['encrypted'], 'iv': jsonIV['iv']};

    var body = jsonEncode(jsonData);

    final response = await http
        .post(Constants.baseURL + "onboarding/update-password",
            headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }
  }

  Future<dynamic> createAccount(UserModel userModel) async {
    this.isLoading = true;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
    };
    var jsonEncript = utils.encryptPwdIv(userModel.passWord);
    Map jsonData = {
      'fullname': userModel.name + " " + userModel.lastName,
      'email': userModel.email,
      'phone': userModel.numPhone,
      'password': jsonEncript['encrypted'],
      'iv': jsonEncript['iv'],
      'city': userModel.cityId,
      'platform': Platform.isIOS ? "i" : "a",
      'type': "lc",
      'pushToken': "",
      'version': packageInfo.version.toString(),
    };

    var body = jsonEncode(jsonData);
    print(body);
    final response = await http
        .post(Constants.baseURL + "onboarding/create-account",
            headers: header, body: body)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 201) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        var response = DataUser.fromJsonMap(decodeJson['data']);
        _prefs.authToken = response.authToken;
        _prefs.nameUser = response.user.fullname;
        _prefs.countryIdUser = response.user.countryUser.id;
        _prefs.dataUser = jsonEncode(response.user);
        return response.user;
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }
  }


}
