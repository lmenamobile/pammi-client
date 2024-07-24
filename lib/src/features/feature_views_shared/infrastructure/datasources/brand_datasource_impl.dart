import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../Utils/Strings.dart';
import '../../../../Utils/share_preference.dart';
import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';

class BrandDatasourceImpl implements BrandDatasource {

  final prefs = SharePreference();

  List<Brand> _brands = [];

  @override
  Future<List<Brand>> getBrands(String filter, int page) async {
    Map jsonData = {
      "filter": filter,
      "offset": page,
      "limit": 30,
    };

    final response = await http.post(Uri.parse(ApiRoutes.getBrands),
        headers: ApiHeaders().getHeaderAccessToken(), body: jsonEncode(jsonData))
        .timeout(ApiHeaders().timeOut)
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Brand> brands = [];
      for (var item in decodeJson['data']['items']) {
        brands.add(BrandMapper.brandJsonToEntity(item));
      }
      _brands = brands;
      return brands;
    } else {
      throw decodeJson['message'];
    }

  }

  @override
  List<Brand> searchBrands(String query) {
    return _brands.where((brand) => brand.brand.toLowerCase().contains(query.toLowerCase())).toList();
  }



}