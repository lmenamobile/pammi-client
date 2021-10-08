class CreditCard {
  CreditCard({
    this.id,
    this.cardHolder,
    this.cardNumber,
    this.expirationMonth,
    this.expirationYear,
    this.token,
    this.franchise,
    this.status,
  });

  int? id;
  String? cardHolder;
  String? cardNumber;
  String? expirationMonth;
  String? expirationYear;
  String? token;
  String? franchise;
  String? status;

  factory CreditCard.fromJson(Map<String, dynamic> json) => CreditCard(
    id: json["id"],
    cardHolder: json["cardHolder"],
    cardNumber: json["cardNumber"],
    expirationMonth: json["expirationMonth"],
    expirationYear: json["expirationYear"],
    token: json["token"],
    franchise: json["franchise"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cardHolder": cardHolder,
    "cardNumber": cardNumber,
    "expirationMonth": expirationMonth,
    "expirationYear": expirationYear,
    "token": token,
    "franchise": franchise,
    "status": status,
  };
}
