
import '../../domain/domain.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDatasource remoteDatasource;

  CategoryRepositoryImpl({
    required this.remoteDatasource,
  });

  @override
  Future<List<Category>> getCategoriesByDepartment(int departmentId, String filter, int page) {
    return remoteDatasource.getCategoriesByDepartment(departmentId, filter, page);
  }


}