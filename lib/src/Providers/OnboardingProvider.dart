import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/ConstansApi.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';

class OnboardingProvider with ChangeNotifier{

  final prefsUser = SharePreference();

  Future registerGoogle(String email) async {
    Map encrypt = utils.encryptPwdIv(ConstantsApi.pwdSocialNetwork);
    var  params = {
      'email': email,
      'password': encrypt['encryptedPWD'],
      "type": "gm",
      "iv": encrypt['iv'],
      "pushToken":"",
      'version': "",
      "platformId": Platform.isIOS == true ? "I" : "A"
    };

    var header = {
      "Content-Type": "application/json".toString(),
      "X-CT-Access-Token": prefsUser.accessToken.toString()
    };

    var body = jsonEncode(params);

    final response = await http
        .post("",
        headers:header, body: body)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson['code'] == 100) {

      } else {
        throw decodeJson['message'];
      }
    } else {

      throw decodeJson['message'];
    }
  }

}