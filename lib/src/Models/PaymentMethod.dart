class PaymentMethod {
  PaymentMethod({
    this.id,
    this.methodPayment,
    this.image,
    this.status,
  });

  int id;
  String methodPayment;
  String image;
  String status;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json["id"],
    methodPayment: json["methodPayment"],
    image: json["image"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "methodPayment": methodPayment,
    "image": image,
    "status": status,
  };
}
