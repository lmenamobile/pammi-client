class TotalCart {
  TotalCart({
    this.subtotal,
    this.iva,
    this.total,
    this.discount,
    this.discountCoupon,
  });

  String subtotal;
  String iva;
  String total;
  String discount;
  String discountCoupon;

  factory TotalCart.fromJson(Map<String, dynamic> json) => TotalCart(
    subtotal: json["subtotal"].toString(),
    iva: json["iva"].toString(),
    total: json["total"].toString(),
    discount: json["discount"].toString(),
    discountCoupon: json["discountCoupon"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "subtotal": subtotal,
    "iva": iva,
    "total": total,
    "discount": discount,
    "discountCoupon": discountCoupon,
  };
}
