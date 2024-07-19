import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../Utils/Strings.dart';
import '../../../../Utils/share_preference.dart';
import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';

class BannerDatasourceImpl implements BannerDatasource {

  final prefs = SharePreference();

  @override
  Future<List<Banners>> getBanners( String typeBanner, int page) async {
    Map jsonData = {
      "filter":"",
      "type": typeBanner,
      "offset": page,
      "limit": 30
    };
    final response = await http.post(Uri.parse(ApiRoutes.getBanners),
        headers: ApiHeaders().getHeaderAccessToken(), body: jsonEncode(jsonData))
        .timeout(ApiHeaders().timeOut)
        .catchError((value) {
      throw Strings.errorServeTimeOut;
    });
    Map<String, dynamic> decodeJson = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Banners> banners = [];
      for (var item in decodeJson['data']['items']) {
        banners.add(BannerMapper.bannerJsonToEntity(item));
      }
      return banners;
    } else {
      throw decodeJson['message'];
    }
  }

}