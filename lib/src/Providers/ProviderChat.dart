import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:wawamko/src/Models/DataMessage.dart';
import 'package:wawamko/src/UI/Chat/WidgetsChat/MessageChat.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
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

  List<MessageChat> _ltsMessages = [];

  List<MessageChat> get ltsMessages => this._ltsMessages;

  set addMessages(MessageChat value) {
    this._ltsMessages.insert(0, value);
    notifyListeners();
  }

  List<DataMessage> _ltsMessagesChat = [];

  List<DataMessage> get ltsMessagesChat => this._ltsMessagesChat;

  set ltsMessagesChat(List<DataMessage> value) {
    this._ltsMessagesChat = value;
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
    final mimeType = mime(file.path)!.split('/');
    final multipartFile = await http.MultipartFile.fromPath('file', file.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    request.files.add(multipartFile);
    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        return decodeJson['data']['path'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future getRomSeller(String sellerId, String idOrder) async {
    this.ltsMessagesChat.clear();
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {"sellerId": sellerId, "orderId": idOrder};
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "chat/get-room-by-seller"),
            headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    final List<DataMessage> listMessages = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['room']['messageSellerUser']) {
          final data = DataMessage.fromJson(item);
          listMessages.add(data);
        }
        if (listMessages.isNotEmpty) {
          this.ltsMessagesChat = listMessages;
        }
        return decodeJson['data']['room']['id'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future getRomProvider(String packageId, String idProvider) async {
    this.ltsMessagesChat.clear();
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    Map jsonData = {"providerId": idProvider, "orderPackageId": packageId};
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "chat/get-room-by-provider"),
            headers: header, body: body)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    final List<DataMessage> listMessages = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['room']['messageProviderUser']) {
          final data = DataMessage.fromJson(item);
          listMessages.add(data);
        }
        if (listMessages.isNotEmpty) {
          this.ltsMessagesChat = listMessages;
        }
        return decodeJson['data']["room"]["id"];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future getRomAdmin() async {
    this.ltsMessagesChat.clear();
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString()
    };
    final response = await http
        .get(Uri.parse(Constants.baseURL + "chat/get-room-by-admin"), headers: header)
        .timeout(Duration(seconds: 25))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    final List<DataMessage> listMessages = [];
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['room']['messageAdminUser']) {
          final data = DataMessage.fromJson(item);
          listMessages.add(data);
        }
        if (listMessages.isNotEmpty) {
          this.ltsMessagesChat = listMessages;
        }
        return decodeJson['data']['room']['id'];
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  setMessagesListAdmin(String urlPhoto) {
   // this.ltsMessages.clear();
    this.ltsMessagesChat.forEach((data) {
      switch (data.type) {
        case "text":
          this.addMessages = MessageChat(
            uidUser: '1',
            message: data.message,
            date: formatDate(DateTime.now(), 'yyyy-MM-dd h:mm a', "es_CO"),
            typeMessage: data.typeUser == "user" ? 1 : 2,
            photo: urlPhoto,
            isLocal: false,
          );
          break;
        case "image":
          var dataMessage = json.decode(data.message!);
          this.addMessages = MessageChat(
            uidUser: '1',
            message: dataMessage['url'],
            date: formatDate(DateTime.now(), 'yyyy-MM-dd h:mm a', "es_CO"),
            typeMessage: 3,
            photo: urlPhoto,
            isLocal: data.typeUser == "user" ? true : false,
            urlFile: dataMessage['url'],
          );
          break;
        case "file":
          var dataMessage = json.decode(data.message!);
          this.addMessages = MessageChat(
            uidUser: '1',
            message: dataMessage['name'],
            date: formatDate(DateTime.now(), 'yyyy-MM-dd h:mm a', "es_CO"),
            typeMessage: 4,
            photo: urlPhoto,
            isLocal: data.typeUser == "user" ? true : false,
            urlFile: dataMessage['url'],
          );
          break;
      }
    });
  }
}
