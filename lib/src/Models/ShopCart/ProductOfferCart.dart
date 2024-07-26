

class ProductOfferCart {
  ProductOfferCart({
    this.id,
    //this.reference,
  });

  int? id;
  //Reference? reference;

  factory ProductOfferCart.fromJson(Map<String, dynamic> json) => ProductOfferCart(
    id: json["id"],
    //reference: Reference.fromJson(json["reference"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    //"reference": reference!.toJson(),
  };
}