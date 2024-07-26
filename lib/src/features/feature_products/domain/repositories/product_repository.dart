import '../domain.dart';

abstract class ProductRepository {

  Future<List<Product>> getProducts(int? brandProvider,int? categoryId,int? subCategoryId,int page,List<int> filterIds);

}