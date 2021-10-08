

import 'City.dart';

class UserProfile {
  UserProfile({
    this.id,
    this.fullname,
    this.email,
    this.documentType,
    this.document,
    this.photoUrl,
    this.phone,
    this.identyIos,
    this.verifyedAccount,
    this.type,
    this.verificationCode,
    this.city
  });

  String? id;
  String? fullname;
  String? email;
  String? documentType;
  String? document;
  String? photoUrl;
  String? phone;
  String? identyIos;
  bool? verifyedAccount;
  String? type;
  String? verificationCode;
  City? city;


  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json["id"],
    fullname: json["fullname"],
    email: json["email"],
    documentType: json["documentType"],
    document: json["document"],
    photoUrl: json["photoUrl"],
    phone: json["phone"],
    identyIos: json["identyIos"],
    verifyedAccount: json["verifyedAccount"],
    type: json["type"],
    verificationCode: json["verificationCode"],
    city:json["city"]==null?null: City.fromJson(json["city"]),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullname": fullname,
    "email": email,
    "documentType": documentType,
    "document": document,
    "photoUrl": photoUrl,
    "phone": phone,
    "identyIos": identyIos,
    "verifyedAccount": verifyedAccount,
    "type": type,
    "verificationCode": verificationCode,
    "city": city!.toJson(),
  };
}