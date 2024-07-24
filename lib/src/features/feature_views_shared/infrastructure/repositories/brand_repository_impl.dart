
import '../../domain/domain.dart';

class BrandRepositoryImpl extends BrandRepository {
  final BrandDatasource remoteDataSource;


  BrandRepositoryImpl({
    required this.remoteDataSource,

  });

  @override
  Future<List<Brand>> getBrands(String filter, int page) {
    return remoteDataSource.getBrands(filter, page);
  }

  @override
  List<Brand> searchBrands(String filter) {
    return remoteDataSource.searchBrands(filter);
  }


}