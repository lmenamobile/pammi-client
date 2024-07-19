import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class BannersProvider extends ChangeNotifier {

  final BannerRepository _repository;
  BannersProvider({required BannerRepository repository}) : _repository = repository;

  List<Banners> _banners = [];
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 0;
  bool _hasMorePages = true;
  String _currentBanner = "";
  int indexBanner = 0;


  List<Banners> get banners => _banners;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasMorePages => _hasMorePages;

  void updateBannerIndex(int index){
    indexBanner = index;
    notifyListeners();
  }

  Future<void> loadBanners({bool refresh = false, String typeBanner = "",}) async {
    if (refresh) {
      _currentPage = 0;
      _banners.clear();
      _hasMorePages = true;
    }

    if (_isLoading || !_hasMorePages) return;
    _isLoading = true;
    _currentBanner = typeBanner;
    _error = '';
    notifyListeners();
    try {
      final newBanners = await _repository.getBanners(typeBanner, _currentPage);

      if (newBanners.isEmpty) {
        _hasMorePages = false;
      } else {
        _banners.addAll(newBanners);
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetPagination(){
    _currentPage = 0;
    _currentBanner = "";
    _banners.clear();
    _hasMorePages = true;
    notifyListeners();
  }

  Future<void> refreshBanners({String typeBanner = ""}) async {
    resetPagination();
    await loadBanners(typeBanner: typeBanner);
  }

  Future<void> loadMoreBanners() async {
    if (!_isLoading && _hasMorePages) {
      await loadBanners(typeBanner: _currentBanner);
    }
  }


}