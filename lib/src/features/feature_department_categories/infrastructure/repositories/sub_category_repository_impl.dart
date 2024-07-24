
import '../../domain/domain.dart';

class SubCategoryRepositoryImpl implements SubCategoryRepository {

  final SubCategoryDatasource remoteDatasource;

  SubCategoryRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<SubCategory>> getSubCategoriesByCategory(int categoryId, String filter, int page) {
    return remoteDatasource.getSubCategoriesByCategory(categoryId, filter, page);
  }

}