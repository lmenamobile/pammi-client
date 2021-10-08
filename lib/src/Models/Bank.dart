class Bank {
  Bank({
    this.bankCode,
    this.bankName,
    this.valStatus
  });

  String? bankCode;
  String? bankName;
  int? valStatus = -1;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    bankCode: json["bankCode"],
    bankName: json["bankName"],
  );

  Map<String, dynamic> toJson() => {
    "bankCode": bankCode,
    "bankName": bankName,
  };
}
