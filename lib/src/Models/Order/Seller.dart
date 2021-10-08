class Seller {
  Seller({
    this.id,
    this.fullName,
    this.identification,
    this.email,
    this.photoUrl,
    this.societyType,
    this.legalRepresentative,
    this.document,
    this.address,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.type,
    this.typeSeller,
    this.qualification,
  });

  String? id;
  String? fullName;
  String? identification;
  String? email;
  String? photoUrl;
  String? societyType;
  String? legalRepresentative;
  String? document;
  String? address;
  String? latitude;
  String? longitude;
  String? phoneNumber;
  String? type;
  String? typeSeller;
  String? qualification;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    id: json["id"],
    fullName: json["fullname"],
    identification: json["identification"],
    email: json["email"],
    photoUrl: json["photoUrl"],
    societyType: json["societyType"],
    legalRepresentative: json["legalRepresentative"],
    document: json["document"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    phoneNumber: json["phoneNumber"],
    type: json["type"],
    typeSeller: json["typeSeller"],
    qualification: json["qualification"].toString(),
  );


}
