
import '../domain.dart';

abstract class BrandDatasource {
  Future<List<Brand>> getBrands(String filter, int page);

  List<Brand> searchBrands(String filter);

}