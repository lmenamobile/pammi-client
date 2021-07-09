import '../Brand.dart';

class BrandProvider {
  BrandProvider({
    this.brand,
  });

  Brand brand;

  factory BrandProvider.fromJson(Map<String, dynamic> json) => BrandProvider(
    brand: json["brand"]==null?null:Brand.fromJson(json["brand"]),
  );

  Map<String, dynamic> toJson() => {
    "brand": brand.toJson(),
  };
}