
import '../../domain/domain.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  final DepartmentDatasource remoteDataSource;


  DepartmentRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Department>> getDepartments() {
    // TODO: implement getDepartments
    throw UnimplementedError();
  }


}