import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../Utils/Strings.dart';
import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';

class SubCategoryDatasourceImpl implements SubCategoryDatasource {
  @override
  Future<List<SubCategory>> getSubCategoriesByCategory(int categoryId, String filter, int page) async {
    Map jsonData = {
      "filter": filter,
      "categoryId": categoryId,
      "offset": page,
      "limit": 30
    };
    final response = await http.post(Uri.parse(ApiRoutes.getSubCategoriesByCategory),
        headers: ApiHeaders().getHeaderAccessToken(), body: jsonEncode(jsonData))
        .timeout(ApiHeaders().timeOut)
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<SubCategory> subCategories = [];
      for (var item in data['data']['items']) {
        subCategories.add(SubCategoryMapper.subCategoryFromJsonToEntity(item));
      }
      return subCategories;
    } else {
      throw data['message'];
    }
  }

}