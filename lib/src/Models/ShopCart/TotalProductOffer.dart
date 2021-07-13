class TotalProductOffer {
  TotalProductOffer({
    this.status,
    this.price,
    this.priceWithDiscount,
  });

  bool status;
  String price;
  String priceWithDiscount;

  factory TotalProductOffer.fromJson(Map<String, dynamic> json) => TotalProductOffer(
    status: json["status"],
    price: json["price"].toString(),
    priceWithDiscount: json["priceWithDiscount"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "price": price,
    "priceWithDiscount": priceWithDiscount,
  };
}