import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';

class ProviderChat with ChangeNotifier {
  final prefs = SharePreference();

  bool _isLoading = false;
  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  Future serviceSendFile(File file) async {
    this.isLoading = true;
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    final url = Uri.parse(Constants.baseURL + 'chat/upload-file');
    final request = http.MultipartRequest("POST", url);
    request.headers.addAll(header);
    final mimeType = mime(file.path).split('/');
    final multipartFile = await http.MultipartFile.fromPath(
        'file', file.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    request.files.add(multipartFile);
    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        this.isLoading = false;
        return decodeJson['data']['path'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }
  }

  Future getRomSeller(String sellerId,String idOrder) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      "sellerId": sellerId,
      "orderId": idOrder
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Constants.baseURL + "chat/get-room-by-seller", headers: header,body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        return decodeJson['data']['room']['id'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }
  }


  Future getRomProvider(String packageId,String idProvider) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {
      "providerId": idProvider,
      "orderPackageId": packageId
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Constants.baseURL + "chat/get-room-by-provider", headers: header,body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson['code'] == 100) {
        return decodeJson['data']["room"]["id"];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson['message'];
    }
  }

}