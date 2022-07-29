class TotalCart {
  TotalCart({
    this.subtotal,
    this.iva,
    this.total,
    this.discount,
    this.discountCoupon,
    this.discountGiftCard,
    this.discountShipping,
  });

  String? subtotal;
  String? iva;
  String? total;
  String? discount;
  String? discountCoupon;
  String? discountGiftCard;
  String? discountShipping;

  factory TotalCart.fromJson(Map<String, dynamic> json) => TotalCart(
    subtotal: json["subtotal"].toString(),
    iva: json["iva"].toString(),
    total: json["total"].toString(),
    discount: json["discount"].toString(),
    discountCoupon: json["discountCoupon"].toString(),
    discountGiftCard: json["discountGiftcard"].toString(),
    discountShipping: json["discountShipping"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "subtotal": subtotal,
    "iva": iva,
    "total": total,
    "discount": discount,
    "discountCoupon": discountCoupon,
    "discountShipping": discountShipping,
  };
}
