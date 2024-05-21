import 'package:wawamko/src/Models/Order/PackageProvider.dart';
import 'package:wawamko/src/Models/PaymentMethod.dart';

import 'Seller.dart';

class OrderDetail {
  OrderDetail({
    this.id,
    this.subtotal,
    this.tax,
    this.total,
    this.discountCoupon,
    this.discountGiftCard,
    this.shippingValue,
    this.discountShipping,
    this.shippingAddress,
    this.status,
    this.seller,
    this.packagesProvider,
    this.paymentMethod
  });

  int? id;
  String? subtotal;
  String? tax;
  String? total;
  String? discountCoupon;
  String? discountGiftCard;
  String? shippingValue;
  num? discountShipping;
  String? shippingAddress;
  String? status;
  Seller? seller;
  PaymentMethod? paymentMethod;
  List<PackageProvider>? packagesProvider;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    id: json["id"],
    subtotal: json["subtotal"].toString(),
    tax: json["tax"].toString(),
    total: json["total"].toString(),
    discountCoupon: json["discountCoupon"].toString(),
    discountGiftCard: json["discountGiftcard"].toString(),
    shippingValue: json["shippingValue"].toString(),
    discountShipping: json["discountShipping"] == null ? null : json["discountShipping"],
    shippingAddress: json["shippingAddress"] == null ? null : json["shippingAddress"],
    status: json["status"],
    seller: json["seller"] == null ? null : Seller.fromJson( json["seller"]),
    paymentMethod:json["systemMethodPayment"] == null? null: PaymentMethod.fromJson(json["systemMethodPayment"]),
    packagesProvider: json["packages"] == null ? null : List<PackageProvider>.from(json["packages"].map((x) => PackageProvider.fromJson(x))),
  );


}

