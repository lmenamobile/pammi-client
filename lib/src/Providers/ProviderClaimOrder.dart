
import 'dart:io';

import 'package:mime_type/mime_type.dart';
import 'package:wawamko/src/Models/Order/MethodDevolution.dart';
import 'package:wawamko/src/Models/Order/TypeClaim.dart';
import 'package:wawamko/src/Models/Order/TypeReason.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

class ProviderClaimOrder with ChangeNotifier {

  final prefs = SharePreference();

  bool _isLoading = false;
  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  TypeReason? _typeReasonSelected;
  TypeReason? get typeReasonSelected => this._typeReasonSelected;
  set selectTypeReason(TypeReason? value) {
    this._typeReasonSelected = value;
    notifyListeners();
  }

  TypeClaim? _typeClaimSelected;
  TypeClaim? get typeClaimSelected => this._typeClaimSelected;
  set selectTypeClaim(TypeClaim? value) {
    this._typeClaimSelected= value;
    notifyListeners();
  }

  MethodDevolution? _methodDevolutionSelected;
  MethodDevolution? get methodDevolution => this._methodDevolutionSelected;
  set selectMethodDevolution(MethodDevolution? value) {
    this._methodDevolutionSelected = value;
    notifyListeners();
  }

  int _valueStep = 1;
  int get valueStep => this._valueStep;
  set setValueStep(int value) {
    this._valueStep = value;
    notifyListeners();
  }

  File? _imageFile = File('');
  File? get imageFile => this._imageFile;
  set setImageFile(File? value) {
    this._imageFile = value;
    notifyListeners();
  }

  clearValues(){
    this._imageFile = null;
    this._valueStep = 1;
    this._typeReasonSelected = null;
    this._typeClaimSelected = null;
    this._methodDevolutionSelected = null;
  }

  Future createClaim(
      TypeReason reason,
      TypeClaim typeClaim,
      File picture,
      MethodDevolution methodDevolution,
      String idOrder,
      String message
      ) async {
    this.isLoading = true;
    var header = {
      "Content-Type": "application/json".toString(),
      "X-WA-Auth-Token": prefs.authToken.toString()
    };

    Map<String,String> jsonData = {
      'reasonOpen': reason.valueTypeReason??'',
      'type': typeClaim.valueTypeClaim??'',
      'orderPackageDetailId': idOrder,
      "message":message,
      "methodDevolution":methodDevolution.valueMethodDevolution??''
    };
    final url = Uri.parse(Constants.baseURL + 'claim/create-claim');
    final request = http.MultipartRequest("POST", url);
    request.headers.addAll(header);
    if(picture.path.isNotEmpty){
      final mimeType = mime(picture.path)!.split('/');
      final multipartFile = await http.MultipartFile.fromPath('file', picture.path, contentType: MediaType(mimeType[0], mimeType[1]));
      request.files.add(multipartFile);
    }
    request.fields.addAll(jsonData);
    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      this.isLoading = false;
      if (decodeJson!['code'] == 100) {
        return decodeJson['message'];
      } else {
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }


}