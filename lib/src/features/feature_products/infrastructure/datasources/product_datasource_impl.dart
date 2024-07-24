import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../Utils/Strings.dart';
import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';

class ProductDatasourceImpl implements ProductDatasource {
  @override
  Future<List<Product>> getProducts(int brandProvider, int categoryId,
      int subCategoryId, int page,List<int> filterIds) async {
    Map jsonData = {
      "filter": "",
      "limit": 30,
      "offset": page,
      "brandProviderId": brandProvider,
      "categoryId": categoryId,
      "subCategoryId": subCategoryId,
      "filterIds": filterIds
    };

    final response = await http.post(Uri.parse(ApiRoutes.getProducts),
        headers: ApiHeaders().getHeaderAccessToken(), body: jsonEncode(jsonData))
        .timeout(ApiHeaders().timeOut)
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });

    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<Product> products = [];
      for (var item in data['data']['items']) {
        products.add(ProductMapper.productToJsonEntity(item));
      }
      return products;
    } else {
      throw data['message'];
    }

  }
}
