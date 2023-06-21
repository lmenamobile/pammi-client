import 'package:wawamko/src/Models/PaymentMethod.dart';

class Order {
  Order({
    this.id,
    this.subtotal,
    this.tax,
    this.total,
    this.discountCoupon,
    this.discountGiftCard,
    this.shippingValue,
    this.shippingAddress,
    this.status,
    this.cardNumber,
    this.franchise,
    this.paymentMethod,
    this.createdAt
  });

  int? id;
  String? subtotal;
  String? tax;
  String? total;
  String? discountCoupon;
  String? discountGiftCard;
  String? shippingValue;
  String? shippingAddress;
  String? status;
  String? cardNumber;
  String? franchise;
  PaymentMethod? paymentMethod;
  DateTime? createdAt;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    subtotal: json["subtotal"].toString(),
    tax: json["tax"].toString(),
    total: json["total"].toString(),
    discountCoupon: json["discountCoupon"].toString(),
    discountGiftCard: json["discountGiftcard"].toString(),
    shippingValue: json["shippingValue"].toString(),
    shippingAddress: json["shippingAddress"],
    status: json["status"],
    cardNumber: json["cardNumber"],
    franchise: json["franchise"],
    paymentMethod: PaymentMethod.fromJson(json["systemMethodPayment"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subtotal": subtotal,
    "tax": tax,
    "total": total,
    "discountCoupon": discountCoupon,
    "discountGiftcard": discountGiftCard,
    "shippingValue": shippingValue,
    "shippingAddress": shippingAddress,
    "status": status,
    "cardNumber": cardNumber,
    "franchise": franchise,
  };
}
