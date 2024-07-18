
import '../domain.dart';

abstract class BannerDatasource {
  Future<List<Banners>> getBanners(String typeBanner, int page);
}