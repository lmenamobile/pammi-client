
import '../domain.dart';

class Product {

  final int id;
  final String sku;
  final String nameProduct;
  final String characteristics;
  final String linkVideo;
  final String conditions;
  final bool featured;
  final String weight;
  final String volume;
  final BrandProvider brandProvider;

  final bool service;
  final Warranty warranty;


  Product({
    required this.id,
    required this.sku,
    required this.nameProduct,
    required this.characteristics,
    required this.linkVideo,
    required this.conditions,
    required this.featured,
    required this.weight,
    required this.volume,
    required this.brandProvider,
    required this.warranty,
    required this.service,
  });



  @override
  toString() {
    return 'Product(id: $id, sku: $sku, nameProduct: $nameProduct, characteristics: $characteristics, linkVideo: $linkVideo, conditions: $conditions, featured: $featured, weight: $weight, volume: $volume, brandProvider: $brandProvider, warranty: $warranty, service: $service)';
  }




}