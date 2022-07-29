import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wawamko/src/Models/Address.dart';
import 'package:wawamko/src/Models/Bank.dart';
import 'package:wawamko/src/Models/CreditCard.dart';
import 'package:wawamko/src/Models/Payment/ResponseAddi.dart';
import 'package:wawamko/src/Models/Payment/ResponseEfecty.dart';
import 'package:wawamko/src/Models/Payment/ResponsePSE.dart';
import 'package:wawamko/src/Models/PaymentMethod.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:http/http.dart' as http;

class ProviderCheckOut with ChangeNotifier {
  final prefs = SharePreference();

  bool _isLoading = false;

  bool get isLoading => this._isLoading;

  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  bool _isValidateGift = false;

  bool get isValidateGift => this._isValidateGift;

  set isValidateGift(bool value) {
    this._isValidateGift = value;
    notifyListeners();
  }

  bool _isValidateDiscount = false;

  bool get isValidateDiscount => this._isValidateDiscount;

  set isValidateDiscount(bool value) {
    this._isValidateDiscount = value;
    notifyListeners();
  }

  Bank? _bankSelected;

  Bank? get bankSelected => this._bankSelected;

  set bankSelected(Bank? value) {
    this._bankSelected = value;
    notifyListeners();
  }

  PaymentMethod? _paymentSelected;

  PaymentMethod? get paymentSelected => this._paymentSelected;

  set paymentSelected(PaymentMethod? value) {
    this._paymentSelected = value;
    notifyListeners();
  }

  ResponseEfecty? _efecty;

  ResponseEfecty? get efecty => this._efecty;

  set efecty(ResponseEfecty? value) {
    this._efecty = value;
    notifyListeners();
  }

  ResponsePse? _paymentPSE;

  ResponsePse? get paymentPSE => this._paymentPSE;

  set paymentPSE(ResponsePse? value) {
    this._paymentPSE = value;
    notifyListeners();
  }

  ResponseAddi? _paymentADDI;

  ResponseAddi? get paymentADDI => this._paymentADDI;

  set paymentADDI(ResponseAddi? value) {
    this._paymentADDI = value;
    notifyListeners();
  }

  CreditCard? _creditCardSelected;

  CreditCard? get creditCardSelected => this._creditCardSelected;

  set creditCardSelected(CreditCard? value) {
    this._creditCardSelected = value;
    notifyListeners();
  }

  Address? _addressSelected;

  Address? get addressSelected => this._addressSelected;

  set addressSelected(Address? value) {
    this._addressSelected = value;
    notifyListeners();
  }

  List<PaymentMethod> _ltsPaymentMethod = [];

  List<PaymentMethod> get ltsPaymentMethod => this._ltsPaymentMethod;

  clearValuesPayment(){
    this.bankSelected = null;
    this.addressSelected = null;
    this.creditCardSelected = null;
    this.paymentSelected = null;
    this.shippingPrice = '0';
  }

  set ltsPaymentMethod(List<PaymentMethod> value) {
    this._ltsPaymentMethod = value;
    notifyListeners();
  }

  String _shippingPrice = "0";

  String get shippingPrice => this._shippingPrice;

  set shippingPrice(String value) {
    this._shippingPrice = value;
    notifyListeners();
  }

  Future getPaymentMethods() async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Access-Token": prefs.accessToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty
          ? "CO"
          : prefs.countryIdUser.toString(),
    };
    final response = await http
        .get(Uri.parse(Constants.baseURL + "system/get-methods-payment"), headers: header)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    final List<PaymentMethod> listPayments = [];
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        for (var item in decodeJson['data']['items']) {
          final payment = PaymentMethod.fromJson(item);
          listPayments.add(payment);
        }
        this.isLoading = false;
        this._ltsPaymentMethod = listPayments;
        return listPayments;
      } else {
        this.isLoading = false;
        throw decodeJson['message'];
      }
    } else {
      this.isLoading = false;
      throw decodeJson!['message'];
    }
  }

  Future applyCoupon(String coupon) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty
          ? "CO"
          : prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      "couponCode": coupon,
      "countryId": prefs.countryIdUser.toString()
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "cart/apply-coupon"),
            headers: header, body: body)
        .timeout(Duration(seconds: 15))
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

  Future deleteCoupon() async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty
          ? "CO"
          : prefs.countryIdUser.toString(),
    };
    final response = await http
        .delete(Uri.parse(Constants.baseURL + "cart/delete-coupon"), headers: header)
        .timeout(Duration(seconds: 15))
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

  Future applyGiftCard(String gift) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty
          ? "CO"
          : prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      "giftcardCode":gift,
      "countryId": prefs.countryIdUser.toString()
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "cart/apply-giftcard"),
        headers: header, body: body)
        .timeout(Duration(seconds: 15))
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

  Future deleteGiftCard() async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty
          ? "CO"
          : prefs.countryIdUser.toString(),
    };
    final response = await http
        .delete(Uri.parse(Constants.baseURL + "cart/delete-giftcard"), headers: header)
        .timeout(Duration(seconds: 15))
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

  Future createOrder(String paymentMethodId, String addressId, String? bankId,
      String creditCardId,String shippingValue, String discountShipping) async {
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty
          ? "CO"
          : prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      "methodPaymentId": paymentMethodId,
      "addressId": addressId,
      "userPaymentMethodId": creditCardId,
      "bankId": bankId,
      "shippingValue": shippingValue,
      "discountShipping": discountShipping,
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "payment/create-order"),
            headers: header, body: body)
        .timeout(Duration(seconds: 40))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        if (paymentMethodId == Constants.paymentCreditCard.toString()) {
          return decodeJson['message'];
        } else if (paymentMethodId == Constants.paymentCash.toString()) {
          return decodeJson['message'];
        }  else if (paymentMethodId == Constants.paymentEfecty.toString()||paymentMethodId == Constants.paymentBaloto.toString()) {
          this.efecty = ResponseEfecty.fromJson(decodeJson['data']['response']['data']);
          return decodeJson['message'];
        } else if (paymentMethodId == Constants.paymentPSE.toString()) {
          this.paymentPSE = ResponsePse.fromJson(decodeJson['data']['response']['data']);
          return decodeJson['message'];
        } else if (paymentMethodId == Constants.paymentADDI.toString()) {
          this.paymentADDI = ResponseAddi.fromJson(decodeJson['data']);
          return decodeJson['message'];
        }
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

  Future calculateShippingPrice(String addressId)async{
    this.isLoading = true;
    final header = {
      "Content-Type": "application/json",
      "X-WA-Auth-Token": prefs.authToken.toString(),
      "country": prefs.countryIdUser.toString().isEmpty ? "CO" : prefs.countryIdUser.toString(),
    };
    Map jsonData = {
      "addressId": addressId
    };
    var body = jsonEncode(jsonData);
    final response = await http
        .post(Uri.parse(Constants.baseURL + "payment/get-shipping-value"), headers: header,body: body)
        .timeout(Duration(seconds: 15))
        .catchError((value) {
      this.isLoading = false;
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic>? decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      if (decodeJson!['code'] == 100) {
        this.isLoading = false;
        this.shippingPrice = decodeJson['data']['shippingValue'].toString();
        return decodeJson['data']['shippingValue'].toString();
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
