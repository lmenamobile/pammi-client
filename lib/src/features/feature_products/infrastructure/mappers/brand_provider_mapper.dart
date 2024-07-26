

import '../../../feature_views_shared/feature_views_shared.dart';
import '../../domain/domain.dart';

class BrandProviderMapper {

  static BrandProvider brandProviderToJsonEntity(Map<String, dynamic> json) {
    return BrandProvider(
      brandProviderId: json["id"],
      brand: BrandMapper.brandJsonToEntity(json["brand"]),
    );
  }
}