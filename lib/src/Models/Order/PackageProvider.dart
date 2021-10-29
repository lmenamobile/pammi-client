import 'package:wawamko/src/Models/Order/ProductProvider.dart';
import 'package:wawamko/src/Models/ShopCart/ProviderProduct.dart';

class PackageProvider {
  PackageProvider({
    this.id,
    this.subtotal,
    this.tax,
    this.total,
    this.discountCoupon,
    this.discountGiftCard,
    this.shippingValue,
    this.status,
    this.guide,
    this.productsProvider,
    this.providerProduct,
  });

  int? id;
  String? subtotal;
  String? tax;
  String? total;
  String? discountCoupon;
  String? discountGiftCard;
  String? shippingValue;
  String? status;
  String? guide;
  ProviderProduct? providerProduct;
  List<ProductProvider>? productsProvider;


  factory PackageProvider.fromJson(Map<String, dynamic> json) => PackageProvider(
    id: json["id"],
    subtotal: json["subtotal"].toString(),
    tax: json["tax"].toString(),
    total: json["total"].toString(),
    discountCoupon: json["discountCoupon"].toString(),
    discountGiftCard: json["discountGiftcard"].toString(),
    shippingValue: json["shippingValue"].toString(),
    status: json["status"],
    guide:  json["guide"],
    providerProduct: json["provider"]==null?null:ProviderProduct.fromJson(json["provider"]),
    productsProvider: List<ProductProvider>.from(json["products"].map((x) => ProductProvider.fromJson(x))),
  );


}