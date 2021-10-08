import 'package:wawamko/src/Models/ShopCart/ProductShopCart.dart';

import 'ProviderProduct.dart';


class PackagesProvider {
  PackagesProvider({
    this.provider,
    this.products,
  });

  ProviderProduct? provider;
  List<ProductShopCart>? products;

  factory PackagesProvider.fromJson(Map<String, dynamic> json) => PackagesProvider(
    provider: ProviderProduct.fromJson(json["provider"]),
    products: List<ProductShopCart>.from(json["products"].map((x) => ProductShopCart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "provider": provider!.toJson(),
    "products": List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}