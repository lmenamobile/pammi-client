


import '../domain.dart';

abstract class CategoryDatasource {

  Future<List<Category>> getCategoriesByDepartment(int departmentId, String filter,int page);

}