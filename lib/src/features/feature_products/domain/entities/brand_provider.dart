
import '../../../feature_views_shared/domain/domain.dart';

class BrandProvider {
  final int brandProviderId;
  final Brand brand;


  BrandProvider({
    required this.brandProviderId,
    required this.brand
  });

  @override
  String toString() {
    return 'BrandProvider(brandProviderId: $brandProviderId, brand: $brand)';
  }

}