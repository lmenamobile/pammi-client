
import 'package:wawamko/src/Models/Product/Reference.dart';

class ProductProvider {
  ProductProvider({
    this.id,
    this.name,
    this.qty,
    this.price,
    this.total,
    this.reference,
  });

  int id;
  String name;
  String qty;
  String price;
  String total;
  Reference reference;

  factory ProductProvider.fromJson(Map<String, dynamic> json) => ProductProvider(
    id: json["id"],
    name: json["name"],
    qty: json["qty"].toString(),
    price: json["price"].toString(),
    total: json["total"].toString(),
    reference: Reference.fromJson(json["reference"]),
  );


}