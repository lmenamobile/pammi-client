
import '../domain.dart';

abstract class BrandRepository {
  Future<List<Brand>> getBrands(String filter, int page);

  List<Brand> searchBrands(String filter);

}