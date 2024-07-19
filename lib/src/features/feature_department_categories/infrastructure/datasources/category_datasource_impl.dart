import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../Utils/Strings.dart';
import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';

class CategoryDatasourceImpl implements CategoryDatasource {
  @override
  Future<List<Category>> getCategoriesByDepartment(int departmentId, String filter, int page) async {
    Map jsonData = {
      "filter": filter,
      "departmentId": departmentId,
      "offset": page,
      "limit": 30
    };
    final response = await http.post(Uri.parse(ApiRoutes.getCategoriesByDepartment),
        headers: ApiHeaders().getHeaderAccessToken(), body: jsonEncode(jsonData))
        .timeout(ApiHeaders().timeOut)
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<Category> categories = [];
      for (var item in data['data']['items']) {
        categories.add(CategoryMapper.categoryFromJsonToEntity(item));
      }
      return categories;
    } else {
      throw data['message'];
    }
  }

}