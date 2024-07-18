import '../domain.dart';

abstract class DepartmentDatasource {
  Future<List<Department>> getDepartments(String filter, int page);
}