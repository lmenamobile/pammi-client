
import '../domain.dart';

abstract class BannerRepository {
  Future<List<Banners>> getBanners( String typeBanner, int page);
}