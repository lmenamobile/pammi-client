import 'PackageProvider.dart';
import 'TotalCart.dart';

class ShopCart {
  ShopCart({
    this.packagesProvider,
    this.totalCart,
  });

  List<PackagesProvider> packagesProvider;
  TotalCart totalCart;

  factory ShopCart.fromJson(Map<String, dynamic> json) => ShopCart(
    packagesProvider: List<PackagesProvider>.from(json["packages"].map((x) => PackagesProvider.fromJson(x))),
    totalCart: TotalCart.fromJson(json["cart"]),
  );

}