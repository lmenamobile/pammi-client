
import '../domain.dart';

abstract class DepartmentRepository {
  Future<List<Department>> getDepartments(String filter, int page);
}