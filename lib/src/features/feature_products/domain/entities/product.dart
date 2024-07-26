
import '../domain.dart';

class Product {

  final int productId;
  final String sku;
  final String nameProduct;
  final String characteristics;
  final String linkVideo;
  final String conditions;
  final bool featured;
  final bool service;
  final bool applyDevolution;
  final BrandProvider brandProvider;
  final Warranty warranty;
  final List<Reference> references;


  Product({
    required this.productId,
    required this.sku,
    required this.nameProduct,
    required this.characteristics,
    required this.linkVideo,
    required this.conditions,
    required this.featured,
    required this.service,
    required this.applyDevolution,
    required this.brandProvider,
    required this.warranty,
    required this.references,
  });

  Reference? get getPrincipalReference {
    if (references.isEmpty) {
      return null;
    }
    try {
      return references.firstWhere((element) => element.isPrincipal);
    } catch (e) {
      return references.first;
    }
  }

  @override
  String toString () {
    return 'Product(id: $productId, sku: $sku, nameProduct: $nameProduct, characteristics: $characteristics, linkVideo: $linkVideo, conditions: $conditions, featured: $featured, service: $service, applyDevolution: $applyDevolution, brandProvider: $brandProvider, warranty: $warranty)';
  }



}