class TotalProductOffer {
  TotalProductOffer({
    this.status,
    this.price,
    this.priceWithDiscount,
    this.discountValue
  });

  bool? status;
  String? price;
  String? priceWithDiscount;
  String? discountValue;

  factory TotalProductOffer.fromJson(Map<String, dynamic> json) => TotalProductOffer(
    status: json["status"],
    price: json["price"].toString(),
    priceWithDiscount: json["priceWithDiscount"].toString(),
    discountValue: json["discountValue"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "price": price,
    "priceWithDiscount": priceWithDiscount,
  };
}