class PackageCart {
  PackageCart({
    this.total,
    this.subtotal,
    this.tax,
  });

  int? total;
  int? subtotal;
  int? tax;

  factory PackageCart.fromJson(Map<String, dynamic> json) => PackageCart(
    total: json["total"] == null ? null : json["total"],
    subtotal: json["subtotal"] == null ? null : json["subtotal"],
    tax: json["tax"] == null ? null : json["tax"],
  );

  Map<String, dynamic> toJson() => {
    "total": total == null ? null : total,
    "subtotal": subtotal == null ? null : subtotal,
    "tax": tax == null ? null : tax,
  };
}