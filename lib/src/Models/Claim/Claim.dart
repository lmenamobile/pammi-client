class Claim {
  Claim({
    this.id,
    this.reasonOpen,
    this.type,
    this.message,
    this.image,
    this.state,
    this.reasonClose,
    this.closeDate,
    this.methodDevolution,
    this.devolutionState,
    this.guide,
    this.optionsDates,
    this.orderPackageDetail,
  });

  int? id;
  String? reasonOpen;
  String? type;
  String? message;
  String? image;
  String? state;
  String? reasonClose;
  DateTime? closeDate;
  String? methodDevolution;
  String? devolutionState;
  String? guide;
  Options? optionsDates;
  OrderPackageDetail? orderPackageDetail;

  factory Claim.fromJson(Map<String, dynamic> json) => Claim(
    id: json["id"],
    reasonOpen: json["reasonOpen"],
    type: json["type"],
    message: json["message"],
    image: json["image"],
    state: json["state"],
    reasonClose: json["reasonClose"]??'',
    closeDate: json["closeDate"]==null?null:DateTime.parse(json["closeDate"]),
    methodDevolution: json["methodDevolution"],
    devolutionState: json["devolutionState"],
    guide: json["guide"],
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
    this.total,
  });

  String? total;

  factory OrderPackageDetail.fromJson(Map<String, dynamic> json) => OrderPackageDetail(
    total: json["total"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
  };
}
