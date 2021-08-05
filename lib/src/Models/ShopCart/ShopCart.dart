import 'package:wawamko/src/Models/ShopCart/ProductShopCart.dart';

import 'PackageProvider.dart';
import 'TotalCart.dart';

class ShopCart {
  ShopCart({
    this.packagesProvider,
    this.totalCart,
    this.products
  });

  List<PackagesProvider> packagesProvider;
  List<ProductShopCart> products;
  TotalCart totalCart;

  factory ShopCart.fromJson(Map<String, dynamic> json) => ShopCart(
    packagesProvider: List<PackagesProvider>.from(json["packages"].map((x) => PackagesProvider.fromJson(x))),
    products: List<ProductShopCart>.from(json["products"].map((x) => ProductShopCart.fromJson(x))),
    totalCart: TotalCart.fromJson(json["cart"]),
  );

}