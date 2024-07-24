
import '../../domain/domain.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDatasource remoteDataSource;


  ProductRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Product>> getProducts(int brandProvider, int categoryId, int subCategoryId, int page) {
    return remoteDataSource.getProducts(brandProvider, categoryId, subCategoryId, page);
  }
}