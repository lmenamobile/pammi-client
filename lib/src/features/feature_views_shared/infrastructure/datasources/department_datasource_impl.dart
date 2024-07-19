
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../Utils/Strings.dart';
import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';

class DepartmentDatasourceImpl implements DepartmentDatasource {
  @override
  Future<List<Department>> getDepartments( String filter, int page) async {
    Map jsonData = {
      "filter": filter,
      "offset": page,
      "limit": 30
    };
    var body = jsonEncode(jsonData);
    final response = await http.post(Uri.parse(ApiRoutes.categoryGetDepartments),
        headers: ApiHeaders().getHeaderAccessToken(), body: body)
        .timeout(ApiHeaders().timeOut)
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Department> departments = [];
      for (var item in decodeJson['data']['items']) {
        departments.add(DepartmentMapper.departmentJsonToEntity(item));
      }
      return departments;
    } else {
      throw decodeJson['message'];
    }
  }

}