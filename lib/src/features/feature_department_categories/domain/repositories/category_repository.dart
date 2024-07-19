


import '../domain.dart';

abstract class CategoryRepository {

  Future<List<Category>> getCategoriesByDepartment(int departmentId, String filter,int page);

}