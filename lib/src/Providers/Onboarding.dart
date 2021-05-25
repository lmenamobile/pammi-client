import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:wawamko/src/Models/Country.dart';
import 'package:wawamko/src/Models/User.dart';
import 'package:wawamko/src/Utils/ConstansApi.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:http/http.dart' as http;
import 'package:wawamko/src/Utils/utils.dart';

class OnboardingProvider with ChangeNotifier {
  final _prefs = SharePreference();

  Future registerUserSocialNetwork(
      String name, String email, String typeRegister, String cityId) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Map encrypt = utils.encryptPwdIv(ConstantsApi.pwdSocialNetwork);
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
        .post(ConstantsApi.baseURL + "onboarding/create-account",
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

  Future<UserResponse> loginUserSocialNetWork(String email,String typeLogin) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Map encrypt = utils.encryptPwdIv(ConstantsApi.pwdSocialNetwork);
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
        .post(ConstantsApi.baseURL + "onboarding/login",
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
        _prefs.cityIdUser = response.user.countryUser.id;
        _prefs.dataUser = jsonEncode(response.user);
        return response.user;
      } else {
        throw decodeJson['message'];
      }
    } else {
      throw decodeJson['message'];
    }
  }

  Future<UserResponse> loginUser(String email, String password) async {
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
        .post(ConstantsApi.baseURL + "onboarding/login",
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
        _prefs.cityIdUser = response.user.countryUser.id;
        _prefs.dataUser = jsonEncode(response.user);
        return response.user;
      } else {
        throw decodeJson['message'];
      }
    } else {
      throw decodeJson['message'];
    }
  }

  /*-----JOnis-----*/



  Future<dynamic> recoveryPassword(BuildContext context, String email) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
    };

    Map jsonData = {
      'user': email,
    };

    var body = jsonEncode(jsonData);

    print("Parameters Recovery Pass ${jsonData}");

    final response = await http
        .post(ConstantsApi.baseURL + "/onboarding/password-recovery",
            headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      throw Exception(value);
    });

    print("Json Recovery Pass: ${response.body}");

    return response.body;
  }

  Future<dynamic> verifyCode(
      BuildContext context, String email, String code) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
    };

    Map jsonData = {
      'user': email,
      'code': code,
    };

    var body = jsonEncode(jsonData);

    print("Parameters verifyCode ${jsonData}");

    final response = await http
        .post(ConstantsApi.baseURL + "/onboarding/verify-code",
            headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      throw Exception(value);
    });

    print("Json VerifyCode: ${response.body}");

    return response.body;
  }

  Future<dynamic> generateAccesToken(BuildContext context) async {
    final response = await http
        .get(ConstantsApi.baseURL + "wa/generate-access-token")
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      print("Ocurrio un errorTimeout" + value);
      throw Exception(value);
    });

    print("Json AccesToken: ${response.body}");

    return response.body;
  }

  Future<dynamic> createAccount(
      BuildContext context, UserModel userModel) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
      // "X-WA-Auth-Token":_prefs.authToken.toString()
    };

    print("Headers" + _prefs.authToken);

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

    print("Parameters createAccount ${jsonData}");

    final response = await http
        .post(ConstantsApi.baseURL + "onboarding/create-account",
            headers: header, body: body)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      throw Exception(value);
    });

    print("Json createAccount: ${response.body}");

    return response.body;
  }

  Future<dynamic> getCountries(
      BuildContext context, String filter, int offset) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
      //"X-WA-Auth-Token":_prefs.authToken.toString()
    };

    print("Headers" + _prefs.authToken);

    Map jsonData = {
      'filter': filter,
      'offset': offset,
      'limit': 20,
      "status": "active"
    };

    var body = jsonEncode(jsonData);

    print("Parameters getCountries ${jsonData}");

    final response = await http
        .post(ConstantsApi.baseURL + "location/get-countries",
            headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      throw Exception(value);
    });

    print("Json getCountries: ${response.body}");

    return response.body;
  }

  Future<dynamic> getStates(
      BuildContext context, String filter, int offset, Country country) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
      //"X-WA-Auth-Token":_prefs.authToken.toString()
    };

    print("Headers" + _prefs.authToken);

    Map jsonData = {
      'filter': filter,
      'offset': offset,
      'limit': 20,
      "status": "active",
      "countryId": country.id
    };

    var body = jsonEncode(jsonData);

    print("Parameters getStates ${jsonData}");

    final response = await http
        .post(ConstantsApi.baseURL + "location/get-states",
            headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      throw Exception(value);
    });

    print("Json getStates: ${response.body}");

    return response.body;
  }

  Future<dynamic> getCities(
      BuildContext context, String filter, int offset, States state) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
      //"X-WA-Auth-Token":_prefs.authToken.toString()
    };

    print("Headers" + _prefs.authToken);

    Map jsonData = {
      'filter': filter,
      'offset': offset,
      'limit': 20,
      "status": "active",
      "stateId": state.id
    };

    var body = jsonEncode(jsonData);

    print("Parameters getCities ${jsonData}");

    final response = await http
        .post(ConstantsApi.baseURL + "location/get-cities",
            headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      throw Exception(value);
    });

    print("Json getCities: ${response.body}");

    return response.body;
  }

  Future<dynamic> verificationCode(
      BuildContext context, String code, String email) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
      //"X-WA-Auth-Token":_prefs.authToken.toString()
    };

    print("Headers ${header}");

    Map jsonData = {
      'user': email,
      'code': code,
    };

    var body = jsonEncode(jsonData);

    print("Parameters Verify code ${jsonData}");

    final response = await http
        .post(ConstantsApi.baseURL + "onboarding/verify-code",
            headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      throw Exception(value);
    });

    print("Json VerifyCode: ${response.body}");

    return response.body;
  }

  Future<dynamic> passwordRecovery(String email) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
    };
    print(email);
    Map jsonData = {
      'user': email,
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(ConstantsApi.baseURL + "onboarding/password-recovery",
            headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      throw decodeJson['message'];
    }
  }

  Future<dynamic> sendAgainCode(BuildContext context, String email) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
    };

    print("Headers ${header}");

    Map jsonData = {
      'email': email,
    };

    var body = jsonEncode(jsonData);

    print("Parameters SendAgain ${jsonData}");

    final response = await http
        .post(ConstantsApi.baseURL + "onboarding/send-code-client",
            headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      throw Exception(value);
    });

    print("Json SendAgain: ${response.body}");

    return response.body;
  }

  Future<dynamic> updatePassword(BuildContext context, String password) async {
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": _prefs.accessToken.toString(),
      "X-WA-Auth-Token": _prefs.authToken.toString()
    };

    print("Headers ${header}");
    var jsonIV = utils.encryptPwdIv(password);

    Map jsonData = {'password': jsonIV['encrypted'], 'iv': jsonIV['iv']};

    var body = jsonEncode(jsonData);

    print("Parameters UpdatePasword ${jsonData}");

    final response = await http
        .post(ConstantsApi.baseURL + "onboarding/update-password",
            headers: header, body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      throw Exception(value);
    });

    print("Json  UpdatePassword: ${response.body}");

    return response.body;
  }
}
