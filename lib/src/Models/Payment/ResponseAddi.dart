class ResponseAddi {
  ResponseAddi({
    this.urlRedirectLocation,
    this.status,
    this.order,
  });

  String? urlRedirectLocation;
  String? status;
  int? order;

  factory ResponseAddi.fromJson(Map<String, dynamic> json) => ResponseAddi(
    urlRedirectLocation: json["urlRedirectLocation"],
    status: json["status"],
    order: json["order"],
  );

  Map<String, dynamic> toJson() => {
    "urlRedirectLocation": urlRedirectLocation,
    "status": status,
    "order": order,
  };
}