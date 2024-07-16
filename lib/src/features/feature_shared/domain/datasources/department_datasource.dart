import '../domain.dart';

abstract class DepartmentDatasource {
  Future<List<Department>> getDepartments();
}