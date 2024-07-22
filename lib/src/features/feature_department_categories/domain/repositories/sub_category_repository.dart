
import '../domain.dart';

abstract class SubCategoryRepository {

  Future<List<SubCategory>> getSubCategoriesByCategory(int categoryId, String filter,int page);

}