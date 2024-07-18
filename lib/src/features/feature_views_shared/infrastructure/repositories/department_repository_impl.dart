
import 'dart:async';
import 'dart:io';

import '../../domain/domain.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  final DepartmentDatasource remoteDataSource;


  DepartmentRepositoryImpl({
    required this.remoteDataSource,
  });


  @override
  Future<List<Department>> getDepartments(String filter, int page) async {
    try {
      final departments = await remoteDataSource.getDepartments(filter, page);
      return departments;
    } catch (e) {
      // Aquí podemos manejar o transformar errores si es necesario
      // Por ejemplo, podríamos mapear excepciones específicas a nuestros propios tipos de error
      if (e is TimeoutException) {
        throw 'La conexión ha expirado';
      } else if (e is HttpException) {
        throw 'Error del servidor: ${e.message}';
      }
      rethrow;
    }
  }


}