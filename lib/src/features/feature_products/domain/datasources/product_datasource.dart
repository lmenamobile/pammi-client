import '../domain.dart';

abstract class ProductDatasource {

  Future<List<Product>> getProducts(int? brandProvider,int? categoryId,int? subCategoryId,int page,List<int>? filterIds);

}