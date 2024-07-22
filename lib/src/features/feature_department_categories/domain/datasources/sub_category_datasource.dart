
import '../domain.dart';

abstract class SubCategoryDatasource {

  Future<List<SubCategory>> getSubCategoriesByCategory(int categoryId, String filter,int page);
}