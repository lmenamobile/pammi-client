

class ResponseAccessToken{
  int code;
  String message;
  bool status;
  DataAccesToken data;

  ResponseAccessToken.fromJsonMap(Map<String,dynamic> json){
    code = json["code"];
    message = json["message"];
    status = json["status"];
    data = status ? DataAccesToken.fromJsonMap(json["data"]): null;

  }



}


class DataAccesToken{
  String accessToken;

  DataAccesToken({
    this.accessToken
  });

  DataAccesToken.fromJsonMap(Map<String,dynamic> json){
    accessToken = json["accessToken"];

  }


}

class ForgetPassResponse{
  int code;
  String message;
  bool status;


  ForgetPassResponse({
    this.code,
    this.message,
    this.status
  });

  ForgetPassResponse.fromJsonMap(Map<String,dynamic> json){
    code = json["code"];
    message = json["message"];
    status = json["status"];

  }

}


class VerifyCodeResponse{
  int code;
  String message;
  bool status;
  DataUser data;

  VerifyCodeResponse({
    this.code,
    this.message,
    this.status
});

  VerifyCodeResponse.fromJsonMap(Map<String,dynamic> json){
    code = json["code"];
    message = json["message"];
    status = json["status"];
    data = status ? DataUser.fromJsonMap(json["data"]): null;



  }

}

class ResponseUserinfo {
  int code;
  String message;
  bool status;
  DataUser data;


  ResponseUserinfo(
  {
   this.code,
   this.message,
   this.status,
   this.data,

  });

  ResponseUserinfo.fromJsonMap(Map<String,dynamic> json){
    code = json["code"];
    message = json["message"];
    status = json["status"];
    data =  status ? DataUser.fromJsonMap(json["data"]) : null;


  }

}

class DataUser {
 UserResponse user;
 String authToken;
 DataUser({
   this.user,
   this.authToken
});

 DataUser.fromJsonMap(Map<String,dynamic> json){
   user = UserResponse.fromJsonMap(json["user"]);
   authToken = json["authToken"];
 }
 }


class UserResponse {
  String fullname;
  String email;
  String phone;
  String documentType;
  String document;
  int cityId;
  String id;
  String birthDate;
  String identification;
  String photoUrl;
  String societyType;
  String legalRepresentative;
  String address;
  String latitude;
  String longitude;
  String phoneNumber;
  String referredCode;
  bool acceptTerms;
  String step;
  String type;
  String typeSeller;
  String verificationCode;
  bool verifyedAccount;

  UserResponse({
    this.verifyedAccount,
    this.fullname,
    this.email,
    this.phone,
    this.documentType,
    this.document,
    this.cityId,
    this.id,
    this.birthDate,
    this.identification,
    this.photoUrl,
    this.societyType,
    this.legalRepresentative,
    this.address,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.referredCode,
    this.acceptTerms,
    this.step,
    this.type,
    this.typeSeller,
    this.verificationCode
  });


  UserResponse.fromJsonMap(Map<String,dynamic> json){
    verifyedAccount = json["verifyedAccount"];
    fullname = json["fullname"];
    email = json["email"];
    phone = json["phone"];
    documentType = json["documentType"];
    document = json["document"];
    cityId = json["cityId"];
    id = json["id"];
    birthDate = json["birthDate"];
    identification = json["identification"];
    photoUrl = json["photoUrl"];
    societyType = json["societyType"];
    legalRepresentative = json["legalRepresentative"];
    address = json["address"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    phoneNumber = json["phoneNumber"];
    referredCode = json["referredCode"];
    acceptTerms = json["acceptTerms"];
    step = json["step"];
    type = json["type"];
    typeSeller = json["typeSeller"];
    verificationCode = json["verificationCode"];

  }

  Map<String, dynamic> toJson() => {
    "verifyedAccount":verifyedAccount,
    "verificationCode": verificationCode,
    "typeSeller": typeSeller,
    "type": type,
    "step":step,
    "acceptTerms": acceptTerms,
    "referredCode":referredCode,
    "phoneNumber":phoneNumber,
    "longitude": longitude,
    "latitude":latitude,
    "address":address,
    "legalRepresentative":legalRepresentative,
    "societyType":societyType,
    "photoUrl":photoUrl,
    "identification":identification,
    "birthDate":birthDate,
    "id":id,
    "cityId":cityId,
    "document":document,
    "documentType":documentType,
    "phone":phone,
    "email":email,
    "fullname":fullname,
  };

}


class UserModel{
  String name;
  String lastName;
  String typeDoc;
  String numDoc;
  String country;
  String numPhone;
  String passWord;
  String email;
  int cityId;

  UserModel({
    this.name,
    this.lastName,
    this.typeDoc,
    this.numDoc,
    this.country,
    this.numPhone,
    this.passWord,
    this.email,
    this.cityId
  });
}