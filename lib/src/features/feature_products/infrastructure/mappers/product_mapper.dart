import '../../domain/domain.dart';
import '../infrastructure.dart';

class ProductMapper {

  static Product productToJsonEntity(Map<String, dynamic> json) {
    return Product(
      productId: json["id"],
      sku: json["sku"],
      nameProduct: json["product"],
      characteristics: json["characteristics"],
      linkVideo: json["linkVideo"],
      conditions: json["conditions"],
      featured: json["featured"],
      service: json["service"],
      applyDevolution: json["applyDevolution"],
      brandProvider: BrandProviderMapper.brandProviderToJsonEntity(json["brandProvider"]),
      warranty: WarrantyMapper.warrantyToJsonEntity(json["warranty"]),
    );
  }
}