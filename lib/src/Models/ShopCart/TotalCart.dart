class TotalCart {
  TotalCart({
    this.subtotal,
    this.iva,
    this.total,
    this.discount,
    this.discountCoupon,
    this.discountGiftCard
  });

  String subtotal;
  String iva;
  String total;
  String discount;
  String discountCoupon;
  String discountGiftCard;

  factory TotalCart.fromJson(Map<String, dynamic> json) => TotalCart(
    subtotal: json["subtotal"].toString(),
    iva: json["iva"].toString(),
    total: json["total"].toString(),
    discount: json["discount"].toString(),
    discountCoupon: json["discountCoupon"].toString(),
    discountGiftCard: json["discountGiftcard"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "subtotal": subtotal,
    "iva": iva,
    "total": total,
    "discount": discount,
    "discountCoupon": discountCoupon,
  };
}
