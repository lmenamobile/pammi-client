
import 'package:wawamko/src/Models/Product/Reference.dart';

class DetailClaim {
  DetailClaim({
    this.id,
    this.reasonOpen,
    this.type,
    this.message,
    this.image,
    this.approvalNumber,
    this.state,
    this.reasonClose,
    this.closeDate,
    this.methodDevolution,
    this.devolutionState,
    this.guide,
    this.optionsDates,
    this.orderPackageDetail,
  });

  String? id;
  String? reasonOpen;
  String? type;
  String? message;
  String? image;
  String? approvalNumber;
  String? state;
  String? reasonClose;
  DateTime? closeDate;
  String? methodDevolution;
  String? devolutionState;
  String? guide;
  Options? optionsDates;
  OrderPackageDetail? orderPackageDetail;

  factory DetailClaim.fromJson(Map<String, dynamic> json) => DetailClaim(
    id: json["id"].toString(),
    reasonOpen: json["reasonOpen"],
    type: json["type"],
    message: json["message"],
    image: json["image"],
    approvalNumber: json["approvalNumber"],
    state: json["state"],
    reasonClose: json["reasonClose"]==null?'':json["reasonClose"],
    closeDate: json["closeDate"]==null?null :DateTime.parse(json["closeDate"]),
    methodDevolution: json["methodDevolution"],
    devolutionState: json["devolutionState"],
    guide: json["guide"]??'',
    optionsDates: Options.fromJson(json["options"]),
    orderPackageDetail: OrderPackageDetail.fromJson(json["orderPackageDetail"]),
  );


}

class Options {
  Options({
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Options.fromJson(Map<String, dynamic> json) => Options(
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );


}

class OrderPackageDetail {
  OrderPackageDetail({
    this.nameProduct,
    this.qty,
    this.price,
    this.total,
    this.reference,
  });

  String? nameProduct;
  String? qty;
  String? price;
  String? total;
  Reference? reference;

  factory OrderPackageDetail.fromJson(Map<String, dynamic> json) => OrderPackageDetail(
    nameProduct: json["name"],
    qty: json["qty"].toString(),
    price: json["price"].toString(),
    total: json["total"].toString(),
    reference: Reference.fromJson(json["reference"]),
  );


}

class Warranty {
  Warranty({
    this.warrantyProduct,
    this.provider,
  });

  String? warrantyProduct;
  Provider? provider;

  factory Warranty.fromJson(Map<String, dynamic> json) => Warranty(
    warrantyProduct: json["warrantyProduct"],
    provider: json["provider"]==null?null:Provider.fromJson(json["provider"]),
  );


}

class Provider {
  Provider({
    this.id,
    this.businessName,
  });

  String? id;
  String? businessName;

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
    id: json["id"].toString(),
    businessName: json["businessName"],
  );


}



