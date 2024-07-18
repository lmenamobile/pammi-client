
import '../../domain/domain.dart';

class BannerRepositoryImpl implements BannerRepository {

  final BannerDatasource remoteDataSource;

  BannerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Banners>> getBanners(String typeBanner, int page) async {
    final banners = await remoteDataSource.getBanners(typeBanner, page);
    return banners;
  }
}