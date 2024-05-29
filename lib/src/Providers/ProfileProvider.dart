import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:wawamko/src/Models/CreditCard.dart';
import 'package:wawamko/src/Models/UserProfile.dart';
import 'dart:convert';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:wawamko/src/Utils/utils.dart';

class ProfileProvider with ChangeNotifier {
  final prefsUser = SharePreference();

  bool _isOpenLink = false;
  bool get isOpenLink => this._isOpenLink;
  set isOpenLink(bool value) {
    this._isOpenLink = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  bool _isEditProfile = false;
  bool get isEditProfile => this._isEditProfile;
  set isEditProfile(bool value) {
    this._isEditProfile = value;
    notifyListeners();
  }

  UserProfile? _user;
  UserProfile? get user => this._user;
  set user(UserProfile? value) {
    this._user = value;
    notifyListeners();
  }

  File? _imageUserFile;
  File? get imageUserFile => this._imageUserFile;
  set imageUserFile(File? value) {
    this._imageUserFile = value;
    notifyListeners();
  }

  List<CreditCard> _ltsCreditCards = [];
  List<CreditCard> get ltsCreditCards => this._ltsCreditCards;
  set ltsCreditCards(List<CreditCard> value) {
    this._ltsCreditCards = value;
    notifyListeners();
  }

  Future<dynamic> updateUser(
      String name,
      String typeIdentification,
      String numberIdentification,
      String phone,
      String cityId,
      ) async {
    this.isLoading = true;
    Map params = {};
    if (name.isNotEmpty) {
      params.addAll({"fullname": name});
    }
    if (typeIdentification.isNotEmpty && numberIdentification.isNotEmpty) {
      params.addAll({'documentType': typeIdentification});
      params.addAll({'document': numberIdentification});
    }
    if (phone.isNotEmpty) {
      params.addAll({"phone": phone});
    }
    if (cityId.isNotEmpty) {
      params.addAll({'cityId': cityId});
    }
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefsUser.authToken.toString()
    };
    var body = jsonEncode(params);
    final response = await http
        .post(Uri.parse(Constants.baseURL + 'profile/update-profile'),
        headers: header, body: body)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 201) {
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        return decodeJson['message'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future serviceUpdatePhoto(File picture) async {
    this.isLoading = true;
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefsUser.authToken.toString()
    };
    final url = Uri.parse(Constants.baseURL + 'profile/update-photo');
    final request = http.MultipartRequest("POST", url);
    request.headers.addAll(header);
    final mimeType = mime(picture.path)!.split('/');
    final multipartFile = await http.MultipartFile.fromPath(
        'photo', picture.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    request.files.add(multipartFile);
    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        return decodeJson['message'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future getDataUser() async {
    this.isLoading = true;
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefsUser.authToken.toString()
    };
    final response = await http
        .get(Uri.parse(Constants.baseURL + 'profile/get-profile'), headers: header)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        this.user = UserProfile.fromJson(decodeJson['data']['user']);
        prefsUser.referredCode = user?.referredCode??'';
        prefsUser.codeShare = user?.codeShare??'';
        prefsUser.photoUser = user?.photoUrl??'';
        return this.user;
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future updatePWD(String pwdOld, String newPWD) async {
    Map encryptOld = utils.encryptPwdIv(pwdOld);
    Map encrypt = utils.encryptPwdIv(newPWD);
    this.isLoading = true;
    Map params = {
      "oldPassword": encryptOld['encrypted'],
      "oldIv": encryptOld['iv'],
      "password": encrypt['encrypted'],
      "iv": encrypt['iv'],
    };
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefsUser.authToken.toString()
    };
    var body = jsonEncode(params);
    final response = await http
        .post(Uri.parse(Constants.baseURL + 'profile/change-password'),
        headers: header, body: body)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        return decodeJson['message'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future getLtsCreditCards(String page) async {
    this.isLoading = true;
    Map params = {
      "limit":"20",
      "offset":page
    };
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefsUser.authToken.toString()
    };
    var body = jsonEncode(params);
    final response = await http.post(Uri.parse(Constants.baseURL  + 'profile/get-payment-methods'),
        headers: header,body: body)
        .timeout(Duration(seconds: 10)).catchError((value) {this.isLoading = false;throw Strings.errorServeTimeOut;});
    final List<CreditCard> listCards = [];
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final card = CreditCard.fromJson(item);
          listCards.add(card);
        }
        this.isLoading = false;
        this.ltsCreditCards = listCards;
        return listCards;
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }

  }

  Future addCreditCard(
      String name,
      String numberCard,
      String? month,
      String? year,
      String cvc) async {
    this.isLoading = true;

    Map<String,dynamic> params = {
      "cardHolder": name,
      "cardNumber": numberCard,
      "expirationMonth": month,
      "expirationYear": year,
      "cvc" : cvc
    };



    var jsonDataPayment = utils.encryptPwdIv(jsonEncode(params));

    Map jsonData = {
      'dataPayment': jsonDataPayment['encrypted'],
      'iv':jsonDataPayment['iv']
    };


    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefsUser.authToken.toString()
    };

    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + 'profile/create-payment-method'),
        headers: header, body: body)
        .timeout(Duration(seconds: 20))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 201) {
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        this.ltsCreditCards.clear();
        getLtsCreditCards("0");
        return decodeJson['message'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future deleteCreditCard(
      String idCreditCard) async {
    this.isLoading = true;
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefsUser.authToken.toString()
    };
    final response = await http
        .delete(Uri.parse(Constants.baseURL + 'profile/delete-payment-method/$idCreditCard'),
        headers: header)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        this.ltsCreditCards.clear();
        getLtsCreditCards("0");
        return decodeJson['message'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }


  Future getCloseAccount() async {
    this.isLoading = true;
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefsUser.authToken.toString()
    };
    final response = await http.post(Uri.parse(Constants.baseURL + 'profile/close-account'), headers: header)
        .timeout(Duration(seconds: 10))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        return decodeJson['message'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }


}
