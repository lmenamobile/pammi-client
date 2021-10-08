class ProviderProduct {
  ProviderProduct({
    this.id,
    this.identification,
    this.businessName,
    this.providerEmail,
    this.addressCompany,
    this.telephoneCompany,
    this.qualification
  });

  int? id;
  String? identification;
  String? businessName;
  String? providerEmail;
  String? addressCompany;
  String? telephoneCompany;
  String? qualification;

  factory ProviderProduct.fromJson(Map<String, dynamic> json) => ProviderProduct(
    id: json["id"],
    identification: json["identification"],
    businessName: json["businessName"],
    providerEmail: json["providerEmail"],
    addressCompany: json["addressCompany"],
    telephoneCompany: json["telephoneCompany"],
    qualification: json["qualification"]==null?'0':json["qualification"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "identification": identification,
    "businessName": businessName,
    "providerEmail": providerEmail,
    "addressCompany": addressCompany,
    "telephoneCompany": telephoneCompany,
  };
}