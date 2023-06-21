class CountriesResponse {
  int? code;
  String? message;
  bool? status;
  DataCountries? data;


  CountriesResponse({
    this.code,
    this.message,
    this.status,
    this.data

  });

  CountriesResponse.fromJsonMap(Map<String,dynamic> json){
    code = json["code"];
    message= json["message"];
    status =json["status"];
    data = status! ? DataCountries.fromJsonMap(json["data"]):null;

  }

}

class DataCountries{
  int? totalPages;
  int? currentPage;
  List<Country>? countries;

  DataCountries({
    this.totalPages,
    this.currentPage

  });


  DataCountries.fromJsonMap(Map<String,dynamic> json){
    totalPages = json["totalPages"];
    currentPage = json["currentPage"];
    countries = List<Country>.from(json["items"].map((x) => Country.fromJsonMap(x)));

  }

}

class Country{
  String? id;
  String? country;
  String? callingCode;
  String? flag;
  String? currency;
  String? status;

  Country({
    this.id,
    this.country,
    this.callingCode,
    this.flag,
    this.currency,
    this.status
  });

  Country.fromJsonMap(Map<String,dynamic> json){
    id = json["id"];
    country = json["country"];
    callingCode = json["callingCode"];
    flag = json["flag"];
    currency = json["currency"];
    status = json["status"];

  }

}


class StatesResponse {
  int? code;
  String? message;
  bool? status;
  DataStates? data;


  StatesResponse({
    this.code,
    this.message,
    this.status,
    this.data

  });

  StatesResponse.fromJsonMap(Map<String,dynamic> json){
    code = json["code"];
    message= json["message"];
    status =json["status"];
    data = status! ? DataStates.fromJsonMap(json["data"]):null;

  }

}


class DataStates{
  int? totalPages;
  int? currentPage;
  List<States>? states;

  DataStates({
    this.totalPages,
    this.currentPage,
    this.states
  });


  DataStates.fromJsonMap(Map<String,dynamic> json){
    totalPages = json["totalPages"];
    currentPage = json["currentPage"];
    states = List<States>.from(json["items"].map((x) => States.fromJsonMap(x)));

  }

}


class States{
  int? id;
  String? name;
  int? totalCities;
  String? status;

  States({
    this.id,
    this.name,
    this.totalCities,
    this.status
  });

  States.fromJsonMap(Map<String,dynamic> json){
    id = json["id"];
    name = json["name"];
    totalCities = json["totalCities"];
    status = json["status"];

  }

}




class CitiesResponse {
  int? code;
  String? message;
  bool? status;
  DataCities? data;


  CitiesResponse({
    this.code,
    this.message,
    this.status,
    this.data

  });

  CitiesResponse.fromJsonMap(Map<String,dynamic> json){
    code = json["code"];
    message= json["message"];
    status =json["status"];
    data = status! ? DataCities.fromJsonMap(json["data"]):null;

  }

}


class DataCities{
  int? totalPages;
  int? currentPage;
  List<City>? cities;

  DataCities({
    this.totalPages,
    this.currentPage

  });


  DataCities.fromJsonMap(Map<String,dynamic> json){
    totalPages = json["totalPages"];
    currentPage = json["currentPage"];
    cities = List<City>.from(json["items"].map((x) => City.fromJsonMap(x)));

  }

}


class City{
  int? id;
  String? name;
  String? name2;
  int? totalZones;
  String? status;

  City({
    this.id,
    this.name,
    this.name2,
    this.totalZones,
    this.status
  });

  City.fromJsonMap(Map<String,dynamic> json){
    id = json["id"];
    name = json["name"];
    name2 = json["name2"];
    status = json["status"];
    totalZones = json["totalZones"];


  }

}