import '../../domain/domain.dart';

class BrandProviderMapper {

  static BrandProvider brandProviderToJsonEntity(Map<String, dynamic> json) {
    return BrandProvider(
      brandProviderId: json["id"],
      brand: json["brand"],
    );
  }
}